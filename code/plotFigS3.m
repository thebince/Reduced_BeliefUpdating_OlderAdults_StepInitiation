% Script to generate figures from Supplementary section S3

%% Data Organization

data_folder = '../data';
data_filename = 'behaviouraldataStepping.csv';

t_name = fullfile(data_folder, data_filename);
T = readtable(t_name);

T.Condition = categorical(T.Condition, [1 2], {'mostly go', 'mostly no-go'});
T.Group = categorical(T.Group, [1 2], {'young', 'old'});

groupnames = categories(T.Group);
conditionnames = categories(T.Condition);

num_groups = numel(groupnames);
num_conditions = numel(conditionnames);

Y = cell(1, num_groups);

%% Scatter plot with all latencies - APA onset to Touchdown (Fig S2. A)

% Get list of all participants in the table
allParticipants = unique(T.Participant_ID);

numParticipants = numel(allParticipants);

% Initialize cell array for conditions
Y_cond_Touchdown = cell(1, num_conditions);
Y_cond_LiftOff = cell(1, num_conditions);
Y_cond_MaxAPA = cell(1, num_conditions);
Y_cond_APAOnset = cell(1, num_conditions);


for c = 1:num_conditions
    mat_cond_touchdown = nan(numParticipants, num_groups); % pre-allocate with participants all
    mat_cond_liftoff = nan(numParticipants, num_groups); % pre-allocate with participants all
    mat_cond_maxAPA = nan(numParticipants, num_groups); % pre-allocate with participants all
    mat_cond_APAonset = nan(numParticipants, num_groups); % pre-allocate with participants all

    thisCond = conditionnames{c};    
    for g = 1:num_groups
        thisGroup = groupnames{g};

        % Filter for this group and condition
        Tg = T(T.Group == thisGroup & T.Condition == thisCond, :);
        
        % For each participant, find mean RT or NaN if missing
        for p = 1:numParticipants
            participantID = allParticipants(p);
            idx = (Tg.Participant_ID == participantID);
            mat_cond_touchdown(p, g) = mean(Tg.Difference_TouchdownGo(idx), 'omitnan');
            mat_cond_liftoff(p, g) = mean(Tg.Difference_LiftOffGo(idx), 'omitnan');
            mat_cond_maxAPA(p, g) = mean(Tg.Difference_MaxAPAGo(idx),'omitnan');
            mat_cond_APAonset(p, g) = mean(Tg.Difference_APAOnsetGo(idx),'omitnan');

        end
    end
    Y_cond_Touchdown{c} = mat_cond_touchdown;
    Y_cond_LiftOff{c} = mat_cond_liftoff;
    Y_cond_MaxAPA{c} = mat_cond_maxAPA;
    Y_cond_APAOnset{c} = mat_cond_APAonset;

end

%% Fig 3.1

teal = cbrewer2('BuGn', 9);
teal_dark = teal(end, :);      % darkest teal-green

orange = cbrewer2('Oranges', 6);
orange_light = orange(3, :);   % light-mid peach/orange, still visibly colored

c = [orange_light; teal_dark];

% scatterColors = mat2cell(c, ones(1, size(c,1)), 3);

figure;

box off;
subplot(1,4,1);
h = daviolinplot(Y_cond_APAOnset, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 10,...
    'legend', cellstr(conditionnames));
    
ylabel('APA Onset Time (ms)','FontSize', 8);
ylim([50 1800]);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
legend off;
hold off

% exportgraphics(gcf, 'apaonset_raincloud600dpi.png', 'Resolution', 600);

subplot(1,4,2);
h = daviolinplot(Y_cond_MaxAPA, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 10);

ylabel('Max APA Time (ms)','FontSize', 8);
ylim([50 1800]);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
hold off

subplot(1,4,3);
h = daviolinplot(Y_cond_LiftOff, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 10);
ylabel('Lift-Off Time (ms)','FontSize', 8);
ylim([50 1800]);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
hold off

subplot(1,4,4);
h = daviolinplot(Y_cond_Touchdown, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 10);
ylabel('Touchdown Time (ms)','FontSize', 8);
ylim([50 1800]);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
hold off

