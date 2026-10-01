# Reduced_BeliefUpdating_OlderAdults_StepInitiation
This repository contains data and code to reproduce results from the paper: Reduced belief updating impairs adaptive step initiation in older adults. Link to the paper can be found here - https://doi.org/10.64898/2025.12.19.695189

### Software requirements

Software  |Version
--------- | -------------
MATLAB    | R2022b
JASP      | 0.19.2.0
R         | 2024.09.0+174
TAPAS     | version 6.0.1

All statistics were run using JASP. Main results on the manuscript and supplementary information were presented using MATLAB and R. Data visualization was done using daviolinplot (https://zenodo.org/records/12749045). Hierarchical Gaussian Filter (HGF) was applied on data using TAPAS toolbox in MATLAB (https://translationalneuromodeling.github.io/tapas/). 

### Computational Modelling (HGF)

To fit RT data to HGF, make sure to follow this instruction:

1. Unzip tapas-master
2. Add tapas-master folder into the MATLAB path
3. Set priors for the Beta parameters in tapas_logrt_linear_binary_config (../tapas-master/HGF)
4. Run fit_realdataHGF_posturalonset (../code)

After fitting the HGF to one participant, you can display the belief trajectories across each level as shown below. To plot this image, use tapas_hgf_binary_plotTraj (in ../tapas-master/HGF).
![image_alt](https://github.com/thebince/Reduced_BeliefUpdating_OlderAdults_StepInitiation/blob/2ea403f144da13bf0b265071a5f2562f4bc2e9db/HGFposteriorexpectations_exampleparticipant_png.png)
