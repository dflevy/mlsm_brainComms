# mlsm_brainComms

This code accompanies Levy et al., in press, "Multivariate lesion symptom mapping for predicting trajectories of recovery from aphasia". 

## Key analysis files
| Filename | Description |
|---|---|
| MLSM_make_models.m | The main code for generating SVR models. Currently a script that saves out the models directly. |

## Data tables available upon reasonable request
| finalTbl.mat | A data table reflecting the full dataset. Described in detail below. |
| table1Data.mat | Unscaled demographic and lesion size data for the full dataset. |

## Auxiliary files
| Filename | Description |
|---|---|
| predR2.m | Calculates prediction r^2 between actual and predicted values. |
| getAdjustedPreds.m | Takes predictions across kfolds of a fitrsvm procedure and limits them to real-world possibilities. |
| make_LLV.m | A function to generate a lesion load vector given a lesion in 2mm MNI space. Assumes combined_moriFan_2mm.nii.gz is the atlas to which each lesion should be compared.|
| combined_moriFan_2mm.nii.gz | The custom combined atlas (2mm MNI space) generated from Mori et al., 2005 and Fan et al., 2016, used for generating lesion load vectors. |
| combined_moriFan_lbls.txt | A table listing the names (Var2) associated with each value in the atlas (Var1). |
| modelPrep.m | Auxiliary function of MLSM_make_models.m. Creates a table of all data for the appropriate participants given a subscore and timepoint. | 
| makeStageParams.m | Auxiliary function of MLSM_make_models.m. Indicates which predictors should be included for each model (i.e., timepoint, subscore, LLV or LLV+IP) generated. |
| build_mdl_from_predictors.m | Auxiliary function of MLSM_make_models.m. Uses the predictors indicated by makeStageParmas.m to filter the full table generated by modelPrep.m to build a fitrsvm model. | 
| minMaxFun.m | The function used to min-max scale variables for addition to finalTbl.mat |
| make_acuteOverall_predictor.m | The function used to min-max scale the acute overall score predictor for addition to finalTbl.mat. | 
| get_fig5_betas.m | Shows calculation of beta weights displayed in Figure 5 from models. |
| make_table1.mat | Generates summary statistics for the dataset across timepoints as shown in Table 1. |



