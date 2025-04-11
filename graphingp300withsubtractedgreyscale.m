% % plot_greyscale_subtracted_results.m
% clear; clc;
% 
% % 1) Load the summary table with greyscale‑subtracted data
% folderPath   = 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info';
% tblFile      = fullfile(folderPath,'mastersummarytablewithgreyscalesubtracted.mat');
% load(tblFile,'summaryTable');
% 
% nParticipants = height(summaryTable);
% 
% % 2) Pull out the 175×1 difference waveforms into a cell array
% diffCols = {'CigaretteMinusGrey','NeutralMinusGrey','PouchMinusGrey','ECigaretteMinusGrey'};
% waveforms = cell(nParticipants,4);
% for c = 1:4
%     waveforms(:,c) = summaryTable.(diffCols{c});
% end
% 
% % ---- BASELINE CORRECTION ----
% Make timeVec for the 175 samples spanning -100 to 600 ms
% if ~isempty(waveforms{1,1})
%     L = length(waveforms{1,1});
% else
%     L = 175;  % fallback
% end
% timeVec     = linspace(-100,600,L);
% baselineIdx = timeVec < 0;
% 
% Baseline‐correct each difference waveform
% waveforms_corr = cell(nParticipants,4);
% for i = 1:nParticipants
%     for cond = 1:4
%         cur = waveforms{i,cond};
%         if ~isempty(cur)
%             waveforms_corr{i,cond} = cur - mean(cur(baselineIdx));
%         else
%             waveforms_corr{i,cond} = [];
%         end
%     end
% end
% 
% % --- SEPARATE GROUPS ---
% nicotineUsers    = summaryTable(~strcmp(summaryTable.User_Type,'Non-nicotine user'), :);
% nonNicotineUsers = summaryTable( strcmp(summaryTable.User_Type,'Non-nicotine user'), :);
% fprintf('Number of Nicotine Users: %d\n', height(nicotineUsers));
% fprintf('Number of Non-Nicotine Users: %d\n', height(nonNicotineUsers));
% 
% % GRAPH 1: Grouped Bar Chart of *Difference* Peaks (200–350 ms)
% use the precomputed peak columns:
% peakCols = strcat(diffCols,'_Peak200_350');  
% conditionList = peakCols;  % same order
% 
% avgNicotine    = varfun(@nanmean, nicotineUsers,    'InputVariables',peakCols);
% avgNonNicotine = varfun(@nanmean, nonNicotineUsers, 'InputVariables',peakCols);
% stdNicotine    = varfun(@nanstd,  nicotineUsers,    'InputVariables',peakCols);
% stdNonNicotine = varfun(@nanstd,  nonNicotineUsers, 'InputVariables',peakCols);
% 
% nNic = height(nicotineUsers);
% nNon = height(nonNicotineUsers);
% 
% seNic  = [ stdNicotine.nanstd_CigaretteMinusGrey_Peak200_350, ...
%            stdNicotine.nanstd_NeutralMinusGrey_Peak200_350, ...
%            stdNicotine.nanstd_PouchMinusGrey_Peak200_350, ...
%            stdNicotine.nanstd_ECigaretteMinusGrey_Peak200_350 ] / sqrt(nNic);
% 
% seNon  = [ stdNonNicotine.nanstd_CigaretteMinusGrey_Peak200_350, ...
%            stdNonNicotine.nanstd_NeutralMinusGrey_Peak200_350, ...
%            stdNonNicotine.nanstd_PouchMinusGrey_Peak200_350, ...
%            stdNonNicotine.nanstd_ECigaretteMinusGrey_Peak200_350 ] / sqrt(nNon);
% 
% nicMeans    = [ avgNicotine.nanmean_CigaretteMinusGrey_Peak200_350, ...
%                 avgNicotine.nanmean_NeutralMinusGrey_Peak200_350, ...
%                 avgNicotine.nanmean_PouchMinusGrey_Peak200_350, ...
%                 avgNicotine.nanmean_ECigaretteMinusGrey_Peak200_350 ];
% 
% nonNicMeans = [ avgNonNicotine.nanmean_CigaretteMinusGrey_Peak200_350, ...
%                 avgNonNicotine.nanmean_NeutralMinusGrey_Peak200_350, ...
%                 avgNonNicotine.nanmean_PouchMinusGrey_Peak200_350, ...
%                 avgNonNicotine.nanmean_ECigaretteMinusGrey_Peak200_350 ];
% 
% groupMeans = [nonNicMeans; nicMeans]';  % 4×2
% 
% figure;
% hBar = bar(groupMeans);
% set(gca,'XTickLabel',{'Cigarette','Neutral','Pouch','E-Cigarette'});
% xlabel('Condition');
% ylabel('Average Difference Peak (200–350 ms) (\muV)');
% title('Graph 1: Group Average Difference Peak by Condition');
% legend('Non-Nicotine','Nicotine','Location','Best');
% grid on; hold on;
% 
% xNon = hBar(1).XEndPoints;
% xNic = hBar(2).XEndPoints;
% errorbar(xNon,groupMeans(:,1),seNon,'k','linestyle','none','LineWidth',1);
% errorbar(xNic,groupMeans(:,2),seNic,'k','linestyle','none','LineWidth',1);
% hold off;
% 
% % GRAPH 2: Overall Averages per Condition (Neutral Separated)
% overallGroup = [nonNicMeans; nicMeans];  % 2×4
% reorder to Neutral first:
% ogR = overallGroup(:,[2,1,3,4]);
% dummy = nan(2,1);
% ogNew = [ogR(:,1), dummy, ogR(:,2:end)];  % 2×5
% 
% reorder SEs similarly
% seNonR = seNon([2,1,3,4]);
% seNicR = seNic([2,1,3,4]);
% seNewNon = [seNonR(1), nan, seNonR(2:end)];
% seNewNic = [seNicR(1), nan, seNicR(2:end)];
% 
% figure;
% hBar2 = bar(ogNew,'grouped');
% colors: Neutral=black, Cig=yellow, Pouch=magenta, ECig=green
% hBar2(1).FaceColor = [0 0 0];
% hBar2(3).FaceColor = [0.9290 0.6940 0.1250];
% hBar2(4).FaceColor = [0.4940 0.1840 0.5560];
% hBar2(5).FaceColor = [0.4660 0.6740 0.1880];
% hBar2(2).HandleVisibility = 'off';
% 
% set(gca,'XTickLabel',{'Non-Nicotine','Nicotine'});
% xlabel('User Type');
% ylabel('Average Difference Peak (\muV)');
% title('Graph 2: Difference Peak by Condition & User Type');
% hBar2(1).DisplayName='Neutral';
% hBar2(3).DisplayName='Cigarette';
% hBar2(4).DisplayName='Pouch';
% hBar2(5).DisplayName='E-Cigarette';
% legend('Location','Best');
% grid on; hold on;
% for k=1:5
%     if ~isnan(seNewNon(k))
%         pts = hBar2(k).XEndPoints;
%         errorbar(pts(1),ogNew(1,k),seNewNon(k),'k','linestyle','none','LineWidth',1);
%         errorbar(pts(2),ogNew(2,k),seNewNic(k),'k','linestyle','none','LineWidth',1);
%     end
% end
% hold off;
% 
% % GRAPH 3: Differences Between Neutral and Other Conditions
% compute per‐participant diff of the difference‐peaks
% nic = nicotineUsers; non = nonNicotineUsers;
% ndC = nic.CigaretteMinusGrey_Peak200_350 - nic.NeutralMinusGrey_Peak200_350;
% ndP = nic.PouchMinusGrey_Peak200_350   - nic.NeutralMinusGrey_Peak200_350;
% ndE = nic.ECigaretteMinusGrey_Peak200_350 - nic.NeutralMinusGrey_Peak200_350;
% nndC= non.CigaretteMinusGrey_Peak200_350 - non.NeutralMinusGrey_Peak200_350;
% nndP= non.PouchMinusGrey_Peak200_350   - non.NeutralMinusGrey_Peak200_350;
% nndE= non.ECigaretteMinusGrey_Peak200_350 - non.NeutralMinusGrey_Peak200_350;
% 
% avgDiffNic  = [mean(ndC,'omitnan'), mean(ndP,'omitnan'), mean(ndE,'omitnan')];
% avgDiffNon  = [mean(nndC,'omitnan'),mean(nndP,'omitnan'),mean(nndE,'omitnan')];
% stdDiffNic  = [std(ndC,'omitnan'),   std(ndP,'omitnan'),   std(ndE,'omitnan')];
% stdDiffNon  = [std(nndC,'omitnan'),  std(nndP,'omitnan'),  std(nndE,'omitnan')];
% seDiffNic   = stdDiffNic  / sqrt(height(nic));
% seDiffNon   = stdDiffNon  / sqrt(height(non));
% 
% groupDiffMeans = [avgDiffNon; avgDiffNic]';  % 3×2
% 
% figure;
% hBar3 = bar(groupDiffMeans);
% set(gca,'XTickLabel',{'Cig-Neut','Pouch-Neut','E-Cig-Neut'});
% xlabel('Condition Difference');
% ylabel('Avg Difference of Difference Peaks (\muV)');
% title('Graph 3: Differences Between Conditions');
% legend('Non-Nicotine','Nicotine','Location','Best');
% grid on; hold on;
% for g=1:3
%     errorbar(hBar3(1).XEndPoints(g), groupDiffMeans(g,1), seDiffNon(g),'k','linestyle','none','LineWidth',1);
%     errorbar(hBar3(2).XEndPoints(g), groupDiffMeans(g,2), seDiffNic(g),   'k','linestyle','none','LineWidth',1);
% end
% hold off;
% 
% % custom colours & ordering for Graphs 4 & 5
% customColors = [0 0 0; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880];
% colorMap     = [2,1,3,4];
% desiredOrder = [1,3,4,2];
% conditionList= {'Cigarette','Neutral','Pouch','ECigarette'};
% userTypeVals = summaryTable.User_Type;
% 
% % ─── BUILD & BASELINE‐CORRECT DIFF WAVEFORMS ───
% Pull the 175×1 difference vectors out of the table
% diffCols = {'CigaretteMinusGrey','NeutralMinusGrey','PouchMinusGrey','ECigaretteMinusGrey'};
% nP       = height(summaryTable);
% diffWF   = cell(nP,4);
% for c = 1:4
%     diffWF(:,c) = summaryTable.(diffCols{c});
% end
% 
% Determine L and timeVec
% firstNonEmpty = find(~cellfun(@isempty,diffWF(:,1)),1);
% L             = numel(diffWF{firstNonEmpty,1});    % should be 175
% timeVec       = linspace(-100,600,L);
% baselineIdx   = timeVec < 0;
% 
% Baseline‐correct each difference waveform
% diffWaveforms_corr = cell(nP,4);
% for i = 1:nP
%   for c = 1:4
%     w = diffWF{i,c};
%     if ~isempty(w)
%       diffWaveforms_corr{i,c} = w - mean(w(baselineIdx));
%     end
%   end
% end
% 
% %% GRAPH 4: Avg Difference Waveform (Non‑Nicotine Users)
% nonIdx = strcmp(summaryTable.User_Type,'Non-nicotine user');
% L      = numel(waveforms_corr{1,1});      % should be 175
% timeVec = linspace(-100,600,L);
% 
% figure; hold on;
% hPlot = gobjects(1,4);   % preallocate handle array
% for cond = 1:4
%     C = waveforms_corr(nonIdx,cond);        
%     M = cell2mat(C')';                      
%     avgWave = mean(M,1,'omitnan');
%     % capture the handle here:
%     hPlot(cond) = plot(timeVec, avgWave, 'LineWidth',2, ...
%         'Color', customColors(colorMap(cond),:), ...
%         'DisplayName', conditionList{cond});
% end
% xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
% title('Graph 4: Avg Difference Waveform (Non‑Nicotine Users)');
% % use hPlot here:
% legend(hPlot(desiredOrder), conditionList(desiredOrder), 'Location','best');
% grid on; hold off;
% 
% 
% %% GRAPH 5: Avg Difference Waveform (Nicotine Users)
% nicIdx = ~nonIdx;
% 
% figure; hold on;
% hPlot_n = gobjects(1,4);  % preallocate handle array
% for cond = 1:4
%     C = waveforms_corr(nicIdx,cond);        
%     M = cell2mat(C')';                      
%     avgWave = mean(M,1,'omitnan');          
%     % capture the handle here:
%     hPlot_n(cond) = plot(timeVec, avgWave, 'LineWidth',2, ...
%         'Color', customColors(colorMap(cond),:), ...
%         'DisplayName', conditionList{cond});
% end
% xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
% title('Graph 5: Avg Difference Waveform (Nicotine Users)');
% % use hPlot_n here:
% legend(hPlot_n(desiredOrder), conditionList(desiredOrder), 'Location','best');
% grid on; hold off;
% 

% plot_greyscale_subtracted_results.m
clear; clc;

%% 1) Load the summary table with greyscale‑subtracted data
folderPath   = 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info';
tblFile      = fullfile(folderPath,'mastersummarytablewithgreyscalesubtracted.mat');
load(tblFile,'summaryTable');

nParticipants = height(summaryTable);

%% 1.5) Point to the greyscale‐only sets
greyFolder = fullfile(folderPath,'cleaned grey only');
gsFiles    = dir(fullfile(greyFolder,'*.set'));
gsNames    = {gsFiles.name};

