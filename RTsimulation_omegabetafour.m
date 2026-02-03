%% Script to run simulations for different om and betafour
% Model Parameters of Perceptual and Response Model
% Date - 03/12/2025
prc_young = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -2.730 1.367];
prc_old = [NaN 0 1 NaN 0.1000 1 NaN	0 0 1 1 NaN -3.909 1.367];
priormus_young_b4 = [5.379 0.093 -1.559 1.835 0.122 0.07];
priormus_old_b4 = [5.631 0.093 -1.559 1.835 0.574 0.07];

% fitted HGF parameters
om_one = linspace(-7,-1,7);
beta_four = linspace(0.1,1,7);
beta_four = round(beta_four,1);

% inputs
num_trials = 240;
block_trials = num_trials/2;
num_zeros = 11;
num_ones = 13;
u_zeroone_mg = nan(240,50);
u_zeroone_mng = nan(240,50);

%% Random sequence

for i = 1:50
    
    % random sequence
    block_one = constrainedRandomSequence(block_trials,0.75,num_zeros,num_ones);
    block_two = constrainedRandomSequence(block_trials,0.25,num_zeros,num_ones);
    u_mg = [block_one; block_two];
    u_mng = [block_two; block_one];

    u_zeroone_mg(:,i) = u_mg;
    u_zeroone_mng(:,i) = u_mng;

end


%% MG
% Run simulation
tapas_init;

pt_num = 0;

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)

            % random sequence
            u = u_zeroone_mg(:,k);
    
            om_one(i);
            beta_four(j);
            pt_num = pt_num + 1;
            simHGFData(om_one(i),beta_four(j),u,pt_num,k);
    
        end
    end
end

%% MNG

pt_num = 0;

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)

            % random sequence
            u = u_zeroone_mng(:,k);
    
            om_one(i);
            beta_four(j);
            pt_num = pt_num + 1;
            simHGFData(om_one(i),beta_four(j),u,pt_num,k);
    
        end
    end
end

%% MG Consecutive Go NoGo

foldername = 'Simulation_03122025_MG';

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)
    
            tablename = sprintf('simdata_learningrate%.2d_betafour%.2d_inputs%.2d_RT.csv', om_one(i), beta_four(j),k);
            fullpath = fullfile(foldername,tablename);
            sim_slope = readtable(fullpath);
    
            sim_slope.go_nogo = ~isnan(sim_slope.RTAPAOnset);
            
            changes = ~abs(diff(sim_slope.go_nogo(1:size(sim_slope,1))));
            cumulative = rcumsum(changes(1:length(changes)));
            sim_slope.('Consecutive_Go_NoGo')(1) = 0;
            sim_slope.('Consecutive_Go_NoGo')(2:size(sim_slope,1)) = cumulative(:);
    
            k1 = [sim_slope.go_nogo] == 0;
            k2 = [sim_slope.go_nogo] == 1;
            k3 = [sim_slope.Consecutive_Go_NoGo] ~= 0;
            list_consecutivezeros = k1&k3;
            list_consecutiveones = k2&k3;
            sim_slope.('Consecutive_Go')(find(list_consecutiveones)) = sim_slope.('Consecutive_Go_NoGo')(find(list_consecutiveones));
            sim_slope.('Consecutive_NoGo')(find(list_consecutivezeros)) = sim_slope.('Consecutive_Go_NoGo')(find(list_consecutivezeros));
    
            zeroIndices = find(sim_slope.('Consecutive_NoGo') == 0);
            changeToZeroIndices = zeroIndices(diff([0; zeroIndices]) > 1);
            valuesBefore = sim_slope.('Consecutive_NoGo')(changeToZeroIndices - 1);
            new_result = sim_slope.('Consecutive_NoGo');
            new_result(changeToZeroIndices) = -valuesBefore;
            new_result(new_result > 0) = 0;
            sim_slope.('Go_Consecutive_NoGo') = new_result;
            sim_slope.('Go_Consecutive_Go_NoGo') = sim_slope.("Go_Consecutive_NoGo") + sim_slope.('Consecutive_Go'); 
            sim_slope = removevars(sim_slope, {'Consecutive_Go_NoGo', 'Consecutive_Go', 'Consecutive_NoGo', 'Go_Consecutive_NoGo'});
    
            writetable(sim_slope,fullpath);
    
        end
    end
