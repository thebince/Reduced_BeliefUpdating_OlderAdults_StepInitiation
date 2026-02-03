%% Independent samples ttests with effect sizes and multiple comparisons correction

hgf_param = readtable('eHGF_filtered_parameters_APAOnset_29112025.csv');
hgf_param(:,4) = [];

param_cols = 3:9;  % Your 7 parameter columns
results = table();  
for i = param_cols
    param_name = hgf_param.Properties.VariableNames{i};
    groupA = hgf_param{:,i}(hgf_param.Group == 1);
    groupB = hgf_param{:,i}(hgf_param.Group == 2);
    [h, p, ci, stats] = ttest2(groupA, groupB, 'Alpha', 0.05, 'Vartype', 'unequal');
    
    % Create row as table with matching sizes (all scalars)
    row_data = table({param_name}, h, p, stats.tstat, ...
                     'VariableNames', {'Parameter', 'Significant', 'pvalue', 'tstat'});
    results = [results; row_data];
end
disp(results);

pvals = results.pvalue';  % Column vector of p-values

[h_fdr, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(pvals, 0.05, 'pdep', 'yes');