%% 2) Pull out the 175×1 difference waveforms into a cell array
diffCols = {'CigaretteMinusGrey','NeutralMinusGrey','PouchMinusGrey','ECigaretteMinusGrey'};
waveforms = cell(nParticipants,4);
for c = 1:4
    waveforms(:,c) = summaryTable.(diffCols{c});
end

%% ---- BASELINE CORRECTION ----
% Make timeVec for the 175 samples spanning -100 to 600 ms
if ~isempty(waveforms{1,1})
    L = length(waveforms{1,1});
else
    L = 175;  % fallback
end
timeVec     = linspace(-100,600,L);
baselineIdx = timeVec < 0;

% Baseline‐correct each difference waveform
waveforms_corr = cell(nParticipants,4);
for i = 1:nParticipants
    for cond = 1:4
        cur = waveforms{i,cond};
        if ~isempty(cur)
            waveforms_corr{i,cond} = cur - mean(cur(baselineIdx));
        else
            waveforms_corr{i,cond} = [];
        end
    end
end

%% --- SEPARATE GROUPS ---
nicotineUsers    = summaryTable(~strcmp(summaryTable.User_Type,'Non-nicotine user'), :);
nonNicotineUsers = summaryTable( strcmp(summaryTable.User_Type,'Non-nicotine user'), :);
fprintf('Number of Nicotine Users: %d\n', height(nicotineUsers));
fprintf('Number of Non-Nicotine Users: %d\n', height(nonNicotineUsers));

