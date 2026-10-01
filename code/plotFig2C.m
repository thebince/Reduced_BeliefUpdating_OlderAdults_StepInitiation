
%% Load data

data_folder = '../data';
data_filename = 'eHGF_estimatedparameters_APAOnset.csv';

t_name = fullfile(data_folder, data_filename);
parameters = readtable(t_name);
parameters.Group = categorical(parameters.Group, [1 2], {'young', 'old'});

% % 'Reds' palette
reds_dot = cbrewer2('seq', 'Reds', 3);

% % 'Blues' palette
blues_dot = cbrewer2('seq', 'Blues', 3);

greens = cbrewer2('seq', 'Greens', 9);
green_color = greens(7, :);   % forest green

reds = cbrewer2('seq', 'Reds', 9);
red_color = reds(8, :);   

blues = cbrewer2('seq', 'Blues', 9);
blue_color = blues(4, :);  

%% Raincloud plot - LR and Beta four (Fig 2.C)

% grouping of parameters
group = parameters.Group;
LR_young = parameters.learningrate_om1(parameters.Group == 'young');
LR_old = parameters.learningrate_om1(parameters.Group == 'old');
LR = {LR_young, LR_old};
colors = [red_color;blue_color];
B4_young = parameters.BetaFour(parameters.Group == 'young');
B4_old = parameters.BetaFour(parameters.Group == 'old');
B4 = {B4_young, B4_old};

% plotting
subplot(1,2,2);
daviolinplot(LR, ...
    'violin', 'half', ...         % half-side raincloud
    'colors', colors, ...
    'box', 2, ...                 % centered box
    'scatter', 1, ...             % scatter in center
    'jitter', 1, ...              % enable jitter for rain component
    'scatteralpha', 0.8, ...
    'scattersize', 25, ...
    'xtlabels', {'Young','Old'});
%set(gca, 'View', [90 -90]);
set(gca, 'FontSize', 7);
ylabel('ω');
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
box off;

subplot(1,2,1);
daviolinplot(B4, ...
    'violin', 'half', ...         % half-side raincloud
    'colors', colors, ...
    'box', 2, ...                 % centered box
    'scatter', 1, ...             % scatter in center
    'jitter', 1, ...              % enable jitter for rain component
    'scatteralpha', 0.8, ...
    'scattersize', 25, ...
    'xtlabels', {'Young','Old'});
%set(gca, 'View', [90 -90]);
set(gca, 'FontSize', 7);
ylabel('β4');
ax = gca;           % Get axis handle
ax.LineWidth = 2.5; % Thicken axis lines
ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
ax.YAxis.FontWeight = 'bold'; 
box off;
