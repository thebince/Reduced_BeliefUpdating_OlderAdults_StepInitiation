%% Script to plot simulations of latent variables (Fig 3.C and 3.D)

% Model Parameters of Perceptual and Response Model
prc_young = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -2.730 1.367];
prc_old = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -3.909 1.367];
priormus_young_b4 = [5.379 0.093 -1.559 1.835 0.122 0.07];
priormus_old_b4 = [5.631 0.093 -1.559 1.835 0.574 0.07];

% inputs
num_trials = 240;
block_trials = num_trials/2;
num_zeros = 11;
num_ones = 13;

block_one = constrainedRandomSequence(block_trials,0.75,num_zeros,num_ones);
block_two = constrainedRandomSequence(block_trials,0.25,num_zeros,num_ones);
u = [block_one; block_two];
% u = [block_two; block_one];
%% Simulate Belief Trajectory 
addpath("tapas\tapas-master");
tapas_init;

% Simulate RT 
sim_young = tapas_simModel(u,...
                     'tapas_ehgf_binary',...
                      prc_young,...
                     'tapas_logrt_linear_binary',...
                      priormus_young_b4,...
                      123456789);

sim_old = tapas_simModel(u,...
                     'tapas_ehgf_binary',...
                      prc_old,...
                     'tapas_logrt_linear_binary',...
                      priormus_old_b4,...
                      123456789);

belief_traj_sim_young = tapas_sgm(sim_young.traj.mu(:,2), 1);
belief_traj_sim_old = tapas_sgm(sim_old.traj.mu(:,2), 1);
pv_young = nan(length(u),1);
pv_old = nan(length(u),1);

for i = 1:length(u)
        
        pv_young(i) = belief_traj_sim_young(i).*(1-belief_traj_sim_young(i)); %.*exp(mu_three_sim_young(i));
        pv_old(i) = belief_traj_sim_old(i).*(1-belief_traj_sim_old(i)); %.*exp(mu_three_sim_old(i));

end

%%  Fig 3.C

% 'Reds' palette
reds = cbrewer2('seq', 'Reds', 3);
red_color = reds(end,:);

% 'Blues' palette
blues = cbrewer2('seq', 'Blues', 3);
blue_color = blues(end,:);

hFig = figure;


% Subplot 3,2,3
ax1 = subplot(2,1,2);
plot(1:length(u), sim_young.u(:,1), '.', 'Color', [0 0.6 0]);
hold on;
plot(1:length(u), tapas_sgm(sim_young.traj.mu(:,2), 1), 'Color', red_color, 'LineWidth', 2);
hold on;
plot(1:length(u), tapas_sgm(sim_old.traj.mu(:,2), 1), 'Color', blue_color, 'LineWidth', 2);

hold on;
xline(120,'-');
hold on;
yline(0.75,'--');
hold on;
yline(0.25,'--');
xlim([0 240]);
ylim([-0.1 1.1]);
ylabel('x_1','FontSize', 7);
xlabel('Trial Number','FontSize', 7);
ax1.LineWidth = 2.5; 
ax1.XAxis.TickLength = [0 0];
ax1.YAxis.TickLength = [0 0];  
ax1.XAxis.FontWeight = 'bold';
ax1.YAxis.FontWeight = 'bold'; 
box off

ax2 = subplot(2,1,1);
plot(1:length(u), pv_young, 'Color', red_color, 'LineWidth', 2);
hold on;
plot(1:length(u), pv_old, 'Color', blue_color, 'LineWidth', 2);
hold on;
xline(120,'-');
xlim([0 240]);
ylim([-0.01 0.3]);
ylabel('x_2','FontSize', 7);
ax2.LineWidth = 2.5; 
ax2.XAxis.TickLength = [0 0];
ax2.YAxis.TickLength = [0 0];  
ax2.XAxis.FontWeight = 'bold';
ax2.YAxis.FontWeight = 'bold'; 
box off

