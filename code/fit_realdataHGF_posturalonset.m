%% HGF - Postural Onset Time
% Script to fit APA onset time data to HGF 

% Parameter Settings (check tapas_logrt_linear_binary_config)
% Beta_0: be0mu = log(200); be0sa = 4;
% Beta_1: be1mu = 0; be1sa = 4;
% Beta_2: be2mu = -2; be2sa = 4;
% Beta_3: c.be3mu = 2; c.be3sa = 4;
% Beta_4: c.be4mu = 2; c.be4sa = 4;
% Zeta: c.logzemu = log(log(20)); c.logzesa = 4;

% add tapas-master to path for HGF
addpath('../tapas-master')
tapas_init

% load data
data_folder = '../data';
data_filename = 'behaviouraldataStepping.csv';

t_name = fullfile(data_folder, data_filename);
rt_table = readtable(t_name);

% 'Reds' palette
reds = cbrewer2('seq', 'Reds', 3);
red_color = reds(end,:);

% 'Blues' palette
blues = cbrewer2('seq', 'Blues', 3);
blue_color = blues(end,:);

learning_young = table;
latent_tab = table;
count = 0;

% set inputs to NAN for APA is NAN for Go trials 
rt_table.GoNoGo_Response(rt_table.NoAPA == 1) = NaN;

part = [1:24 101:125];

for pp = 1:length(part)

    % Go-NOGO Input
    u = rt_table.GoNoGo_Response(rt_table.Participant_ID == part(pp));
    
    % Reaction Time (Lift-Off)
    y = rt_table.Difference_APAOnsetGo(rt_table.Participant_ID == part(pp));
    
    % Group
    age = rt_table.Group(rt_table.Participant_ID == part(pp));

    % Side
    side = rt_table.Side(rt_table.Participant_ID == part(pp));
    
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

    % subject_corr(pp) = corr(subpars.optim.yhat,subpars.y, 'rows','complete');
    count = count + 1;

     learning_young.Participant_ID(count) = part(pp);
     % learning_young.Correlation_MeasuredPredicted(count) = subject_corr(pp);
     learning_young.Group(count) = age(1);
     learning_young.learningrate_om1(count) = subpars.p_prc.om(2);
     learning_young.learningrate_om2(count) = subpars.p_prc.om(3);
     learning_young.BetaZero(count) = subpars.p_obs.be0;
     learning_young.BetaOne(count) = subpars.p_obs.be1;
     learning_young.BetaTwo(count) = subpars.p_obs.be2;
     learning_young.BetaThree(count) = subpars.p_obs.be3;
     learning_young.BetaFour(count) = subpars.p_obs.be4;
     learning_young.Zeta(count) = subpars.p_obs.ze;


end