hold on;
dummyPlots = gobjects(length(conditionnames), 1);
for i = 1:length(conditionnames)
    dummyPlots(i) = plot(nan, nan, 'Color', c(i,:), 'LineWidth', 2); 
end
hold off;

%% Stimulus History grouping
groupnames = categories(T.Group);
stimhistory = unique(T.Go_Consecutive_Go_NoGo);

num_groups = numel(groupnames);
num_stimhistory = numel(stimhistory);

% Get list of all participants in the table
allParticipants = unique(T.Participant_ID);
numParticipants = numel(allParticipants);

% Initialise cell array for stim history grouping
Y_stimhistory_Touchdown = cell(1, num_stimhistory);
Y_stimhistory_LiftOff = cell(1, num_stimhistory);
Y_stimhistory_MaxAPA = cell(1, num_stimhistory);
Y_stimhistory_APAOnset = cell(1, num_stimhistory);

for c = 1:num_stimhistory
    mat_stimhistory_touchdown = nan(numParticipants, num_groups); % pre-allocate with participants all
    mat_stimhistory_liftoff = nan(numParticipants, num_groups);
    mat_stimhistory_maxapa = nan(numParticipants, num_groups);
    mat_stimhistory_apaonset = nan(numParticipants, num_groups);

    thisStimHistory = stimhistory(c);    
    for g = 1:num_groups
        thisGroup = groupnames{g};

        % Filter for this group and condition
        Tg = T(T.Group == thisGroup & T.Go_Consecutive_Go_NoGo == thisStimHistory, :);

        % For each participant, find mean RT or NaN if missing
        for p = 1:numParticipants
            participantID = allParticipants(p);
            idx = (Tg.Participant_ID == participantID);
            mat_stimhistory_touchdown(p, g) = mean(Tg.Difference_TouchdownGo(idx), 'omitnan');
            mat_stimhistory_liftoff(p, g) = mean(Tg.Difference_LiftOffGo(idx), 'omitnan');
            mat_stimhistory_maxapa(p, g) = mean(Tg.Difference_MaxAPAGo(idx), 'omitnan');
            mat_stimhistory_apaonset(p, g) =mean(Tg.Difference_APAOnsetGo(idx), 'omitnan');
        end
    end
    
    Y_stimhistory_Touchdown{c} = mat_stimhistory_touchdown;
    Y_stimhistory_LiftOff{c} = mat_stimhistory_liftoff;
    Y_stimhistory_MaxAPA{c} = mat_stimhistory_maxapa;
    Y_stimhistory_APAOnset{c} =  mat_stimhistory_apaonset;

end

num_stimhistory = numel(Y_stimhistory_Touchdown);
numParticipants = size(Y_stimhistory_Touchdown{1},1);

% Young group only: column 1 from each cell
young_touchdown = nan(numParticipants, num_stimhistory);
young_liftoff = nan(numParticipants, num_stimhistory);
young_maxapa = nan(numParticipants, num_stimhistory);
young_apaonset = nan(numParticipants, num_stimhistory);
for c = 1:num_stimhistory
    young_touchdown(:,c) = Y_stimhistory_Touchdown{c}(:,1); % Young
    young_liftoff(:,c) = Y_stimhistory_LiftOff{c}(:,1);
    young_maxapa(:,c) = Y_stimhistory_MaxAPA{c}(:,1);
    young_apaonset(:,c) = Y_stimhistory_APAOnset{c}(:,1);
end

% Old group only: column 2 from each cell
old_touchdown = nan(numParticipants, num_stimhistory);
old_liftoff = nan(numParticipants, num_stimhistory);
old_maxapa = nan(numParticipants, num_stimhistory);
old_apaonset = nan(numParticipants, num_stimhistory);

for c = 1:num_stimhistory
    old_touchdown(:,c) = Y_stimhistory_Touchdown{c}(:,2); % Old
    old_liftoff(:,c) = Y_stimhistory_LiftOff{c}(:,2);
    old_maxapa(:,c) = Y_stimhistory_MaxAPA{c}(:,2);
    old_apaonset(:,c) = Y_stimhistory_APAOnset{c}(:,2);
end

%% Data Organization - Global - Young (Fig S3.2)

c = brewermap(9,'Reds');
redCB = c(6, :);         
cb = brewermap(9,'Blues');
blueCB = cb(6, :); 