% Get current position and shift upward
pos = get(ax1, 'Position');
new_pos = [pos(1), pos(2) + 0.08, pos(3), pos(4)];  % Increase bottom by 0.03
set(ax1, 'Position', new_pos);
pos = get(ax2, 'Position');
new_pos = [pos(1), pos(2) + 0.06, pos(3), pos(4)];  % Increase bottom by 0.03
set(ax2, 'Position', new_pos);

h1 = plot(nan, nan, '.', 'Color', [0 0.6 0]);     % green dot (Go/NoGo)
hold on
h2 = plot(nan, nan, '-', 'Color', red_color, 'LineWidth', 2,'MarkerSize',3);   % red line (Young)
h3 = plot(nan, nan, '-', 'Color', blue_color, 'LineWidth', 2,'MarkerSize',3);   % blue line (Old)

lgd = legend([h1 h2 h3], ...
    {'Go/NoGo', 'Young', 'Old'}, ...
    'Orientation', 'horizontal', ...
    'Box', 'off', ...
    'FontSize', 0.3); % 3 items in first row, next 4 wrap to second

lgd.Units = 'normalized';  
lgd.Position = [0.5, 0.01, 0.05, 0.07]; % Adjust vertical size for two rows
lgd.Location = 'none';
lgd.ItemTokenSize = [4, 0.3];

%% Fig 3.D

hFig = figure;


% Subplot 3,2,3
ax1 = subplot(2,1,2);
plot(1:length(u), sim_young.traj.psi(:,2), 'Color', red_color, 'LineWidth', 2);
hold on;
plot(1:length(u), sim_old.traj.psi(:,2), 'Color', blue_color, 'LineWidth', 2);

hold on;
xline(120,'-');
hold on;
yline(0.5,'--');
xlim([0 240]);
ylim([-0.1 1.1]);
ylabel('Ψ','FontSize', 10);
xlabel('Trial Number','FontSize', 7);
ax1.LineWidth = 2.5; 
ax1.XAxis.TickLength = [0 0];
ax1.YAxis.TickLength = [0 0];  
ax1.XAxis.FontWeight = 'bold';
ax1.YAxis.FontWeight = 'bold'; 
box off

ax2 = subplot(2,1,1);
plot(1:length(u), sim_young.traj.epsi(:,2), 'Color', red_color, 'LineWidth', 2);
hold on;
plot(1:length(u), sim_old.traj.epsi(:,2), 'Color', blue_color, 'LineWidth', 2);
hold on;
xline(120,'-');
xlim([0 240]);
ylim([-0.5 0.6]);
h = ylabel('ε','FontSize', 10);
h.Rotation = 0;

ax2.LineWidth = 2.5; 
ax2.XAxis.TickLength = [0 0];
ax2.YAxis.TickLength = [0 0];  
ax2.XAxis.FontWeight = 'bold';
ax2.YAxis.FontWeight = 'bold'; 
box off

% Get current position and shift upward
pos = get(ax1, 'Position');
new_pos = [pos(1), pos(2) + 0.08, pos(3), pos(4)];  % Increase bottom by 0.03
set(ax1, 'Position', new_pos);
pos = get(ax2, 'Position');
new_pos = [pos(1), pos(2) + 0.06, pos(3), pos(4)];  % Increase bottom by 0.03
set(ax2, 'Position', new_pos);

h1 = plot(nan, nan, '.', 'Color', [0 0.6 0]);     % green dot (Go/NoGo)
hold on
h2 = plot(nan, nan, '-', 'Color', red_color, 'LineWidth', 2,'MarkerSize',3);   % red line (Young)
h3 = plot(nan, nan, '-', 'Color', blue_color, 'LineWidth', 2,'MarkerSize',3);   % blue line (Old)

lgd = legend([h2 h3], ...
    {'Young', 'Old'}, ...
    'Orientation', 'horizontal', ...
    'Box', 'off', ...
    'FontSize', 0.3); 

lgd.Units = 'normalized';  
lgd.Position = [0.5, 0.01, 0.05, 0.07]; % Adjust vertical size for two rows
lgd.Location = 'none';
lgd.ItemTokenSize = [4, 0.3];

