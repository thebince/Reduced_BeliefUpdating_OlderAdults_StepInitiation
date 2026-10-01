
%% Load Data

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

%% Extract latencies

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

%% Plot figure

teal = cbrewer2('BuGn', 9);
teal_dark = teal(end, :);      % darkest teal-green

orange = cbrewer2('Oranges', 6);
orange_light = orange(3, :);   % light-mid peach/orange, still visibly colored

c = [orange_light; teal_dark];

figure;

box off;
h = daviolinplot(Y_cond_APAOnset, ...
    'colors',c,...
    'violin', 'half', ...
    'scatter', 1, ...
    'jitter', 1, ...
    'xtlabels', cellstr(groupnames), ...
    'scattersize', 10,...
    'legend', cellstr(conditionnames));
    
ylabel('APA Onset Time (ms)','FontSize', 8);
ylim([100 500]);
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
legend off;
hold off