%% GRAPH 1: Grouped Bar Chart of *Difference* Peaks (200–350 ms)
peakCols     = strcat(diffCols,'_Peak200_350');
conditionList = peakCols;  % same order

avgNicotine    = varfun(@nanmean, nicotineUsers,    'InputVariables',peakCols);
avgNonNicotine = varfun(@nanmean, nonNicotineUsers, 'InputVariables',peakCols);
stdNicotine    = varfun(@nanstd,  nicotineUsers,    'InputVariables',peakCols);
stdNonNicotine = varfun(@nanstd,  nonNicotineUsers, 'InputVariables',peakCols);

nNic = height(nicotineUsers);
nNon = height(nonNicotineUsers);

seNic  = [ stdNicotine.nanstd_CigaretteMinusGrey_Peak200_350, ...
           stdNicotine.nanstd_NeutralMinusGrey_Peak200_350, ...
           stdNicotine.nanstd_PouchMinusGrey_Peak200_350, ...
           stdNicotine.nanstd_ECigaretteMinusGrey_Peak200_350 ] / sqrt(nNic);

seNon  = [ stdNonNicotine.nanstd_CigaretteMinusGrey_Peak200_350, ...
           stdNonNicotine.nanstd_NeutralMinusGrey_Peak200_350, ...
           stdNonNicotine.nanstd_PouchMinusGrey_Peak200_350, ...
           stdNonNicotine.nanstd_ECigaretteMinusGrey_Peak200_350 ] / sqrt(nNon);

