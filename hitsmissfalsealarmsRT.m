% RT Table
RTable = readtable('newRT_29112025_withforces_APAfiltered.csv');

% Classification
RTable.Classification = zeros(height(RTable),1); % hits will be 1

for i = 1:size(RTable,1)

    % miss
    if (RTable.GoNoGo_Response(i) == 1 & ~isnan(RTable.Difference_TouchdownGo(i)))

            RTable.Classification(i) = 1;

    elseif (RTable.GoNoGo_Response(i) == 1 & isnan(RTable.Difference_TouchdownGo(i)))

            RTable.Classification(i) = 2;

    % falsealarm
    elseif (RTable.GoNoGo_Response(i) == 0 & ~isnan(RTable.Difference_LiftOffGo(i)))

            RTable.Classification(i) = 3;

    end

end

%% 
numZeros = sum(RTable.Classification == 0);
numOnes = sum(RTable.Classification == 1);
numTwos = sum(RTable.Classification == 2);
numThrees = sum(RTable.Classification == 3);

disp(['Number of 1s: ', num2str(numZeros)]);
disp(['Number of 1s: ', num2str(numOnes)]);
disp(['Number of 2s: ', num2str(numTwos)]);
disp(['Number of 3s: ', num2str(numThrees)]);

%%

numOnesYoung = sum(RTable.Classification == 1 & RTable.Group == 1);
numOnesOld = sum(RTable.Classification == 1 & RTable.Group == 2);
numTwosYoung = sum(RTable.Classification == 2 & RTable.Group == 1);
numTwosOld = sum(RTable.Classification == 2 & RTable.Group == 2);
numThreesYoung = sum(RTable.Classification == 3 & RTable.Group == 1);
numThreesOld = sum(RTable.Classification == 3 & RTable.Group == 2);

disp(['Number of 1s in Young : ', num2str(numOnesYoung)]);
disp(['Number of 1s in Old : ', num2str(numOnesOld)]);
disp(['Number of 2s in Young : ', num2str(numTwosYoung)]);
disp(['Number of 2s in Old : ', num2str(numTwosOld)]);
disp(['Number of 3s in Young : ', num2str(numThreesYoung)]);
disp(['Number of 3s in Old : ', num2str(numThreesOld)]);

%% 

% hit rate
hits_Young = numOnesYoung / sum(RTable.Group == 1 & RTable.GoNoGo_Response == 1);
hits_Old = numOnesOld / sum(RTable.Group == 2 & RTable.GoNoGo_Response == 1);
miss_Young = numTwosYoung / sum(RTable.Group == 1 & RTable.GoNoGo_Response == 1);
miss_Old = numTwosOld / sum(RTable.Group == 2 & RTable.GoNoGo_Response == 1);
falsealarm_Young = numThreesYoung / sum(RTable.Group == 1 & RTable.GoNoGo_Response == 2);
falsealarm_Old = numThreesOld / sum(RTable.Group == 2 & RTable.GoNoGo_Response == 2);

disp(['Hit rate in Young : ', num2str(hits_Young)]);
disp(['Hit rate in Old : ', num2str(hits_Old)]);
disp(['Miss rate in Young : ', num2str(miss_Young)]);
disp(['Miss rate in Old : ', num2str(miss_Old)]);
disp(['False Alarm rate in Young : ', num2str(falsealarm_Young)]);
disp(['False Alarm rate in Old : ', num2str(falsealarm_Old)]);

%% Table for hit rate, miss rate and false alarm rates

% assume columns: ParticipantID, Group, GoNoGo_Response, Classification

subj = unique(RTable.Participant_ID);
group(1:24) = 1;
group(25:49) = 2;
group = group';

nSubj = numel(subj);

HitRate        = nan(nSubj,1);
MissRate       = nan(nSubj,1);
FalseAlarmRate = nan(nSubj,1);

for k = 1:nSubj
    pid = subj(k);
    idx = RTable.Participant_ID == pid;

    % denominators
    nGo    = sum(idx & RTable.GoNoGo_Response == 1);  % go trials
    nNoGo  = sum(idx & RTable.GoNoGo_Response == 2);  % no-go trials

    % numerators (1=hit, 2=miss, 3=false alarm)
    nHit   = sum(idx & RTable.Classification == 1);
    nMiss  = sum(idx & RTable.Classification == 2);
    nFA    = sum(idx & RTable.Classification == 3);

    % rates
    if nGo > 0
        HitRate(k)  = nHit  / nGo;
        MissRate(k) = nMiss / nGo;
    end
    if nNoGo > 0
        FalseAlarmRate(k) = nFA / nNoGo;
    end
end

RateTable = table(subj, group, HitRate, MissRate, FalseAlarmRate, ...
    'VariableNames', {'ParticipantID','Group','HitRate','MissRate','FalseAlarmRate'});

% Replace NaNs with 0 in all rate columns
RateTable.HitRate(isnan(RateTable.HitRate)) = 0;
RateTable.MissRate(isnan(RateTable.MissRate)) = 0;
RateTable.FalseAlarmRate(isnan(RateTable.FalseAlarmRate)) = 0;

%% D-prime

% Add d-prime column with corrections
RateTable.dPrime = norminv(RateTable.HitRate) - norminv(RateTable.FalseAlarmRate);

% Correct extreme values (hit=1 or FA=0) using log-linear correction [1/500, 499/500]
RateTable.HitRate_corr = max(min(RateTable.HitRate, 1-1/500), 1/500);
RateTable.FalseAlarmRate_corr = max(min(RateTable.FalseAlarmRate, 1-1/500), 1/500);

% Recalculate with corrected rates
RateTable.dPrime_corr = norminv(RateTable.HitRate_corr) - norminv(RateTable.FalseAlarmRate_corr);

