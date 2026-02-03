function sim_data = simHGFData(learningrate,betafour,inputs,pt_num,k)
% To look at parameter space for om1 and betafour
% Created on 14-08-2025
% Update: Set the perceptual model to tapas_ehgf_binary instead of
% tapas_hgf_binary
% Author: Alan Bince

    % initialise tapas_init in the Command Window
    % Perceptual parameters
    prc_param = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN learningrate 1.367];

    % Observational model paramters
    priormus = [5.5 0.093 -1.559 1.835 betafour 0.07];

    % Simulate Reaction Time
    sim_data = tapas_simModel(inputs,...
                     'tapas_ehgf_binary',...
                      prc_param,...
                     'tapas_logrt_linear_binary',...
                      priormus,...
                      123456789);
    
    % Set No-Go responses to NAN
    sim_data.y(inputs==0) = nan;

    % Generate table
    sim_table = table;

%     for i = 1:length(inputs)
% 
%         sim_table.trial(i) = i;
% 
%         if i <= length(inputs)/2
%     
%             sim_table.condition(i) = 1;
%     
%         else
%     
%             sim_table.condition(i) = 2;
%     
%         end
%         
%         sim_table.RTLiftOff(i) = exp(sim_data.y(i));
% 
%     end

    sim_table.simulation_num(1:length(inputs),1) = pt_num;
    sim_table.input_sequence(1:length(inputs),1) = k;
    sim_table.trial = (1:length(inputs))';
    sim_table.go_nogo = inputs;
    sim_table.condition = zeros(length(inputs),1);
    sim_table.omega(1:length(inputs),1) = learningrate;
    sim_table.betafour(1:length(inputs),1) = betafour;
    sim_table.condition(1:length(inputs)/2) = 2;
    sim_table.condition(sim_table.condition == 0) = 1;
    sim_table.RTAPAOnset = exp(sim_data.y(:));

    % Save table
    foldername = 'Simulation_03122025_MNG';
    tablename = sprintf('simdata_learningrate%.2d_betafour%.2d_inputs%.2d_RT.csv',learningrate,betafour,k);
    fullpath = fullfile(foldername,tablename);
    writetable(sim_table,fullpath);

    fprintf('Simulation over. Data saved.\n');

end