%% Script to plot Sensitivity Analysis Precision Weighting Graphs
% Supplementary Figures S5
% Date: 10/07/2026

% tapas toolbox initialization
tapas_init;

% Colour settings for plots
% 'Reds' palette
reds = cbrewer2('seq', 'Reds', 3);
red_color = reds(end,:);

% 'Blues' palette
blues = cbrewer2('seq', 'Blues', 3);
blue_color = blues(end,:);

%% Inputs and Parameters

% Model Parameters of Perceptual and Response Model
prc_young_160 = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -2.78 1.112];
prc_young_240 = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -2.73 1.306];
prc_old = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -3.909 1.427];

priormus_young_b4_160 = [5.399 0.077 -1.735 1.881 0.38 0.068];
priormus_young_b4_240 = [5.379 0.111 -1.221 1.796 0.122 0.07];
priormus_old_b4 = [5.631 0.075 -1.896 1.874 0.574 0.07];

% inputs (160)
num_trials_low = 160;
block_trials_low = num_trials_low/2;
num_zeros = 11;
num_ones = 13;

block_three = constrainedRandomSequence(block_trials_low,0.75,num_zeros,num_ones);
block_four = constrainedRandomSequence(block_trials_low,0.25,num_zeros,num_ones);
u_low = [block_three; block_four];

% inputs (240)
num_trials = 240;
block_trials = num_trials/2;
num_zeros = 11;
num_ones = 13;

block_one = constrainedRandomSequence(block_trials,0.75,num_zeros,num_ones);
block_two = constrainedRandomSequence(block_trials,0.25,num_zeros,num_ones);
u = [block_one; block_two];


%% Simulate Belief Trajectory 

% Simulate RT 
sim_young_low = tapas_simModel(u_low,...
                     'tapas_ehgf_binary',...
                      prc_young_160,...
                     'tapas_logrt_linear_binary',...
                      priormus_young_b4_160,...
                      123456789);

sim_old_low = tapas_simModel(u_low,...
                     'tapas_ehgf_binary',...
                      prc_old,...
                     'tapas_logrt_linear_binary',...
                      priormus_old_b4,...
                      123456789);


sim_young = tapas_simModel(u,...
                     'tapas_ehgf_binary',...
                      prc_young_240,...
                     'tapas_logrt_linear_binary',...
                      priormus_young_b4_160,...
                      123456789);

sim_old = tapas_simModel(u,...
                     'tapas_ehgf_binary',...
                      prc_old,...
                     'tapas_logrt_linear_binary',...
                      priormus_old_b4,...
                      123456789);


belief_traj_sim_young_low = tapas_sgm(sim_young_low.traj.mu(:,2), 1);
belief_traj_sim_old_low = tapas_sgm(sim_old_low.traj.mu(:,2), 1);
belief_traj_sim_young = tapas_sgm(sim_young.traj.mu(:,2), 1);
belief_traj_sim_old = tapas_sgm(sim_old.traj.mu(:,2), 1);

pv_young_low = nan(length(u_low),1);
pv_old_low = nan(length(u_low),1);
pv_young = nan(length(u),1);
pv_old = nan(length(u),1);

for i = 1:length(u_low)
        
        pv_young_low(i) = belief_traj_sim_young_low(i).*(1-belief_traj_sim_young_low(i)); %.*exp(mu_three_sim_young(i));
        pv_old_low(i) = belief_traj_sim_old_low(i).*(1-belief_traj_sim_old_low(i)); %.*exp(mu_three_sim_old(i));
        pv_young(i) = belief_traj_sim_young(i).*(1-belief_traj_sim_young(i)); %.*exp(mu_three_sim_young(i));
        pv_old(i) = belief_traj_sim_old(i).*(1-belief_traj_sim_old(i)); %.*exp(mu_three_sim_old(i));

end

%% Fig for Precision weighting

hFig = figure;


% Subplot 3,2,3
ax1 = subplot(1,2,1);
plot(1:length(u_low), sim_young_low.traj.psi(:,2), 'Color', red_color, 'LineWidth', 2);
hold on;
plot(1:length(u_low), sim_old_low.traj.psi(:,2), 'Color', blue_color, 'LineWidth', 2);

hold on;
xline(80,'-');
hold on;
yline(0.5,'--');
xlim([0 160]);
ylim([-0.1 1.1]);
ylabel('Ψ','FontSize', 10);
xlabel('Trial Number','FontSize', 7);
ax1.LineWidth = 2.5; 
ax1.XAxis.TickLength = [0 0];
ax1.YAxis.TickLength = [0 0];  
ax1.XAxis.FontWeight = 'bold';
ax1.YAxis.FontWeight = 'bold'; 
title(ax1, '160 trials', 'FontSize', 12, 'FontWeight', 'bold');
box off

ax2 = subplot(1,2,2);
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
ax2.LineWidth = 2.5; 
ax2.XAxis.TickLength = [0 0];
ax2.YAxis.TickLength = [0 0];  
ax2.XAxis.FontWeight = 'bold';
ax2.YAxis.FontWeight = 'bold'; 
title(ax2, '240 trials', 'FontSize', 12, 'FontWeight', 'bold');
box off

h1 = plot(nan, nan, '-', 'Color', red_color, 'LineWidth', 2);
h2 = plot(nan, nan, '-', 'Color', blue_color, 'LineWidth', 2);

lgd = legend([h1 h2], {'Young','Old'}, ...
    'Orientation','horizontal', ...
    'Box','off');

lgd.Units = 'normalized';
lgd.Position = [0.42 0.01 0.16 0.05];
lgd.Location = 'none';
lgd.ItemTokenSize = [8 2];



