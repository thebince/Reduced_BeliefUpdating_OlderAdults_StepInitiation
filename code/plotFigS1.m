% Script to generate figures from Supplementary section S1

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

%% Plot Fig S1.1B

teal = cbrewer2('BuGn', 9);
teal_dark = teal(end, :);      % darkest teal-green

orange = cbrewer2('Oranges', 6);
orange_light = orange(3, :);   % light-mid peach/orange, still visibly colored

c = [orange_light; teal_dark];

figure;
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 

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

%% Load average force trajectory

data_youngsteppingforce = '../data/average_normalizedforce_trajectory/mean_young_stepping_norm';
data_youngstanceforce = '../data/average_normalizedforce_trajectory/mean_young_stance_norm';
data_oldsteppingforce = '../data/average_normalizedforce_trajectory/mean_old_stepping_norm';
data_oldstanceforce = '../data/average_normalizedforce_trajectory/mean_old_stance_norm';
time_young = '../data/average_normalizedforce_trajectory/time_young';
time_old = '../data/average_normalizedforce_trajectory/time_old';

load(data_youngsteppingforce)
load(data_youngstanceforce)

load(data_oldsteppingforce)
load(data_oldstanceforce)

load(time_young)
load(time_old)

% go-cue at zero for young and old
[value,go_cue] = min(abs(time_young));
time_young_go_cue = time_young(go_cue);
young_go_cue = go_cue;


%% Plot average forces (Fig S1.1A)

% 'Reds' palette
reds = cbrewer2('seq', 'Reds', 9);
red_color = reds(8, :);   

% 'Blues' palette
blues = cbrewer2('seq', 'Blues', 9);
blue_color = blues(4, :);

% 'Greens' palette
greens = cbrewer2('seq', 'Greens', 3); 
green_color = greens(end,:);  

% 'Purples' palette
purples = cbrewer2('seq', 'Purples', 3); 
purple_color = purples(end,:);  

% 'Oranges' palette
oranges = cbrewer2('seq', 'Oranges', 3); 
oranges_color = oranges(end,:); 

pink = cbrewer2('seq', 'Blues', 5);
pink_color = pink(end,:);

figure;
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 9 9]);

plot(time_young, mean_young_stepping_norm, 'Color', red_color, 'LineWidth', 2);
hold on
plot(time_old, mean_old_stepping_norm, 'Color', blue_color, 'LineWidth', 2);
% hold on
% xline(time_young(1), '--','LineWidth',1.5, 'Color', oranges_color);
% xline(time_young_go_cue, '--','LineWidth',1.5, 'Color', green_color);
% xline(time_young_maxAPA, '--','LineWidth',1.5, 'Color', purple_color);

% plot(time_young, -groupmean_young.mean_force1_right, 'Color', red_color, 'LineWidth', 2);
% plot(time_young, -groupmean_young.mean_force2_right, 'Color', red_color, 'LineWidth', 2);

plot(time_young, mean_young_stance_norm, 'Color', red_color, 'LineWidth', 2);
hold on;
plot(time_old, mean_old_stance_norm, 'Color', blue_color, 'LineWidth', 2);
% plot(time_old, -groupmean_old.mean_force1_right, 'Color', blue_color, 'LineWidth', 2);
% plot(time_old, -groupmean_old.mean_force2_right, 'Color', blue_color, 'LineWidth', 2);

hold on
% xline(time_young(1), '--','LineWidth',1.5, 'Color', oranges_color);
xline(time_old(1), '--','LineWidth',1.5, 'Color', oranges_color);
xline(time_young_go_cue, '--','LineWidth',1.5, 'Color', green_color);
% xline(time_young_go_cue, '--','LineWidth',1.5, 'Color', green_color);
% xline(time_young_maxAPA, '--','LineWidth',1.5, 'Color', purple_color);
xline(0.5409, '--','LineWidth',1.5, 'Color', purple_color);
xline(0.4809, '--','LineWidth',1.5, 'Color', purple_color);
xline(0.252,'--','LineWidth', 1.5, 'Color', 'black');
xline(0.295,'--','LineWidth', 1.5, 'Color', 'black');


xlim([-0.4 time_old(end)]);
ylim([0.04 0.96])
ylabel('Normalized Vertical Force','FontSize',4);
xlabel('Time (s)','FontSize',4);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
hold off
legend({'Young', 'Old'}, 'Location', 'southoutside','NumColumns',3,'Box','off');
box off