part_id = unique(T.Participant_ID);
participantTables = cell(length(part_id), 1);
for i = 1:length(part_id)
    participantTables{i} = T(T.Participant_ID == part_id(i), :);
end

slope_young = table;

figure;
rows = 4;
cols = 6;

t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:24
    nexttile;
    tab = participantTables{i};
    S = groupsummary(tab, 'Go_Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
    unique_x = S.Go_Consecutive_Go_NoGo;
    x_partone = tab.Go_Consecutive_Go_NoGo(tab.Participant_ID == i);
    y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == i);
    idx_nan = isnan(y_partone(:));
    x_slope_line = linspace(-5,5,100)';
    
    p = polyfit(x_partone(~idx_nan), y_partone(~idx_nan), 1);
    slope_line = p(1)*x_slope_line + p(2);
    slope_young.slope(i) = p(1);
    slope_young.intercept(i) = p(2);
    
    hold on;
    
    for k = 1:numel(unique_x)
        idx = tab.Go_Consecutive_Go_NoGo == unique_x(k);
        xjitter = unique_x(k) + 0.2*randn(sum(idx),1);
        scatter(xjitter, tab.Difference_APAOnsetGo(idx), 12, redCB, 'filled', 'MarkerFaceAlpha', 0.5);
    end
    
    plot(x_slope_line, slope_line, 'Color', 'black', 'LineWidth', 1.5);
    
    if i == 1
        xlabel('Trial History','FontSize',6);
        ylabel('APA Onset Time(ms)','FontSize',6);
    end
    
    xlim([-5.1 5.1]);
    ylim([50 600]);
    title("Participant " + string(tab.Participant_ID(1)), 'FontSize',6);
    
    ax = gca;
    ax.LineWidth = 2.5;
    ax.XAxis.TickLength = [0 0];
    ax.YAxis.TickLength = [0 0];
    ax.XAxis.FontWeight = 'bold';
    ax.YAxis.FontWeight = 'bold';

    hold off;
    box off;
end

%% Data Organization - Global - Old (Fig S3.3)

slope_old = table;

figure;
rows = 5;
cols = 5;

t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:25
    nexttile;
    tab = participantTables{24 + i};
    S = groupsummary(tab, 'Go_Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
    unique_x = S.Go_Consecutive_Go_NoGo;

    x_partone = tab.Go_Consecutive_Go_NoGo(tab.Participant_ID == tab.Participant_ID(1));
    y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == tab.Participant_ID(1));
    idx_nan = isnan(y_partone(:));
    x_slope_line = linspace(-4.5,4.5,100)';
    
    % fit
    p = polyfit(x_partone(~idx_nan),y_partone(~idx_nan),1);
    slope_line = p(1)*x_slope_line + p(2);

    slope_old.slope(i) = p(1);
    slope_old.intercept(i) = p(2);

    hold on;
    % Plot mean and std as error bars
    % errorbar(unique_x, S.mean_Difference_APAOnsetGo, S.std_Difference_APAOnsetGo, 'o-', 'LineWidth', 2, 'Color', blueCB);

    % Overlay scatter of raw RT data with jitter
    for k = 1:numel(unique_x)
        idx = tab.Go_Consecutive_Go_NoGo == unique_x(k);
        xjitter = unique_x(k) + 0.2*randn(sum(idx),1);
        scatter(xjitter, tab.Difference_APAOnsetGo(idx), 10, blueCB, 'filled', 'MarkerFaceAlpha', 0.5);
    end

    if i == 1
        xlabel('Trial History','FontSize',6);
        ylabel('APA Onset Time(ms)','FontSize',6);
    end
    hold on;
    % slope line
    plot(x_slope_line, slope_line, 'Color', 'black', 'LineWidth', 1.5);
    xlim([-5.1 5.1]);
    ylim([50 600]);
    title("Participant " + string(tab.Participant_ID(1)-100),'FontSize',6);
    % title("Old Participant 16");
    ax = gca;           % Get axis handle
    ax.LineWidth = 2.5; % Thicken axis lines
    ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
    ax.YAxis.TickLength = [0 0];  
    ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
    ax.YAxis.FontWeight = 'bold'; 
    box off;
    hold off;

end

