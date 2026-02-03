%% Script to run HGF for APA onset time data of all participants
% Extract learning rate and beta parameters of all participants
% Make sure to set the tapas toolbox path correctly

% Add path to tapas-master
% Check the tapas-master folder location
% eg: addpath("tapas\tapas-master");
addpath("tapas\tapas-master");
tapas_init;

% RT Table of all participants
rt_table = readtable("newRT_29112025_withforces_APAfiltered.csv");

% % 'Reds' palette
% reds = cbrewer2('seq', 'Reds', 3);
% red_color = reds(end,:);
% % 'Blues' palette
% blues = cbrewer2('seq', 'Blues', 3);
% blue_color = blues(end,:);
learning_young = table;
count = 0;

% set inputs to NAN for APA is NAN for Go trials
rt_table.GoNoGo_Response(rt_table.NoAPA == 1) = NaN;

% Participant numbers - 1 to 24: Young; 101 to 125: Old
part = [1:24 101:125];

% run model for all participants 
for pp = 1:numel(part)

    % Go-NOGO Input
    u = rt_table.GoNoGo_Response(rt_table.Participant_ID == part(pp));

    % Reaction Time (Lift-Off)
    y = rt_table.Difference_APAOnsetGo(rt_table.Participant_ID == part(pp));

    % Group
    age = rt_table.Group(rt_table.Participant_ID == part(pp));

    % Configuration of Perceptual Model
    % take the default configuration of the HGF model (IMPORTANT !!)
    hgf_config = tapas_ehgf_binary_config();

    % Bayes Optimal parameters
    bopars = tapas_fitModel([],... % participant's responses (here empty because there are none yet)
                            u,... % sequence / stimulus inputs
                            hgf_config,... % observation/perceptual model
                            'tapas_bayes_optimal_config',... % response model
                            'tapas_quasinewton_optim_config'); % fitting algorithm

    % tapas_hgf_binary_plotTraj(bopars);

    % Configuration of Response Model
    logrt_config = tapas_logrt_linear_binary_config();

    % Set priors for log_rt model based on calibration (see S3)
    logrt_config.be0mu = log(200);
    logrt_config.be0sa = 4;
    logrt_config.be1mu = 0;
    logrt_config.be1sa = 4;
    logrt_config.be2mu = -2;
    logrt_config.be2sa = 4;
    logrt_config.be3mu = 2;
    logrt_config.be3sa = 4;
    logrt_config.be4mu = 2;
    logrt_config.be4sa = 4;
    logrt_config.logzemu = log(log(20));
    logrt_config.logzesa = 4;
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

    count = count + 1;
    learning_young.Participant_ID(count) = part(pp);
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

writetable(learning_young,'eHGF_filtered_parameters_APAOnset_29112025.csv');