nicMeans    = [ avgNicotine.nanmean_CigaretteMinusGrey_Peak200_350, ...
                avgNicotine.nanmean_NeutralMinusGrey_Peak200_350, ...
                avgNicotine.nanmean_PouchMinusGrey_Peak200_350, ...
                avgNicotine.nanmean_ECigaretteMinusGrey_Peak200_350 ];

nonNicMeans = [ avgNonNicotine.nanmean_CigaretteMinusGrey_Peak200_350, ...
                avgNonNicotine.nanmean_NeutralMinusGrey_Peak200_350, ...
                avgNonNicotine.nanmean_PouchMinusGrey_Peak200_350, ...
                avgNonNicotine.nanmean_ECigaretteMinusGrey_Peak200_350 ];

groupMeans = [nonNicMeans; nicMeans]';  % 4×2

figure;
hBar = bar(groupMeans);
set(gca,'XTickLabel',{'Cigarette','Neutral','Pouch','E-Cigarette'});
xlabel('Condition');
ylabel('Average Difference Peak (200–350 ms) (\muV)');
title('Graph 1: Group Average Difference Peak by Condition');
legend('Non-Nicotine','Nicotine','Location','Best');
grid on; hold on;

xNon = hBar(1).XEndPoints;
xNic = hBar(2).XEndPoints;
errorbar(xNon,groupMeans(:,1),seNon,'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
errorbar(xNic,groupMeans(:,2),seNic,'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
hold off;

%% GRAPH 2: Overall Averages per Condition (Neutral Separated)
overallGroup = [nonNicMeans; nicMeans];  % 2×4
ogR = overallGroup(:,[2,1,3,4]);
dummy = nan(2,1);
ogNew = [ogR(:,1), dummy, ogR(:,2:end)];  % 2×5

seNonR = seNon([2,1,3,4]);
seNicR = seNic([2,1,3,4]);
seNewNon = [seNonR(1), nan, seNonR(2:end)];
seNewNic = [seNicR(1), nan, seNicR(2:end)];

figure;
hBar2 = bar(ogNew,'grouped');
hBar2(1).FaceColor = [0 0 0];
hBar2(3).FaceColor = [0.9290 0.6940 0.1250];
hBar2(4).FaceColor = [0.4940 0.1840 0.5560];
hBar2(5).FaceColor = [0.4660 0.6740 0.1880];
hBar2(2).HandleVisibility = 'off';

set(gca,'XTickLabel',{'Non-Nicotine','Nicotine'});
xlabel('User Type');
ylabel('Average Difference Peak (\muV)');
title('Difference Peak Stratified by Condition & User Type');
hBar2(1).DisplayName='Neutral';
hBar2(3).DisplayName='Cigarette';
hBar2(4).DisplayName='Pouch';
hBar2(5).DisplayName='E-Cigarette';
legend('Location','Best');
grid on; hold on;
for k=1:5
    if ~isnan(seNewNon(k))
        pts = hBar2(k).XEndPoints;
        errorbar(pts(1),ogNew(1,k),seNewNon(k),'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
        errorbar(pts(2),ogNew(2,k),seNewNic(k),'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
    end
end
hold off;

%% GRAPH 3: Differences Between Neutral and Other Conditions
nic = nicotineUsers; non = nonNicotineUsers;
ndC = nic.CigaretteMinusGrey_Peak200_350 - nic.NeutralMinusGrey_Peak200_350;
ndP = nic.PouchMinusGrey_Peak200_350   - nic.NeutralMinusGrey_Peak200_350;
ndE = nic.ECigaretteMinusGrey_Peak200_350 - nic.NeutralMinusGrey_Peak200_350;
nndC= non.CigaretteMinusGrey_Peak200_350 - non.NeutralMinusGrey_Peak200_350;
nndP= non.PouchMinusGrey_Peak200_350   - non.NeutralMinusGrey_Peak200_350;
nndE= non.ECigaretteMinusGrey_Peak200_350 - non.NeutralMinusGrey_Peak200_350;

avgDiffNic  = [mean(ndC,'omitnan'), mean(ndP,'omitnan'), mean(ndE,'omitnan')];
avgDiffNon  = [mean(nndC,'omitnan'),mean(nndP,'omitnan'),mean(nndE,'omitnan')];
stdDiffNic  = [std(ndC,'omitnan'),   std(ndP,'omitnan'),   std(ndE,'omitnan')];
stdDiffNon  = [std(nndC,'omitnan'),  std(nndP,'omitnan'),  std(nndE,'omitnan')];
seDiffNic   = stdDiffNic  / sqrt(height(nic));
seDiffNon   = stdDiffNon  / sqrt(height(non));

groupDiffMeans = [avgDiffNon; avgDiffNic]';  % 3×2

figure;
hBar3 = bar(groupDiffMeans);
set(gca,'XTickLabel',{'Cig-Neutral','Pouch-Neutral','E-Cigarette-Neutral'});
xlabel('Condition');
ylabel('Average Difference of Condition P300 Peaks (\muV)');
title('Differences Between Nicotine and Neutral Conditions');
legend('Non-Nicotine','Nicotine','Location','Best');
grid on; hold on;
for g=1:3
    errorbar(hBar3(1).XEndPoints(g), groupDiffMeans(g,1), seDiffNon(g),'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
    errorbar(hBar3(2).XEndPoints(g), groupDiffMeans(g,2), seDiffNic(g),   'k','linestyle','none','LineWidth',1,'HandleVisibility','off');
end
hold off;

%% custom colours & ordering for Graphs 4 & 5
customColors = [0 0 0; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880];
colorMap     = [2,1,3,4];
desiredOrder = [1,3,4,2];
conditionList= {'Cigarette','Neutral','Pouch','E-Cigarette'};

%% ─── BUILD & BASELINE‐CORRECT DIFF WAVEFORMS ───
diffCols = {'CigaretteMinusGrey','NeutralMinusGrey','PouchMinusGrey','ECigaretteMinusGrey'};
diffWF   = cell(nParticipants,4);
for c = 1:4
    diffWF(:,c) = summaryTable.(diffCols{c});
end
firstNonEmpty = find(~cellfun(@isempty,diffWF(:,1)),1);
L             = numel(diffWF{firstNonEmpty,1});
timeVec       = linspace(-100,600,L);
baselineIdx   = timeVec < 0;

waveforms_corr = cell(nParticipants,4);
for i = 1:nParticipants
  for c = 1:4
    w = diffWF{i,c};
    if ~isempty(w)
      waveforms_corr{i,c} = w - mean(w(baselineIdx));
    else
      waveforms_corr{i,c} = [];
    end
  end
end

% helper to grab leading digits
getNumID = @(s) regexp(s,'^\d+','match','once');

%% GRAPH 4: Avg Difference Waveform (Non‑Nicotine Users)
nonIdx = strcmp(summaryTable.User_Type,'Non-nicotine user');
L      = numel(waveforms_corr{1,1});   % should be 175
timeVec = linspace(-100,600,L);

figure; hold on;
hPlot = gobjects(1,4);
for cond = 1:4
    C = waveforms_corr(nonIdx,cond);        
    M = cell2mat(C')';                      
    avgDiff = mean(M,1,'omitnan');
    hPlot(cond) = plot(timeVec, avgDiff, 'LineWidth',2, ...
        'Color', customColors(colorMap(cond),:), ...
        'DisplayName', conditionList{cond});
end

% --- red line: group‑average greyscale ERP (channel 3) ---
idsNon  = summaryTable.Participant_ID(nonIdx);
greyMat = nan(numel(idsNon), L);
for j = 1:numel(idsNon)
    numID   = getNumID(idsNon{j});
    idxG    = find(startsWith(gsNames,numID),1);
    EEGg    = pop_loadset('filename',gsNames{idxG},'filepath',greyFolder);
    EEGg    = pop_epoch(EEGg,{'1','2','3','4'},[-0.1 0.6],'epochinfo','yes');
    chan3   = squeeze(EEGg.data(3,:,:));       % time×trials
    greyMat(j,:) = mean(chan3,2)';             % 1×L
end
avgGreyNon = mean(greyMat,1,'omitnan');
hGreyNon   = plot(timeVec, avgGreyNon, 'r--','LineWidth',2, 'DisplayName','Off-Target');

xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
title('Average Waveforms for Conditions in Non‑Nicotine Users');
legend([hPlot(desiredOrder), hGreyNon], [conditionList(desiredOrder), {'Off-Target'}], 'Location','best');
grid on; hold off;


%% GRAPH 5: Avg Difference Waveform (Nicotine Users)
nicIdx = ~nonIdx;

figure; hold on;
hPlot_n = gobjects(1,4);
for cond = 1:4
    C = waveforms_corr(nicIdx,cond);
    M = cell2mat(C')';
    avgDiff = mean(M,1,'omitnan');
    hPlot_n(cond) = plot(timeVec, avgDiff, 'LineWidth',2, ...
        'Color', customColors(colorMap(cond),:), ...
        'DisplayName', conditionList{cond});
end

% --- red line: group‑average greyscale ERP (channel 3) ---
idsNic   = summaryTable.Participant_ID(nicIdx);
greyMat_n= nan(numel(idsNic), L);
for j = 1:numel(idsNic)
    numID   = getNumID(idsNic{j});
    idxG    = find(startsWith(gsNames,numID),1);
    EEGg    = pop_loadset('filename',gsNames{idxG},'filepath',greyFolder);
    EEGg    = pop_epoch(EEGg,{'1','2','3','4'},[-0.1 0.6],'epochinfo','yes');
    chan3   = squeeze(EEGg.data(3,:,:));
    greyMat_n(j,:) = mean(chan3,2)';
end
avgGreyNic = mean(greyMat_n,1,'omitnan');
hGreyNic   = plot(timeVec, avgGreyNic, 'r--','LineWidth',2, 'DisplayName','Off-Trget');

xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
title('Average Waveforms for Conditions in Nicotine Users');
legend([hPlot_n(desiredOrder), hGreyNic], [conditionList(desiredOrder), {'Off-Target'}], 'Location','best');
grid on; hold off;
