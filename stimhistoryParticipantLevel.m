%% Data Organization

T = readtable('newRT_29112025_withforces_APAfiltered.csv');
T.Group = categorical(T.Group, [1 2], {'young', 'old'});
T.Condition = categorical(T.Condition, [1 2], {'mostly go', 'mostly no-go'});

groupnames = categories(T.Group);
stimhistory = unique(T.Go_Consecutive_Go_NoGo);

num_groups = numel(groupnames);
num_stimhistory = numel(stimhistory);

% Get list of all participants in the table
allParticipants = unique(T.Participant_ID);
numParticipants = numel(allParticipants);

% Initialise cell array for stim history grouping
Y_stimhistory_Touchdown = cell(1, num_stimhistory);
Y_stimhistory_LiftOff = cell(1, num_stimhistory);
Y_stimhistory_MaxAPA = cell(1, num_stimhistory);
Y_stimhistory_APAOnset = cell(1, num_stimhistory);

for c = 1:num_stimhistory
    mat_stimhistory_touchdown = nan(numParticipants, num_groups); % pre-allocate with participants all
    mat_stimhistory_liftoff = nan(numParticipants, num_groups);
    mat_stimhistory_maxapa = nan(numParticipants, num_groups);
    mat_stimhistory_apaonset = nan(numParticipants, num_groups);

    thisStimHistory = stimhistory(c);    
    for g = 1:num_groups
        thisGroup = groupnames{g};

        % Filter for this group and condition
        Tg = T(T.Group == thisGroup & T.Go_Consecutive_Go_NoGo == thisStimHistory, :);

        % For each participant, find mean RT or NaN if missing
        for p = 1:numParticipants
            participantID = allParticipants(p);
            idx = (Tg.Participant_ID == participantID);
            mat_stimhistory_touchdown(p, g) = mean(Tg.Difference_TouchdownGo(idx), 'omitnan');
            mat_stimhistory_liftoff(p, g) = mean(Tg.Difference_LiftOffGo(idx), 'omitnan');
            mat_stimhistory_maxapa(p, g) = mean(Tg.Difference_MaxAPAGo(idx), 'omitnan');
            mat_stimhistory_apaonset(p, g) =mean(Tg.Difference_APAOnsetGo(idx), 'omitnan');
        end
    end
    
    Y_stimhistory_Touchdown{c} = mat_stimhistory_touchdown;
    Y_stimhistory_LiftOff{c} = mat_stimhistory_liftoff;
    Y_stimhistory_MaxAPA{c} = mat_stimhistory_maxapa;
    Y_stimhistory_APAOnset{c} =  mat_stimhistory_apaonset;

end

num_stimhistory = numel(Y_stimhistory_Touchdown);
numParticipants = size(Y_stimhistory_Touchdown{1},1);

% Young group only: column 1 from each cell
young_touchdown = nan(numParticipants, num_stimhistory);
young_liftoff = nan(numParticipants, num_stimhistory);
young_maxapa = nan(numParticipants, num_stimhistory);
young_apaonset = nan(numParticipants, num_stimhistory);
for c = 1:num_stimhistory
    young_touchdown(:,c) = Y_stimhistory_Touchdown{c}(:,1); % Young
    young_liftoff(:,c) = Y_stimhistory_LiftOff{c}(:,1);
    young_maxapa(:,c) = Y_stimhistory_MaxAPA{c}(:,1);
    young_apaonset(:,c) = Y_stimhistory_APAOnset{c}(:,1);
end

% Old group only: column 2 from each cell
old_touchdown = nan(numParticipants, num_stimhistory);
old_liftoff = nan(numParticipants, num_stimhistory);
old_maxapa = nan(numParticipants, num_stimhistory);
old_apaonset = nan(numParticipants, num_stimhistory);

for c = 1:num_stimhistory
    old_touchdown(:,c) = Y_stimhistory_Touchdown{c}(:,2); % Old
    old_liftoff(:,c) = Y_stimhistory_LiftOff{c}(:,2);
    old_maxapa(:,c) = Y_stimhistory_MaxAPA{c}(:,2);
    old_apaonset(:,c) = Y_stimhistory_APAOnset{c}(:,2);
end

%% Slopes using polyfit
% x_partone = tab.Consecutive_Go_NoGo(tab.Participant_ID == 2);
% y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == 2);
% idx_nan = isnan(y_partone(:));
% 
% % fit
% p = polyfit(x_partone(~idx_nan),y_partone(~idx_nan),1);


%% Data Organization - Participant Level - Young

