%% --- SETTINGS & LOADING ---
folderPath = 'C:\Users\General Use\Desktop\NT Group 3 24-25\ODDBALL Participant Data\master table info';
% timeWindowPeak is not used in this script; it's for your saving script.
timeWindowWave = [-100 600];  % For ERP waveform graphs (Graph 4 & 5)
load(fullfile(folderPath, 'masterOddballTableAveragedPeakProperly.mat'));  
% This loads the variable 'masterTable'
% (Assumed fields: Participant_ID, Condition, Average_Waveform, Peak_p300, User_Type)

% Get list of all .set files (for waveform graphs)
files = dir(fullfile(folderPath, '*.set'));
fileList = {files.name};

%% --- PIVOT MASTER TABLE INTO SUMMARY TABLE ---
% Create a summary table with one row per participant and columns for each condition.
participants = unique(masterTable.Participant_ID);
nParticipants = numel(participants);
peakVals = nan(nParticipants, 4);
userTypeVals = cell(nParticipants, 1);
for i = 1:nParticipants
    pID = participants{i};
    rows = masterTable(strcmp(masterTable.Participant_ID, pID), :);
    userTypeVals{i} = rows.User_Type{1};
    for cond = 1:4
       condStr = num2str(cond);
       r = rows(strcmp(rows.Condition, condStr), :);
       if ~isempty(r)
           peakVals(i,cond) = r.Peak_p300;
       else
           peakVals(i,cond) = NaN;
       end
    end
end
% Create summaryTable with desired field names:
summaryTable = table(participants, peakVals(:,1), peakVals(:,2), peakVals(:,3), peakVals(:,4), userTypeVals, ...
    'VariableNames', {'Participant_ID', 'Cigarette', 'Neutral', 'Pouch', 'ECigarette', 'User_Type'});
disp('--- Summary Table ---');
disp(summaryTable);

waveforms = cell(nParticipants, 4);
for i = 1:nParticipants
    pID = participants{i};
    rows = masterTable(strcmp(masterTable.Participant_ID, pID), :);
    for cond = 1:4
       condStr = num2str(cond);
       r = rows(strcmp(rows.Condition, condStr), :);
       if ~isempty(r)
           waveforms{i, cond} = r.Average_Waveform{1};  % Use the Average_Waveform field
       else
           waveforms{i, cond} = [];
       end
    end
end

% ---- BASELINE CORRECTION ----
% We assume each waveform in "waveforms" is a numeric vector spanning -100 to 600 ms.
% Define a common time vector (using the length of one ERP waveform)
if ~isempty(waveforms{1,1})
    L = length(waveforms{1,1});
else
    L = 250; % default length if needed
end
timeVec = linspace(-100, 600, L);
% Find indices corresponding to the baseline period (from -100 to 0 ms)
baselineIdx = find(timeVec < 0);

% Create a new cell array to store baseline-corrected waveforms
waveforms_corr = cell(nParticipants, 4);
for i = 1:nParticipants
    for cond = 1:4
        curWave = waveforms{i, cond};
        if ~isempty(curWave)
            % Subtract the average value in the baseline period
            waveforms_corr{i, cond} = curWave - mean(curWave(baselineIdx));
        else
            waveforms_corr{i, cond} = [];
        end
    end
end


%% --- SEPARATE GROUPS ---
nicotineUsers = summaryTable(~strcmp(summaryTable.User_Type, 'Non-nicotine user'), :);
nonNicotineUsers = summaryTable(strcmp(summaryTable.User_Type, 'Non-nicotine user'), :);
fprintf('Number of Nicotine Users: %d\n', height(nicotineUsers));
fprintf('Number of Non-Nicotine Users: %d\n', height(nonNicotineUsers));

