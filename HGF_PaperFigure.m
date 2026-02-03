%% Script to run figures for HGF (Fig 2.B and Fig 2.C)

% Add path
addpath("tapas\tapas-master");
tapas_init;

% Data
rt_table = readtable('newRT_29112025_withforces_APAfiltered.csv');
parameters = readtable('eHGF_filtered_parameters_APAOnset_29112025.csv');
parameters.Group = categorical(parameters.Group, [1 2], {'young', 'old'});

% 'Reds' palette
reds = cbrewer2('seq', 'Reds', 3);
red_color = reds(end,:);

% 'Blues' palette
blues = cbrewer2('seq', 'Blues', 3);
blue_color = blues(end,:);

colors = cbrewer2('Set1', 8); 

pink = colors(8, :);   
orange = colors(5, :); 


learning_young = table;
count = 0;

% set inputs to NAN for APA is NAN for Go trials 
rt_table.GoNoGo_Response(rt_table.NoAPA == 1) = NaN;

part = [1:24 101:125];

%% Representative Participant - Young
for pp = 16

    % Go-NOGO Input
    u = rt_table.GoNoGo_Response(rt_table.Participant_ID == part(pp));
    
    % Reaction Time (APA Onset)
    y = rt_table.Difference_APAOnsetGo(rt_table.Participant_ID == part(pp));
    
    % take the default configuration of the HGF model (IMPORTANT !!)
    hgf_config = tapas_ehgf_binary_config();
    
    % Bayes Optimal parameters
    bopars = tapas_fitModel([],... % participant's responses (here empty because there are none yet)
                             u,... % sequence / stimulus inputs
                             hgf_config,... % observation/perceptual model
                             'tapas_bayes_optimal_config',... % response model
                             'tapas_quasinewton_optim_config'); % fitting algorithm
    % tapas_hgf_binary_plotTraj(bopars);
    
    % take the default configuration of the HGF model
    logrt_config = tapas_logrt_linear_binary_config(); 
    logrt_config.be0mu = log(200);
    logrt_config = tapas_align_priors(logrt_config);
    
    % Simulate Responses
    sim = tapas_simModel(u,...
                         'tapas_ehgf_binary',...
                         bopars.p_prc.p,...
                         'tapas_logrt_linear_binary',...
                         logrt_config.priormus,...
                         ... % ZeValid, ZeInvalid, ZeSurprise, ZeUnused, Ze0
                         123456789);
    
    % tapas_hgf_binary_plotTraj(sim);
    
    % Participant parameter
    hgf_config.ommu = bopars.p_prc.om;
    hgf_config = tapas_align_priors(hgf_config);
    
    subpars = tapas_fitModel(log(y),... % participant's responses 
                             u,... % sequence / stimulus inputs
                             hgf_config,... % observation/perceptual model
                             logrt_config,... % response model
                             'tapas_quasinewton_optim_config'); % fitting algorithm
    
    % tapas_hgf_binary_plotTraj(subpars)
    % Input young
    u_young = u;

    % belief trajectory -level 1 for plot
    belief_traj_young = tapas_sgm(subpars.traj.mu(:,2), 1);
    mu_three_young = subpars.traj.mu(:,3);
    belief_traj_sim_young = tapas_sgm(sim.traj.mu(:,2), 1);
    mu_three_sim_young = sim.traj.mu(:,3);


    % post-error slowing
    pv_young = nan(length(u),1);
    sv_young = nan(length(u),1);
    for i = 1:length(u)
        
        pv_young(i) = belief_traj_young(i).*(1-belief_traj_young(i)); %.*exp(mu_three_young(i));
        sv_young(i) = belief_traj_sim_young(i).*(1-belief_traj_sim_young(i)); %.*exp(mu_three_sim_young(i));

    end

    % Log RT
    predict_RT_young = exp(subpars.optim.yhat);
    real_RT_young = exp(subpars.y);
    real_RT_young(y < 100) = nan; 

end

