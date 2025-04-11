%% subtract_greyscale_from_raw_epochs.m
clear; clc;
eeglab nogui; close;

%% 1) Load your summary table (just for Participant_ID)
load('C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info\summaryTableWithEpochs.mat','summaryTable');

%% 2) Define your folders
baseFolder    = 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info';
oddballFolder = baseFolder;  % your oddball .set files live here
greyFolder    = fullfile(baseFolder,'cleaned grey only');

assert(isfolder(oddballFolder),'Oddball folder not found: %s', oddballFolder);
assert(isfolder(greyFolder),   'Grey folder not found:   %s', greyFolder);

oddFiles = dir(fullfile(oddballFolder,'*.set'));
oddNames = {oddFiles.name};
gsFiles  = dir(fullfile(greyFolder,   '*.set'));
gsNames  = {gsFiles.name};

%% 3) Prepare output columns in summaryTable
nP = height(summaryTable);
conds    = {'Cigarette','Neutral','Pouch','ECigarette'};
diffVars = strcat(conds,'MinusGrey');
for c = 1:4
    summaryTable.(diffVars{c}) = cell(nP,1);
end

%% 4) Loop participants
for i = 1:nP
    fullPID = summaryTable.Participant_ID{i};       % e.g. '142154CleanV1'
    numID   = regexp(fullPID,'^\d+','match','once');% '142154'
    if isempty(numID)
        warning('Bad PID format: %s', fullPID);
        continue;
    end

    %% 4a) Load & epoch the oddball data
    idxO = find(startsWith(oddNames,numID),1);
    if isempty(idxO)
        warning('No oddball .set for %s', fullPID);
        continue;
    end
    EEGo = pop_loadset('filename', oddNames{idxO}, 'filepath', oddballFolder);
    % assumes events '1','2','3','4' mark your 4 conditions
    EEGo = pop_epoch(EEGo, {'1','2','3','4'}, [-0.2 0.8], 'epochinfo','yes');
    dataO = EEGo.data;  % channels×time×trials

    % average across channels → 1×time×trials, then squeeze → time×trials
    chanMeanO = squeeze(mean(dataO,1))';  % trials×time

    % get each trial's condition code
    evtTypes = {EEGo.epoch.eventtype};
    condCodes = str2double(evtTypes);

    rawByCond = cell(1,4);
    for c = 1:4
        rawByCond{c} = chanMeanO(condCodes==c, :);  % nEpochs×nTime
    end

    %% 4b) Load & epoch the greyscale data
    idxG = find(startsWith(gsNames,numID),1);
    if isempty(idxG)
        warning('No grey .set for %s', fullPID);
        continue;
    end
    EEGg = pop_loadset('filename', gsNames{idxG}, 'filepath', greyFolder);
    EEGg = pop_epoch(EEGg, {'1','2','3','4'}, [-0.2 0.8], 'epochinfo','yes');
    dataG = EEGg.data;  % channels×time×trials

    % compute the grand average across trials then channels
    avgG_trials = squeeze(mean(dataG,3));  % channels×time
    greyWave    = mean(avgG_trials,1);     % 1×time

    %% 4c) Subtract grey average from each oddball epoch
    for c = 1:4
        R = rawByCond{c};  % nEpochs×nTime
        if isempty(R)
            warning(' %s cond %d: no oddball epochs', fullPID, c);
            continue;
        end
        if size(R,2) ~= numel(greyWave)
            warning(' %s cond %d: time mismatch (%d vs %d)', ...
                fullPID, c, size(R,2), numel(greyWave));
            continue;
        end
        % subtract grey waveform from each row (epoch)
        summaryTable.(diffVars{c}){i} = R - greyWave;
    end
end

%% 5) Save out the augmented table
outFile = fullfile(baseFolder,'summaryTable_WithGreyDiffs.mat');
save(outFile,'summaryTable');
fprintf('Done! Saved to:\n  %s\n', outFile);