%% GRAPH 1: Grouped Bar Chart (Peak p300 by Condition) with Error Bars
conditionList = {'Cigarette','Neutral','Pouch','ECigarette'};
avgNicotine = varfun(@nanmean, nicotineUsers, 'InputVariables', conditionList);
avgNonNicotine = varfun(@nanmean, nonNicotineUsers, 'InputVariables', conditionList);
stdNicotine = varfun(@std, nicotineUsers, 'InputVariables', conditionList);
stdNonNicotine = varfun(@std, nonNicotineUsers, 'InputVariables', conditionList);
nNicotine = height(nicotineUsers);
nNonNicotine = height(nonNicotineUsers);
seNicotine = [stdNicotine.std_Cigarette, stdNicotine.std_Neutral, stdNicotine.std_Pouch, stdNicotine.std_ECigarette] / sqrt(nNicotine);
seNonNicotine = [stdNonNicotine.std_Cigarette, stdNonNicotine.std_Neutral, stdNonNicotine.std_Pouch, stdNonNicotine.std_ECigarette] / sqrt(nNonNicotine);
nicotineMeans = [avgNicotine.nanmean_Cigarette, avgNicotine.nanmean_Neutral, avgNicotine.nanmean_Pouch, avgNicotine.nanmean_ECigarette];
nonNicotineMeans = [avgNonNicotine.nanmean_Cigarette, avgNonNicotine.nanmean_Neutral, avgNonNicotine.nanmean_Pouch, avgNonNicotine.nanmean_ECigarette];
groupMeans = [nonNicotineMeans; nicotineMeans]';  % 4x2 matrix