%% Representative Participant - Old
for pp = 27

    % Go-NOGO Input
    u = rt_table.GoNoGo_Response(rt_table.Participant_ID == part(pp));
    
    % Reaction Time (Lift-Off)
    y = rt_table.Difference_APAOnsetGo(rt_table.Participant_ID == part(pp));

    % Group
    age = rt_table.Group(rt_table.Participant_ID == part(pp));
    
    % take the default configuration of the HGF model (IMPORTANT !!)
    hgf_config = tapas_ehgf_binary_config();
    
    % Bayes Optimal parameters
    bopars = tapas_fitModel([],... % participant's responses (here empty because there are none yet)
                             u,... % sequence / stimulus inputs
                             hgf_config,... % observation/perceptual model
                             'tapas_bayes_optimal_config',... % response model
                             'tapas_quasinewton_optim_config'); % fitting algorithm
    % tapas_hgf_binary_plotTraj(bopars);
    
    % take the default configuration of the HGF model
    logrt_config = tapas_logrt_linear_binary_config(); 
    logrt_config.be0mu = log(200);
    logrt_config = tapas_align_priors(logrt_config);
    
    % Simulate Responses
    sim = tapas_simModel(u,...
                         'tapas_ehgf_binary',...
                         bopars.p_prc.p,...
                         'tapas_logrt_linear_binary',...
                         logrt_config.priormus,...
                         ... % ZeValid, ZeInvalid, ZeSurprise, ZeUnused, Ze0
                         123456789);
    
    % tapas_hgf_binary_plotTraj(sim);
    
    % Participant parameter
    hgf_config.ommu = bopars.p_prc.om;
    hgf_config = tapas_align_priors(hgf_config);
    
    subpars = tapas_fitModel(log(y),... % participant's responses 
                             u,... % sequence / stimulus inputs
                             hgf_config,... % observation/perceptual model
                             logrt_config,... % response model
                             'tapas_quasinewton_optim_config'); % fitting algorithm
    
    % tapas_hgf_binary_plotTraj(subpars)
    % Input young
    u_old = u;

    % belief trajectory -level 1 for plot
    belief_traj_old = tapas_sgm(subpars.traj.mu(:,2), 1);
    mu_three_old = subpars.traj.mu(:,3);
    belief_traj_sim_old = tapas_sgm(sim.traj.mu(:,2), 1);
    mu_three_sim_old = sim.traj.mu(:,3);


    % post-error slowing
    pv_old = nan(length(u),1);
    sv_old = nan(length(u),1);
    for i = 1:length(u)
        
        pv_old(i) = belief_traj_old(i).*(1-belief_traj_old(i)); % .*exp(mu_three_old(i));
        sv_old(i) = belief_traj_sim_old(i).*(1-belief_traj_sim_old(i)); %.*exp(mu_three_sim_old(i));

    end

    % Log RT
    predict_RT_old = exp(subpars.optim.yhat);
    real_RT_old = exp(subpars.y);
    real_RT_old(y < 100) = nan;

end


%% Fig 2.B

hFig = figure;

% Adjusted smaller subplot positions: [left bottom width height]
pos = {
    [0.1  0.75  0.35 0.18],  % subplot(3,2,1)
    [0.55 0.75  0.35 0.18],  % subplot(3,2,2)
    [0.1  0.5   0.35 0.18],  % subplot(3,2,3)
    [0.55 0.5   0.35 0.18],  % subplot(3,2,4)
    [0.1  0.25  0.35 0.18],  % subplot(3,2,5)
    [0.55 0.25  0.35 0.18],  % subplot(3,2,6)
};

% Subplot 3,2,3
ax = subplot(3,2,3);
set(ax, 'Position', pos{3});
plot(1:240, u_young, '.', 'Color', [0 0.6 0]);
hold on;
plot(1:240, belief_traj_young, 'Color', red_color, 'LineWidth', 2);
xline(120,'-');
yline(0.75,'--');
yline(0.25,'--');
xlim([0 240]);
ylim([-0.1 1.1]);
ylabel('x_1','FontSize', 7);
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off

% Subplot 3,2,1
ax = subplot(3,2,1);
set(ax, 'Position', pos{1});
plot(1:240, pv_young, 'Color', red_color, 'LineWidth', 2);
hold on;
xline(120,'-');
xlim([0 240]);
ylim([0 0.3]);
title('Young','FontSize', 12);
ylabel('x_2','FontSize', 7);
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off

