% --- Load the two .set files (ensure file paths are correct) ---
EEG_color = pop_loadset('filename', '350726CleanV1.set', ...
    'filepath', 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\cleaned grey + stimulus .set files\');
EEG_greyscale = pop_loadset('filename', '350726GreyV1.set', ...
    'filepath', 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\cleaned grey + stimulus .set files\');

% --- (Optional) Check array dimensions ---
disp('EEG_color.data size:');
disp(size(EEG_color.data));   % Expected: [8 250 85]
disp('EEG_greyscale.data size:');
disp(size(EEG_greyscale.data));  % Expected: [8 250 812]

% --- Compute the average waveform for each dataset over epochs (3rd dimension) ---
color_avg = mean(EEG_color.data, 3);       % Result: [8 x 250]
greyscale_avg = mean(EEG_greyscale.data, 3); % Result: [8 x 250]

% --- Compute the difference waveform (color average minus greyscale average) ---
diff_waveform = color_avg - greyscale_avg;   % Result: [8 x 250]

% --- Define the time window for plotting (in ms) ---
tmin_plot = -100;
tmax_plot = 600;
timeIdx = find(EEG_color.times >= tmin_plot & EEG_color.times <= tmax_plot);

% --- Choose channel 3 for plotting ---
chanIdx = 3;

% --- Plot the three waveforms ---
figure;
plot(EEG_color.times(timeIdx), color_avg(chanIdx, timeIdx), 'b', 'LineWidth', 2);
hold on;
plot(EEG_color.times(timeIdx), greyscale_avg(chanIdx, timeIdx), 'r', 'LineWidth', 2);
plot(EEG_color.times(timeIdx), diff_waveform(chanIdx, timeIdx), 'k', 'LineWidth', 2);
xlabel('Time (ms)');
ylabel('Amplitude (µV)');
title('Averaged Waveforms (Channel 3)');
legend('On-Target Pictures', 'Greyscale Pictures', 'Difference (Colour - Greyscale)');
grid on;
hold off;
