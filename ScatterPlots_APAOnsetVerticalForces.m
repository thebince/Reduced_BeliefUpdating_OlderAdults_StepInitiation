%% Script to generate scatter plots of APA Onset RT and Vertical Stepping Forces

%% Data Organization

T = readtable('newRT_29112025_withforces_APAfiltered.csv');
% T.Touchdown = T.Difference_LiftOffGo + T.Difference_TouchdownLiftoff;
T.Condition = categorical(T.Condition, [1 2], {'mostly go', 'mostly no-go'});
T.Group = categorical(T.Group, [1 2], {'young', 'old'});

groupnames = categories(T.Group);
conditionnames = categories(T.Condition);

num_groups = numel(groupnames);
num_conditions = numel(conditionnames);

Y = cell(1, num_groups);

% Get list of all participants in the table
allParticipants = unique(T.Participant_ID);
numParticipants = numel(allParticipants);

Y_cond_MaxAPASteppingForce = cell(1, num_conditions);
Y_cond_Touchdown = cell(1, num_conditions);
Y_cond_LiftOff = cell(1, num_conditions);
Y_cond_MaxAPA = cell(1, num_conditions);
Y_cond_APAOnset = cell(1, num_conditions);

for c = 1:num_conditions
    
    mat_cond_MaxAPASteppingForce = nan(numParticipants, num_groups); % pre-allocate with all participants
    mat_cond_touchdown = nan(numParticipants, num_groups); 
    mat_cond_liftoff = nan(numParticipants, num_groups); 
    mat_cond_maxAPA = nan(numParticipants, num_groups); 
    mat_cond_APAonset = nan(numParticipants, num_groups); 
   
    thisCond = conditionnames{c};    
    for g = 1:num_groups
        thisGroup = groupnames{g};

        % Filter for this group and condition
        Tg = T(T.Group == thisGroup & T.Condition == thisCond, :);
        
        % For each participant, find mean RT or NaN if missing
        for p = 1:numParticipants
            participantID = allParticipants(p);
            idx = (Tg.Participant_ID == participantID);
            mat_cond_MaxAPASteppingForce(p, g) = mean(Tg.SteppingForce_MaxAPA(idx),'omitnan');
            mat_cond_touchdown(p, g) = mean(Tg.Difference_TouchdownGo(idx), 'omitnan');
            mat_cond_liftoff(p, g) = mean(Tg.Difference_LiftOffGo(idx), 'omitnan');
            mat_cond_maxAPA(p, g) = mean(Tg.Difference_MaxAPAGo(idx),'omitnan');
            mat_cond_APAonset(p, g) = mean(Tg.Difference_APAOnsetGo(idx),'omitnan');
        end
    end

    Y_cond_MaxAPASteppingForce{c} = mat_cond_MaxAPASteppingForce;
    Y_cond_Touchdown{c} = mat_cond_touchdown;
    Y_cond_LiftOff{c} = mat_cond_liftoff;
    Y_cond_MaxAPA{c} = mat_cond_maxAPA;
    Y_cond_APAOnset{c} = mat_cond_APAonset;

end

%% Plotting - Force (Fig S1.1 B)

c =  [0.98, 0.40, 0.35;
      0.45, 0.80, 0.69];
scatterColors = mat2cell(c, ones(1, size(c,1)), 3);

figure;

box off;
h = daviolinplot(Y_cond_MaxAPASteppingForce, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 30,...
    'legend', cellstr(conditionnames));
    
ylabel('Normalized Vertical Force at Max APA','FontSize', 7);
lgd = legend;
lgd.Location = 'SouthEast';
lgd.FontSize = 6;
legend box off

ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
ax.XAxis.FontSize = 7;
ax.YAxis.FontSize = 7;
set(gca, 'color', 'none');
ylim([0 1]);
hold off


%% Plotting - APA Onset Time (Fig 1. C)

c =  [0.98, 0.40, 0.35;
      0.45, 0.80, 0.69];
scatterColors = mat2cell(c, ones(1, size(c,1)), 3);

box off;
h = daviolinplot(Y_cond_APAOnset, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 30,...
    'legend', cellstr(conditionnames));
    
ylabel('APA Onset Time (ms)','FontSize', 7);
ylim([100 550]);
lgd = legend;
lgd.FontSize = 6;
legend box off
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
ax.XAxis.FontSize = 7;
ax.YAxis.FontSize = 7;
set(gca, 'color', 'none');
hold off


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

%% Plotting

c =  [0.98, 0.40, 0.35;
      0.45, 0.80, 0.69];
scatterColors = mat2cell(c, ones(1, size(c,1)), 3);

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
ax = gca;           
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];  
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; 
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
ax = gca;          
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];  
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; 
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
ax = gca;           
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];  
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; 
ax.YAxis.FontWeight = 'bold'; 
hold off

hold on;
dummyPlots = gobjects(length(conditionnames), 1);
for i = 1:length(conditionnames)
    dummyPlots(i) = plot(nan, nan, 'Color', c(i,:), 'LineWidth', 2); 
end
hold off;