figure;
hBar = bar(groupMeans);
set(gca, 'XTickLabel', {'Cigarette (1)', 'Neutral (2)', 'Pouch (3)', 'E-Cigarette (4)'});
xlabel('Condition');
ylabel('Average Peak p300 Amplitude (\muV)');
title('Graph 1: Group Average Peak p300 Across Conditions');
legend('Non-Nicotine Users', 'Nicotine Users');
grid on;
hold on;
x1 = hBar(1).XEndPoints;  % 1x4 vector
x2 = hBar(2).XEndPoints;  % 1x4 vector
errorbar(x1, groupMeans(:,1), seNonNicotine, 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility','off');
errorbar(x2, groupMeans(:,2), seNicotine, 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility','off');
hold off;

%% GRAPH 2: Overall Averages per Condition Grouped by User Type with Neutral Separated

% OverallGroup is originally 2x4 with columns in order:
% [Cigarette, Neutral, Pouch, E-Cigarette].
% Reorder columns so that Neutral comes first:
overallGroup_reordered = overallGroup(:, [2, 1, 3, 4]);

% Insert a dummy column (all NaN) after the first column (Neutral)
dummy = nan(size(overallGroup_reordered, 1), 1);
overallGroup_new = [overallGroup_reordered(:,1) dummy overallGroup_reordered(:,2:end)];  % now 2x5

% Also reorder the standard error vectors similarly:
seNonNicotine_reordered = seNonNicotine([2, 1, 3, 4]);
seNicotine_reordered = seNicotine([2, 1, 3, 4]);
dummySE = nan(1,1);
seNonNicotine_new = [seNonNicotine_reordered(1), dummySE, seNonNicotine_reordered(2:end)];
seNicotine_new = [seNicotine_reordered(1), dummySE, seNicotine_reordered(2:end)];

figure;
hBar2 = bar(overallGroup_new, 'grouped');
% Customize bar colors:
hBar2(1).FaceColor = [0 0 0];      % Neutral = Black
hBar2(3).FaceColor = [0.9290 0.6940 0.1250];      % Cigarette = Black
hBar2(4).FaceColor = [0.4940 0.1840 0.5560];      % Pouch = Magenta
hBar2(5).FaceColor = [0.4660 0.6740 0.1880];      % E-Cigarette = Green
hBar2(2).HandleVisibility = 'off';


set(gca, 'XTickLabel', {'Non-Nicotine Users', 'Nicotine Users'});
xlabel('User Type');
ylabel('Average Peak p300 Amplitude (\muV)');
title('Graph 2: Average Peak p300 Amplitude by Condition and User Type');

% Set legend display names: we have 5 bar objects now (dummy column gets an empty label)
hBar2(1).DisplayName = 'Neutral';
hBar2(2).DisplayName = '';  % dummy, hidden
hBar2(3).DisplayName = 'Cigarette';
hBar2(4).DisplayName = 'Pouch';
hBar2(5).DisplayName = 'E-Cigarette';
legend('Location', 'Best');
grid on;
hold on;
% hBar2 is an array of 5 bar objects; each XEndPoints is a 1x2 vector.
for iCond = 1:length(hBar2)
    if ~isnan(seNonNicotine_new(iCond))
        xTemp = hBar2(iCond).XEndPoints;
        errorbar(xTemp(1), overallGroup_new(1,iCond), seNonNicotine_new(iCond), 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility','off');
        errorbar(xTemp(2), overallGroup_new(2,iCond), seNicotine_new(iCond), 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility','off');
    end
end
hold off;


%% GRAPH 3: Differences Between Neutral and Other Conditions (No Error Bars on Bars)
% First, compute individual differences for each participant:
nic_diffCig = nicotineUsers.Cigarette - nicotineUsers.Neutral;
nic_diffPouch = nicotineUsers.Pouch - nicotineUsers.Neutral;
nic_diffECig = nicotineUsers.ECigarette - nicotineUsers.Neutral;
nonNic_diffCig = nonNicotineUsers.Cigarette - nonNicotineUsers.Neutral;
nonNic_diffPouch = nonNicotineUsers.Pouch - nonNicotineUsers.Neutral;
nonNic_diffECig = nonNicotineUsers.ECigarette - nonNicotineUsers.Neutral;

% Then compute group averages and standard deviations:
avgDiffNicotine = [mean(nic_diffCig, 'omitnan'), mean(nic_diffPouch, 'omitnan'), mean(nic_diffECig, 'omitnan')];
avgDiffNonNicotine = [mean(nonNic_diffCig, 'omitnan'), mean(nonNic_diffPouch, 'omitnan'), mean(nonNic_diffECig, 'omitnan')];

stdDiffNicotine = [std(nic_diffCig, 'omitnan'), std(nic_diffPouch, 'omitnan'), std(nic_diffECig, 'omitnan')];
stdDiffNonNicotine = [std(nonNic_diffCig, 'omitnan'), std(nonNic_diffPouch, 'omitnan'), std(nonNic_diffECig, 'omitnan')];

N_nic = height(nicotineUsers);
N_non = height(nonNicotineUsers);
seDiffNicotine = stdDiffNicotine / sqrt(N_nic);
seDiffNonNicotine = stdDiffNonNicotine / sqrt(N_non);

% Combine group averages into a 3x2 matrix.
% Rows: difference type (Cigarette-Neutral, Pouch-Neutral, E-Cigarette-Neutral)
% Columns: [Non-Nicotine, Nicotine]
groupDiffMeans = [avgDiffNonNicotine; avgDiffNicotine]';  

figure;
hBar3 = bar(groupDiffMeans);
set(gca, 'XTickLabel', {'Cigarette-Neutral', 'Pouch-Neutral', 'E-Cigarette-Neutral'});
xlabel('Condition Difference');
ylabel('Average Difference in Peak p300 Amplitude (\muV)');
title('Graph 3: Differences Between Neutral and Other Conditions');
legend('Non-Nicotine Users', 'Nicotine Users');
grid on;
hold on;
% hBar3 is an array of 2 bar objects, each with XEndPoints having 3 elements.
ngroups3 = size(groupDiffMeans, 1);  % 3 groups (one for each difference)
for iGroup = 1:ngroups3
    errorbar(hBar3(1).XEndPoints(iGroup), groupDiffMeans(iGroup,1), seDiffNonNicotine(iGroup), 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility', 'off');
    errorbar(hBar3(2).XEndPoints(iGroup), groupDiffMeans(iGroup,2), seDiffNicotine(iGroup), 'k', 'linestyle', 'none', 'LineWidth', 1, 'HandleVisibility', 'off');
end
hold off;

%% --- T-TESTS FOR GRAPH 3 DIFFERENCES ---
% Using the individual difference values computed previously:
% For Nicotine Users:
nic_diffCig = nicotineUsers.Cigarette - nicotineUsers.Neutral;
nic_diffPouch = nicotineUsers.Pouch - nicotineUsers.Neutral;
nic_diffECig = nicotineUsers.ECigarette - nicotineUsers.Neutral;

% For Non-Nicotine Users:
nonNic_diffCig = nonNicotineUsers.Cigarette - nonNicotineUsers.Neutral;
nonNic_diffPouch = nonNicotineUsers.Pouch - nonNicotineUsers.Neutral;
nonNic_diffECig = nonNicotineUsers.ECigarette - nonNicotineUsers.Neutral;

% Perform two-sample t-tests for each difference:
[~, pCig, ciCig, statsCig] = ttest2(nic_diffCig, nonNic_diffCig);
[~, pPouch, ciPouch, statsPouch] = ttest2(nic_diffPouch, nonNic_diffPouch);
[~, pECig, ciECig, statsECig] = ttest2(nic_diffECig, nonNic_diffECig);

% Display the results:
fprintf('\nT-test Results for Differences Between Groups:\n');
fprintf('Cigarette-Neutral difference: t(%d)=%.2f, p=%.4f\n', statsCig.df, statsCig.tstat, pCig);
fprintf('Pouch-Neutral difference:     t(%d)=%.2f, p=%.4f\n', statsPouch.df, statsPouch.tstat, pPouch);
fprintf('E-Cigarette-Neutral difference: t(%d)=%.2f, p=%.4f\n', statsECig.df, statsECig.tstat, pECig);


%% custom colour 
customColors = [0 0 0;              % Neutral: Black
                0.9290 0.6940 0.1250;  % Cigarette: Yellow
                0.4940 0.1840 0.5560;  % Pouch: Magenta
                0.4660 0.6740 0.1880]; % E-Cigarette: Green

% Define your condition list (as stored in your summary table):
conditionList = {'Cigarette','Neutral','Pouch','ECigarette'};

% Define a mapping vector: for plotting, assign the desired custom color for each condition:
% For 'Cigarette' (conditionList{1}) use row 2, 
% for 'Neutral' (conditionList{2}) use row 1,
% for 'Pouch' (conditionList{3}) use row 3,
% for 'ECigarette' (conditionList{4}) use row 4.
colorMap = [2, 1, 3, 4];

% Define desired legend order: we want the legend to show:
% 'Cigarette', 'Pouch', 'E-Cigarette', 'Neutral'
desiredOrder = [1, 3, 4, 2];

%% graph 4: averaged ERP wafeform for non nic users
% Use the baseline-corrected waveforms from waveforms_corr.
% Get indices for non-nicotine users (using your pivoted summary table):
nonNicotineIndices = find(strcmp(userTypeVals, 'Non-nicotine user'));

avgWave_nonNic = cell(1, 4);  % Preallocate for 4 conditions
for cond = 1:4
    allWaves = [];
    for i = nonNicotineIndices'
        if ~isempty(waveforms_corr{i, cond})
            % Ensure each waveform is a row vector
            allWaves = [allWaves; waveforms_corr{i, cond}(:)'];
        end
    end
    if ~isempty(allWaves)
        avgWave_nonNic{cond} = mean(allWaves, 1, 'omitnan');
    else
        avgWave_nonNic{cond} = nan(1, L);
    end
end

figure;
hold on;
hPlot = gobjects(1,4);  % Preallocate handles
for cond = 1:4
    % Use the mapping to set the color from customColors:
    hPlot(cond) = plot(timeVec, avgWave_nonNic{cond}, 'LineWidth', 2, ...
                        'Color', customColors(colorMap(cond),:), ...
                        'DisplayName', conditionList{cond});
end
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Graph 4: Averaged ERP Waveform (Non-Nicotine Users, Baseline Corrected)');

% Reorder the legend handles:
legend(hPlot(desiredOrder), {conditionList{desiredOrder}}, 'Location', 'best');
grid on;
hold off;


%% GRAPH 5: Averaged ERP Waveform for Nicotine Users (Baseline Corrected)
nicotineIndices = find(~strcmp(userTypeVals, 'Non-nicotine user'));

avgWave_nic = cell(1, 4);  % Preallocate for 4 conditions
for cond = 1:4
    allWaves = [];
    for i = nicotineIndices'
        if ~isempty(waveforms_corr{i, cond})
            allWaves = [allWaves; waveforms_corr{i, cond}(:)'];
        end
    end
    if ~isempty(allWaves)
        avgWave_nic{cond} = mean(allWaves, 1, 'omitnan');
    else
        avgWave_nic{cond} = nan(1, L);
    end
end

figure;
hold on;
hPlot_nic = gobjects(1,4);  % Preallocate handles
for cond = 1:4
    hPlot_nic(cond) = plot(timeVec, avgWave_nic{cond}, 'LineWidth', 2, ...
                            'Color', customColors(colorMap(cond),:), ...
                            'DisplayName', conditionList{cond});
end
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Graph 5: Averaged ERP Waveform (Nicotine Users, Baseline Corrected)');

% Reorder the legend handles:
legend(hPlot_nic(desiredOrder), {conditionList{desiredOrder}}, 'Location', 'best');
grid on;
hold off;