end

%% MNG Consecutive Go NoGo

foldername = 'Simulation_03122025_MNG';

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)
    
            tablename = sprintf('simdata_learningrate%.2d_betafour%.2d_inputs%.2d_RT.csv', om_one(i), beta_four(j),k);
            fullpath = fullfile(foldername,tablename);
            sim_slope = readtable(fullpath);
    
            sim_slope.go_nogo = ~isnan(sim_slope.RTAPAOnset);
            
            changes = ~abs(diff(sim_slope.go_nogo(1:size(sim_slope,1))));
            cumulative = rcumsum(changes(1:length(changes)));
            sim_slope.('Consecutive_Go_NoGo')(1) = 0;
            sim_slope.('Consecutive_Go_NoGo')(2:size(sim_slope,1)) = cumulative(:);
    
            k1 = [sim_slope.go_nogo] == 0;
            k2 = [sim_slope.go_nogo] == 1;
            k3 = [sim_slope.Consecutive_Go_NoGo] ~= 0;
            list_consecutivezeros = k1&k3;
            list_consecutiveones = k2&k3;
            sim_slope.('Consecutive_Go')(find(list_consecutiveones)) = sim_slope.('Consecutive_Go_NoGo')(find(list_consecutiveones));
            sim_slope.('Consecutive_NoGo')(find(list_consecutivezeros)) = sim_slope.('Consecutive_Go_NoGo')(find(list_consecutivezeros));
    
            zeroIndices = find(sim_slope.('Consecutive_NoGo') == 0);
            changeToZeroIndices = zeroIndices(diff([0; zeroIndices]) > 1);
            valuesBefore = sim_slope.('Consecutive_NoGo')(changeToZeroIndices - 1);
            new_result = sim_slope.('Consecutive_NoGo');
            new_result(changeToZeroIndices) = -valuesBefore;
            new_result(new_result > 0) = 0;
            sim_slope.('Go_Consecutive_NoGo') = new_result;
            sim_slope.('Go_Consecutive_Go_NoGo') = sim_slope.("Go_Consecutive_NoGo") + sim_slope.('Consecutive_Go'); 
            sim_slope = removevars(sim_slope, {'Consecutive_Go_NoGo', 'Consecutive_Go', 'Consecutive_NoGo', 'Go_Consecutive_NoGo'});
    
            writetable(sim_slope,fullpath);
    
        end
    end
end

%% Combine data into single table - MG

foldername = 'Simulation_03122025_MG';

allData = []; 

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)
    
    
            tablename = sprintf('simdata_learningrate%.2d_betafour%.2d_inputs%.2d_RT.csv', om_one(i), beta_four(j),k);
            fullpath = fullfile(foldername, tablename);
            
            % Read the CSV file, replace readtable with readmatrix if you want a numeric array
            data = readtable(fullpath);
            
            % Concatenate vertically
            allData = [allData; data];

        end
    end
end

writetable(allData,'simulatedRT_mgmng_50inputs.csv')

%% Combine data into single table - MNG

foldername = 'Simulation_03122025_MNG';

allData_MNG = []; 

for k = 1:50
    for i = 1:length(om_one)
        for j = 1:length(beta_four)
    
    
            tablename = sprintf('simdata_learningrate%.2d_betafour%.2d_inputs%.2d_RT.csv', om_one(i), beta_four(j),k);
            fullpath = fullfile(foldername, tablename);
            
            % Read the CSV file, replace readtable with readmatrix if you want a numeric array
            data = readtable(fullpath);
            
            % Concatenate vertically
            allData_MNG = [allData_MNG; data];

        end
    end
end

writetable(allData_MNG,'simulatedRT_mngmg_50inputs.csv')
%% Combine all conditions

bigtable = vertcat(allData,allData_MNG);
writetable(bigtable,'simulatedRT_100inputs.csv')
