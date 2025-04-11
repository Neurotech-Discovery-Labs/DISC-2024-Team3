% ==========================
% STATIC VARIABLES
% ==========================

STREAM_NUM_EEG = 2;
STREAM_NUM_MARKER = 1;
EEG_LABELS = {'Fz', 'C3', 'Cz', 'C4', 'Pz', 'PO7', 'Oz', 'PO8'};

% ==========================
% LOAD DATA FROM THE CURRENT DIRECTORY (Expects one XDF)
% ==========================

% Get list of XDF files in the current folder
files = dir('*.xdf');

% Check if any XDF files exist
if isempty(files)
    error('No XDF files found in the current directory.');
else
    % Load the first (or only) XDF file
    filename = files(1).name;
    disp(['Loading XDF file: ', filename]);
    data = load_xdf(filename);
end

% Start EEGLAB without GUI
eeglab nogui;

% ==========================
% PROCESS EEG CHANNELS
% ==========================

% Extract EEG data (first 8 channels only)
eeg_data = data{STREAM_NUM_EEG}.time_series(1:8, :); 

% Sampling rate from Unicorn stream
srate = str2double(data{STREAM_NUM_EEG}.info.nominal_srate); 

% Time vector for EEG data
time_stamps = data{STREAM_NUM_EEG}.time_stamps - data{STREAM_NUM_EEG}.time_stamps(1); % Normalize to start at 0

% Create a new EEGLAB dataset from the EEG array
EEG = pop_importdata('dataformat', 'array', 'nbchan', 8, ...
                     'data', eeg_data, 'srate', srate, ...
                     'xmin', time_stamps(1));

% Assign channel labels
for i = 1:length(EEG_LABELS)
    EEG.chanlocs(i).labels = EEG_LABELS{i};
end

% Assign electrode locations from standard EEGLAB file
EEG = pop_chanedit(EEG, 'lookup', 'standard-10-5-cap385.sfp');

% ==========================
% PROCESS PSYCHOPY TRIGGERS
% ==========================

% Extract trigger timestamps and values from PsychoPyMarkers
trigger_times = data{STREAM_NUM_MARKER}.time_stamps;
trigger_values = data{STREAM_NUM_MARKER}.time_series;

% Define trigger categories using a numeric array
trigger_groups = [
    0, 1.0001, 1;  % pic 1
    1.00019, 1.0011, 2;  % pic 2
    1.0019, 1.0031, 3;  % pic 3
    1.0039, 1.0041, 4;  % pic 4
    1.0049, 1.0051, 5;  % pic 5
];

%og trigger groups
% trigger_groups = [
%     1.09, 1.19, 1;  % Group 1 cigarette
%     1.199, 1.29, 2;  % Group 2 neutral
%     1.299, 1.39, 3;  % Group 3 pouch
%     1.399, 1.49, 4;  % Group 4 e-cigarette
%     % 1.200, 1.249, 3;  % Group 5
%     % 1.250, 1.299, 4   % Group 6

    % Initialize EEGLAB event structure
EEG.event = struct([]);

% Process and categorize triggers
event_count = 0;
for i = 1:length(trigger_values)
    % Check which group the value belongs to
    for j = 1:size(trigger_groups, 1)
        if trigger_values(i) >= trigger_groups(j, 1) && trigger_values(i) <= trigger_groups(j, 2)
            event_count = event_count + 1;
            EEG.event(event_count).type = num2str(trigger_groups(j, 3)); % Convert group number to string
            EEG.event(event_count).latency = (trigger_times(i) - data{STREAM_NUM_EEG}.time_stamps(1)) * EEG.srate;
            break;
        end
    end
end

% Save dataset as EEGLAB .set file
pop_saveset(EEG, 'filename', 'unicorn_eeg_raw.set', 'filepath', '');

% ==========================
% PREPROCESS EEG
% ==========================

% % Apply a high-pass filter at 1 Hz to remove drifts
% EEG = pop_eegfiltnew(EEG, 1, []); 
% 
% % Apply a low-pass filter at 50 Hz to remove high-frequency noise
% EEG = pop_eegfiltnew(EEG, [], 50);
% 
% % OPTIONAL: Apply a notch filter to remove 50 Hz powerline noise (adjust if needed)
% EEG = pop_eegfiltnew(EEG, 58, 62, [], 1);


% ==========================
% SAVE THE PREPROCESSED DATA
% ==========================

% Save dataset as EEGLAB .set file
pop_saveset(EEG, 'filename', 'unicorn_eeg_cleaned.set', 'filepath', '');


% ========================
% STEP 2: Epoch Data Around Triggers
% ========================

% Define epoch window: -200ms to 800ms (in seconds)
epoch_window = [-0.2 0.8]; 

% Extract unique event types (from PsychoPy triggers)
event_types = unique({EEG.event.type}); % Get all trigger labels

% Epoch the data around triggers
EEG = pop_epoch(EEG, event_types, epoch_window, 'epochinfo', 'yes');

% Baseline correction (normalize each epoch to pre-stimulus mean)
EEG = pop_rmbase(EEG, [-200 0]); % Baseline from -200ms to 0ms

% Save final dataset
pop_saveset(EEG, 'filename', 'unicorn_eeg_epochs.set', 'filepath', '');

%save to  matlab
save('unicorn_eeg_epochs.mat', 'EEG');


%% Plot Average Waveforms for Each Channel and Group
% This section assumes that each epoch corresponds to one trigger and that
% the trigger type (a string like '1', '2', etc.) is stored in EEG.event.
% We create a grouping vector for each epoch based on its first event.

num_trials = EEG.trials;
epoch_groups = zeros(1, num_trials);
for i = 1:num_trials
    % Each EEG.epoch(i).event is a cell array of event indices.
    % We use the first event to determine the group.
    if iscell(EEG.epoch(i).event)
        event_idx = EEG.epoch(i).event{1};
    else
        event_idx = EEG.epoch(i).event(1);
    end
    % Convert trigger type (stored in EEG.event) to a number.
    epoch_groups(i) = str2double(EEG.event(event_idx).type);
end

% Define the unique groups (should be 1 through 6)
unique_groups = 1:6;

% Get dimensions: channels x time points x trials
[num_channels, ~, ~] = size(EEG.data);

% Create a figure with one subplot per channel (here, arranged as 2 rows x 4 columns)
figure;
for ch = 1:num_channels
    subplot(2, 4, ch);
    hold on;
    
    % Loop through each group to plot its average waveform for the current channel.
    for g = unique_groups
        % Find the trial indices for the current group.
        trial_idx = find(epoch_groups == g);
        
        % Compute the average waveform across these trials.
        % EEG.data dimensions are [channels x time x trials].
        avg_waveform = mean(EEG.data(ch, :, trial_idx), 3);
        
        % Plot the averaged waveform against time.
        % EEG.times should contain the time vector for the epochs.
        plot(EEG.times, avg_waveform, 'LineWidth', 2);
    end
    
    % Add title and axis labels.
    title(EEG.chanlocs(ch).labels);
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Create a legend for the groups.
    legend(arrayfun(@(x) sprintf('Group %d', x), unique_groups, 'UniformOutput', false), 'Location', 'Best');
    hold off;
end