% Subplot 3,2,2
ax = subplot(3,2,2);
set(ax, 'Position', pos{2});
plot(1:160, pv_old, 'Color', blue_color, 'LineWidth', 2);
hold on;
xline(80,'-');
xlim([0 160]);
ylim([0 0.3]);
title('Old','FontSize', 12);
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off

% Subplot 3,2,4
ax = subplot(3,2,4);
set(ax, 'Position', pos{4});
plot(1:160, u_old, '.', 'Color', [0 0.6 0]);
hold on;
plot(1:160, belief_traj_old, 'Color', blue_color, 'LineWidth', 2);
xline(80,'-');
yline(0.75,'--');
yline(0.25,'--');
xlim([0 160]);
ylim([-0.1 1.1]);
ax.LineWidth = 2.5; 
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off

% Subplot 3,2,5
ax = subplot(3,2,5);
set(ax, 'Position', pos{5});
h = plot(1:240, real_RT_young, 'o', 'Color', reds(3,:), 'LineWidth', 2, 'MarkerSize',3, 'MarkerFaceColor', reds(3,:));
hold on;
plot(1:240, predict_RT_young, 'x', 'Color', reds(2,:), 'LineWidth', 2, 'MarkerSize',4);
hold on;
xline(120,'-');
ylabel('RT (ms)','FontSize', 7);
xlabel('Trial Number','FontSize', 7);
ylim([50 400]);
xlim([0 240]);
ax.LineWidth = 2.5;
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off;

% Subplot 3,2,6
ax = subplot(3,2,6);
set(ax, 'Position', pos{6});
plot(1:160, real_RT_old, 'o', 'Color', blues(3,:), 'LineWidth', 2,'MarkerSize',3, 'MarkerFaceColor', blues(3,:));
hold on;
plot(1:160, predict_RT_old, 'x','Color', blues(2,:), 'LineWidth', 2, 'MarkerSize',4);
hold on;
xline(80,'-');
% xlabel('Trial Number','FontSize', 7);
ylim([50 400]);
xlim([0 160]);
ax.LineWidth = 2.5;
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];  
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold'; 
box off;

h1 = plot(nan, nan, '.', 'Color', [0 0.6 0]);     % green dot (Go/NoGo)
hold on
h2 = plot(nan, nan, '-', 'Color', red_color, 'LineWidth', 2,'MarkerSize',3);   % red line (Young)
h3 = plot(nan, nan, '-', 'Color', blue_color, 'LineWidth', 2,'MarkerSize',3);   % blue line (Old)
h4 = plot(nan, nan, 'x', 'Color', reds(2,:), 'LineWidth', 2,'MarkerSize',3);   % blue x (pred RT)
h5 = plot(nan, nan, 'o', 'Color', reds(3,:), 'LineWidth', 2,'MarkerSize',3, 'MarkerFaceColor', reds(3,:));   % red circle (real RT)
h6 = plot(nan, nan, 'x', 'Color', blues(2,:), 'LineWidth', 2,'MarkerSize',3);   % blue x (pred RT)
h7 = plot(nan, nan, 'o', 'Color', blues(3,:), 'LineWidth', 2,'MarkerSize',3, 'MarkerFaceColor', blues(3,:));   % red circle (real RT)

lgd = legend([h1 h2 h3 h4 h5 h6 h7], ...
    {'Go/NoGo', 'Young', 'Old', ...
    'Predicted RT (Y)', 'Real RT (Y)', ...
    'Predicted RT (O)', 'Real RT (O)'}, ...
    'Orientation', 'horizontal', ...
    'Box', 'off', ...
    'FontSize', 0.5, ...
    'NumColumns', 4); % 3 items in first row, next 4 wrap to second

lgd.Units = 'normalized';  
lgd.Position = [0.2, 0.03, 0.6, 0.08]; % Adjust vertical size for two rows
lgd.Location = 'none';
lgd.ItemTokenSize = [5, 0.5];


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
figure;
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

figure;
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