% c = brewermap(9,'Reds');
% redCB = c(6, :);         
% 
% cb = brewermap(9,'Blues');
% blueCB = cb(6, :); 
% 
% % participant by partiicipant table
% part_id = unique(T.Participant_ID);
% participantTables = cell(length(part_id), 1);
% for i = 1:length(part_id)
%     participantTables{i} = T(T.Participant_ID == part_id(i), :);
% end
% 
% 
% figure;
% rows = 4;
% cols = 6;
% numPlots = numel(participantTables);
% 
% for i = 1
%     % subplot(rows, cols, i);
%     tab = participantTables{i};
%     S = groupsummary(tab, 'Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
%     unique_x = S.Consecutive_Go_NoGo;
% 
%     hold on;
%     % Plot mean and std as error bars
%     errorbar(unique_x, S.mean_Difference_APAOnsetGo, S.std_Difference_APAOnsetGo, 'o-', 'LineWidth', 2, 'Color', redCB);
% 
%     % Overlay scatter of raw RT data with jitter
%     for k = 1:numel(unique_x)
%         idx = tab.Consecutive_Go_NoGo == unique_x(k);
%         xjitter = unique_x(k) + 0.03*randn(sum(idx),1);
%         scatter(xjitter, tab.Difference_APAOnsetGo(idx), 20, redCB, 'filled', 'MarkerFaceAlpha', 0.2);
%     end
% 
%     xlabel('Consecutive Go-NoGo');
%     ylabel('APA Onset Time (ms)');
%     xlim([-5.1 5.1]);
%     ylim([50 600]);
%     % title("Participant " + string(tab.Participant_ID(1)));
%     title("Young Participant 1");
%     ax = gca;           % Get axis handle
%     ax.LineWidth = 2.5; % Thicken axis lines
%     ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
%     ax.YAxis.TickLength = [0 0];  
%     ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
%     ax.YAxis.FontWeight = 'bold'; 
%     hold off;
%     box off;
% end

% exportgraphics(gcf, 'stimhistory_partoneyoung.png', 'Resolution', 600);
% %% Data Organization - Participant Level - Old
% 
% for i = 15
%     % subplot(rows, cols, i);
%     tab = participantTables{23 + i};
%     S = groupsummary(tab, 'Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
%     unique_x = S.Consecutive_Go_NoGo;
% 
%     hold on;
%     % Plot mean and std as error bars
%     errorbar(unique_x, S.mean_Difference_APAOnsetGo, S.std_Difference_APAOnsetGo, 'o-', 'LineWidth', 2, 'Color', blueCB);
% 
%     % Overlay scatter of raw RT data with jitter
%     for k = 1:numel(unique_x)
%         idx = tab.Consecutive_Go_NoGo == unique_x(k);
%         xjitter = unique_x(k) + 0.03*randn(sum(idx),1);
%         scatter(xjitter, tab.Difference_APAOnsetGo(idx), 20, blueCB, 'filled', 'MarkerFaceAlpha', 0.2);
%     end
% 
%     xlabel('Consecutive Go-NoGo');
%     ylabel('APA Onset Time (ms)');
%     xlim([-5.1 5.1]);
%     ylim([50 600]);
%     % title("Participant " + string(tab.Participant_ID(1)));
%     title("Old Participant 16");
%     ax = gca;           % Get axis handle
%     ax.LineWidth = 2.5; % Thicken axis lines
%     ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
%     ax.YAxis.TickLength = [0 0];  
%     ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
%     ax.YAxis.FontWeight = 'bold'; 
%     box off;
%     hold off;
% end
% % Adjust figure size and spacing if needed using 'set' or tiledlayout alternative
% 
% exportgraphics(gcf, 'stimhistory_partsixteenold.png', 'Resolution', 600);



% exportgraphics(gcf, 'stimhistory_young_global.png', 'Resolution', 600);
%% Data Organization - Global - Young

c = brewermap(9,'Reds');
redCB = c(6, :);         
cb = brewermap(9,'Blues');
blueCB = cb(6, :); 

part_id = unique(T.Participant_ID);
participantTables = cell(length(part_id), 1);
for i = 1:length(part_id)
    participantTables{i} = T(T.Participant_ID == part_id(i), :);
end

slope_young = table;

figure;
rows = 4;
cols = 6;

t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:24
    nexttile;
    tab = participantTables{i};
    S = groupsummary(tab, 'Go_Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
    unique_x = S.Go_Consecutive_Go_NoGo;
    x_partone = tab.Go_Consecutive_Go_NoGo(tab.Participant_ID == i);
    y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == i);
    idx_nan = isnan(y_partone(:));
    x_slope_line = linspace(-5,5,100)';
    
    p = polyfit(x_partone(~idx_nan), y_partone(~idx_nan), 1);
    slope_line = p(1)*x_slope_line + p(2);
    slope_young.slope(i) = p(1);
    slope_young.intercept(i) = p(2);
    
    hold on;
    
    for k = 1:numel(unique_x)
        idx = tab.Go_Consecutive_Go_NoGo == unique_x(k);
        xjitter = unique_x(k) + 0.2*randn(sum(idx),1);
        scatter(xjitter, tab.Difference_APAOnsetGo(idx), 12, redCB, 'filled', 'MarkerFaceAlpha', 0.5);
    end
    
    plot(x_slope_line, slope_line, 'Color', 'black', 'LineWidth', 1.5);
    
    if i == 1
        xlabel('Trial History','FontSize',6);
        ylabel('APA Onset Time(ms)','FontSize',6);
    end
    
    xlim([-5.1 5.1]);
    ylim([50 600]);
    title("Participant " + string(tab.Participant_ID(1)), 'FontSize',6);
    
    ax = gca;
    ax.LineWidth = 2.5;
    ax.XAxis.TickLength = [0 0];
    ax.YAxis.TickLength = [0 0];
    ax.XAxis.FontWeight = 'bold';
    ax.YAxis.FontWeight = 'bold';

    hold off;
    box off;
end

%% Data Organization - Global - Old

slope_old = table;

figure;
rows = 5;
cols = 5;

t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:25
    nexttile;
    tab = participantTables{24 + i};
    S = groupsummary(tab, 'Go_Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
    unique_x = S.Go_Consecutive_Go_NoGo;

    x_partone = tab.Go_Consecutive_Go_NoGo(tab.Participant_ID == tab.Participant_ID(1));
    y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == tab.Participant_ID(1));
    idx_nan = isnan(y_partone(:));
    x_slope_line = linspace(-4.5,4.5,100)';
    
    % fit
    p = polyfit(x_partone(~idx_nan),y_partone(~idx_nan),1);
    slope_line = p(1)*x_slope_line + p(2);

    slope_old.slope(i) = p(1);
    slope_old.intercept(i) = p(2);

    hold on;
    % Plot mean and std as error bars
    % errorbar(unique_x, S.mean_Difference_APAOnsetGo, S.std_Difference_APAOnsetGo, 'o-', 'LineWidth', 2, 'Color', blueCB);

    % Overlay scatter of raw RT data with jitter
    for k = 1:numel(unique_x)
        idx = tab.Go_Consecutive_Go_NoGo == unique_x(k);
        xjitter = unique_x(k) + 0.2*randn(sum(idx),1);
        scatter(xjitter, tab.Difference_APAOnsetGo(idx), 10, blueCB, 'filled', 'MarkerFaceAlpha', 0.5);
    end

    if i == 1
        xlabel('Trial History','FontSize',6);
        ylabel('APA Onset Time(ms)','FontSize',6);
    end
    hold on;
    % slope line
    plot(x_slope_line, slope_line, 'Color', 'black', 'LineWidth', 1.5);
    xlim([-5.1 5.1]);
    ylim([50 600]);
    title("Participant " + string(tab.Participant_ID(1)-100),'FontSize',6);
    % title("Old Participant 16");
    ax = gca;           % Get axis handle
    ax.LineWidth = 2.5; % Thicken axis lines
    ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
    ax.YAxis.TickLength = [0 0];  
    ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
    ax.YAxis.FontWeight = 'bold'; 
    box off;
    hold off;

end
% Adjust figure size and spacing if needed using 'set' or tiledlayout alternative

% exportgraphics(gcf, 'stimhistory_old_global.png', 'Resolution', 600);

% %% Plotting
% 
% xlabels = cellstr(num2str(stimhistory));
% blueCB = [0, 114, 178]/255;
% redCB = [213, 94, 0]/255;
% 
% %% Fig 1 - Touchdown Liftoff Young
% figure;
% box off
% 
% subplot(2,1,1);
% daboxplot(young_touchdown,'colors',redCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Touchdown Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% % ylabel('Touchdown Time (ms)');
% % title('Touchdown Times - Young');
% 
% subplot(2,1,2);
% daboxplot(young_liftoff,'colors',redCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Lift-Off Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% exportgraphics(gcf, 'touchdownliftoff_stimhistory_young.png', 'Resolution', 600);
% %% Fig 2 - Touchdown LIftoff Old 
% figure;
% box off
% 
% subplot(2,1,1);
% daboxplot(old_touchdown,'colors',blueCB,'boxalpha',0.7,'scatter',2,'mean', 0, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Touchdown Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% subplot(2,1,2);
% daboxplot(old_liftoff,'colors',blueCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Lift-Off Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% exportgraphics(gcf, 'touchdownliftoff_stimhistory_old.png', 'Resolution', 600);
% %% Fig 3 - Max APA APA Onset - Young
% figure;
% box off
% 
% subplot(2,1,1);
% daboxplot(young_maxapa,'colors',redCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Maximum APA Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% subplot(2,1,2);
% daboxplot(young_apaonset,'colors',redCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('APA Onset Time (ms)','FontSize', 8,'FontWeight','bold');
% xlim([-5.1 5.1]);
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% exportgraphics(gcf, 'maxapaapaonset_stimhistory_young.png', 'Resolution', 600);
% %% Fig 4 - Max APA APA Onset - Old
% figure;
% box off
% 
% subplot(2,1,1);
% daboxplot(old_maxapa,'colors',blueCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('Maximum APA Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% subplot(2,1,2);
% daboxplot(old_apaonset,'colors',blueCB,'boxalpha',0.7,'scatter',2,'mean', 1, 'linkline', 1);
% xticks(1:numel(stimhistory));          % Set x-ticks to positions 1 to 39
% xticklabels(xlabels);                   % Set x-tick labels from stimhistory
% % xtickangle(45);                        % Rotate labels for better readability
% xlabel('Stimulus History','FontSize', 8,'FontWeight','bold');
% ylabel('APA Onset Time (ms)','FontSize', 8,'FontWeight','bold');
% ylim([50 1800]);
% ax = gca;           % Get axis handle
% ax.LineWidth = 2.5; % Thicken axis lines
% ax.XAxis.TickLength = [0 0];  % Remove x-axis tick marks (leave labels)
% ax.YAxis.TickLength = [0 0];  
% ax.XAxis.FontWeight = 'bold'; % Make x-axis tick labels bold
% ax.YAxis.FontWeight = 'bold'; 
% hold off
% 
% exportgraphics(gcf, 'maxapaapaonset_stimhistory_old.png', 'Resolution', 600);
% 
% %%
% 
% slope_old = table;
% t = tiledlayout(5, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
% for i = 1:25
%     nexttile;
%     tab = participantTables{24 + i};
%     S = groupsummary(tab, 'Go_Consecutive_Go_NoGo', {'mean', 'std'}, 'Difference_APAOnsetGo');
%     unique_x = S.Go_Consecutive_Go_NoGo;
%     x_partone = tab.Go_Consecutive_Go_NoGo(tab.Participant_ID == tab.Participant_ID(1));
%     y_partone = tab.Difference_APAOnsetGo(tab.Participant_ID == tab.Participant_ID(1));
%     idx_nan = isnan(y_partone(:));
%     x_slope_line = linspace(-4.5,4.5,100)';
%     
%     % fit
%     p = polyfit(x_partone(~idx_nan), y_partone(~idx_nan), 1);
%     slope_line = p(1)*x_slope_line + p(2);
%     slope_old.slope(i) = p(1);
%     slope_old.intercept(i) = p(2);
%     
%     hold on;
%     
%     % Plot raw data scatter with jitter (your original loop)
%     for k = 1:numel(unique_x)
%         idx = tab.Go_Consecutive_Go_NoGo == unique_x(k);
%         xjitter = unique_x(k) + 0.2*randn(sum(idx),1);
%         scatter(xjitter, tab.Difference_APAOnsetGo(idx), 10, blueCB, 'filled', 'MarkerFaceAlpha', 0.5);
%     end
%     
%     % slope line
%     plot(x_slope_line, slope_line, 'Color', 'black', 'LineWidth', 1.5);
%     
%     hold off;
%     
%     xlim([-5.1 5.1]);
%     ylim([50 600]);
%     title("Participant " + string(tab.Participant_ID(1)-100),'FontSize',6);
%     
%     if i == 1
%         xlabel('Trial History','FontSize',4);
%         ylabel('APA Onset Time(ms)','FontSize',3);
%     end
%     
%     ax = gca;
%     ax.LineWidth = 2.5;
%     ax.XAxis.TickLength = [0 0];
%     ax.YAxis.TickLength = [0 0];  
%     ax.XAxis.FontWeight = 'bold';
%     ax.YAxis.FontWeight = 'bold'; 
%     box off;
% end
