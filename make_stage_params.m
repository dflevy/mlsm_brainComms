function stageParams=make_stage_params
% returns a 2-column table of cell arrays defining what predictors are used in different models 
% predictors_noUseAcute = LLV model, predictors_useAcute = LLV+IP model
% row 1 = demographics only, row 2 = demographics + lesion size; row 3 = full model including LLVs
% uses finalTbl.mat to get labels for LLVs

stageTbl=load('finalTbl.mat');
ROIlbls=stageTbl.tbl.Properties.VariableNames(endsWith(stageTbl.tbl.Properties.VariableNames,'_l','IgnoreCase',true) | endsWith(stageTbl.tbl.Properties.VariableNames,'_b','IgnoreCase',true));

stageParams=table;

predictors_noUseAcute={{'handLA','edu','age','sexF','isHem'}; ...
    {'handLA','edu','age','sexF','isHem','lesSize'}; ...
    [{'handLA','edu','age','sexF','isHem','lesSize'},ROIlbls]};

predictors_useAcute=cellfun(@(x) [x 'acuteOverall'],predictors_noUseAcute,'UniformOutput',false);

stageParams=addvars(stageParams,predictors_noUseAcute,predictors_useAcute,'NewVariableNames',{'predictors_noUseAcute','predictors_useAcute'});

clear stageTbl;