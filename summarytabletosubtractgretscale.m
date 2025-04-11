%% make_summary_and_subtract_greyscale.m
clear; clc;
eeglab nogui; close;

%% 1) LOAD & PIVOT MASTER TABLE
folderPath     = 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info';
load(fullfile(folderPath,'masterOddballTableAveragedPeakProperly.mat'));
% masterTable: Participant_ID, Condition, Average_Waveform (–200:800 ms), Peak_p300, User_Type

participants   = unique(masterTable.Participant_ID);
nParticipants  = numel(participants);

peakVals     = nan(nParticipants,4);
userTypeVals = cell(nParticipants,1);
waveVals     = cell(nParticipants,4);  % 250×1 vectors here

for i = 1:nParticipants
    pid  = participants{i};
    rows = masterTable(strcmp(masterTable.Participant_ID,pid), :);
    userTypeVals{i} = rows.User_Type{1};
    for cond = 1:4
        sel = strcmp(rows.Condition, num2str(cond));
        if any(sel)
            peakVals(i,cond)    = rows.Peak_p300(sel);
            waveVals{i,cond}    = vertcat(rows.Average_Waveform{sel});  % 250×1
        else
            waveVals{i,cond}    = [];
        end
    end
end

summaryTable = table( ...
    participants, ...
    peakVals(:,1), peakVals(:,2), peakVals(:,3), peakVals(:,4), ...
    waveVals(:,1), waveVals(:,2), waveVals(:,3), waveVals(:,4), ...
    userTypeVals, ...
    'VariableNames',{ ...
      'Participant_ID', ...
      'Cigarette','Neutral','Pouch','ECigarette', ...
      'CigaretteWaveforms','NeutralWaveforms','PouchWaveforms','ECigaretteWaveforms', ...
      'User_Type'} );

%% 2) CROP ALL WAVEFORMS TO –100:600 ms
L = numel(waveVals{find(~cellfun(@isempty,waveVals(:,1)),1),1});
origTime = linspace(-200,800,L);
cropIdx  = origTime >= -100 & origTime <= 600;
newLen   = sum(cropIdx);  % should be 176 if fs=250Hz

conds = {'Cigarette','Neutral','Pouch','ECigarette'};
for c = 1:4
    colName = [conds{c} 'Waveforms'];
    W = summaryTable.(colName);
    for i = 1:nParticipants
        w = W{i};
        if ~isempty(w)
            W{i} = w(cropIdx);   % now newLen×1
        end
    end
    summaryTable.(colName) = W;
end

%% 3) SUBTRACT GREYSCALE (CHANNEL 3 AVERAGED OVER –100:600 ms)
greyFolder = fullfile(folderPath,'cleaned grey only');
assert(isfolder(greyFolder), 'Folder not found: %s', greyFolder);

gsFiles = dir(fullfile(greyFolder,'*.set'));
gsNames = {gsFiles.name};

% prepare new diff columns
diffCols = strcat(conds,'MinusGrey');
for c = 1:4
    summaryTable.(diffCols{c}) = cell(nParticipants,1);
end

for i = 1:nParticipants
    fullPID = summaryTable.Participant_ID{i};
    numID   = regexp(fullPID,'^\d+','match','once');
    if isempty(numID), continue; end

    % load & epoch grey set
    idxG = find(startsWith(gsNames,numID),1);
    if isempty(idxG), continue; end
    EEGg = pop_loadset('filename',gsNames{idxG},'filepath',greyFolder);
    EEGg = pop_epoch(EEGg, {'1','2','3','4'}, [-0.1 0.6], 'epochinfo','yes');

    % channel 3: time×trials
    chan3_G = squeeze(EEGg.data(3,:,:));  % [time × trials]

    % compute a separate greyscale average for each condition
    evtTypes  = {EEGg.epoch.eventtype};
    condCodes = str2double(evtTypes);
    greyWaves = cell(1,4);
    for cond = 1:4
        idx = (condCodes == cond);
        if any(idx)
            greyWaves{cond} = mean(chan3_G(:,idx), 2);
        else
            greyWaves{cond} = nan(size(chan3_G,1),1);
        end
    end

    % subtract the *condition‑matched* greyscale average
    for c = 1:4
        orig = summaryTable.([conds{c} 'Waveforms']){i};  % [time×1]
        gw   = greyWaves{c};                             % [time×1]
        if numel(orig)==numel(gw)
            summaryTable.(diffCols{c}){i} = orig - gw;
        else
            summaryTable.(diffCols{c}){i} = [];
        end
    end
end  % <-- added END to close the for i loop

%% …after you’ve filled summaryTable.CigaretteMinusGrey etc…

% 1) Build the time‑vector for your cropped window (–100 to 600 ms)
timeVec = linspace(-100,600,newLen);

% 2) Find the indices corresponding to 200–350 ms
peakIdx = timeVec >= 200 & timeVec <= 350;

% 3) Pre‑allocate and compute peak amplitude for each condition
for c = 1:4
    peakVals = nan(nParticipants,1);
    for i = 1:nParticipants
        w = summaryTable.(diffCols{c}){i};  % newLen×1 vector
        if ~isempty(w)
            peakVals(i) = max(w(peakIdx));   % positive peak
        end
    end
    summaryTable.([diffCols{c} '_Peak200_350']) = peakVals;
end

%% 5) Now save
outFile = fullfile(folderPath,'mastersummarytablewithgreyscalesubtracted.mat');
save(outFile,'summaryTable');
