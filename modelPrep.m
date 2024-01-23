function [modelTbl]=modelPrep(tbl,ss,tpName,useAcuteScore,useNegs,lbls)
% returns the table to be used by fitrsvm
% tbl = full table of data including appropriately min-max scaled values and LLVs as in finalTbl.mat
% ss = index of subscore you want in the relevant timepoint of the table 
% tpName = column name in table corresponding to timepoint of interest
% useAcuteScore = true if you want acute overall score in the predictors (if LLV model, useAcuteScore == false, if LLV+IP model, useAcuteScore == true)
% useNegs = true if you want to treat untestable scores as zeros (only true if predicting QAB overall)
% lbls = names of ROIs in LLV

thisData=tbl{:,tpName}(:,ss); % extract data from this timepoint and subscore

badNaN=(isnan(thisData)|thisData==-1); % find places where data is not usable due to missingness
badUntestable=thisData==-2; % find places where data is not usable due to untestability

if useNegs % if we want to make untestables zeros, do so
    toTakeOut=(badNaN);
    tbl{badUntestable,tpName}(:,ss)=0;
    thisData(badUntestable)=0;
else % otherwise, together these are invalid data points to be removed
    toTakeOut=(badNaN|badUntestable);
end

if useAcuteScore

    acuteInd=strcmp(tbl.Properties.VariableNames,'acuteOverall');
    acuteData=tbl{:,acuteInd}; % just overall now

    acBadUntestable=acuteData==-2; % find places where acute data is not usable due to untestability

    acuteData(acBadUntestable)=0;

    acData=acuteData(~toTakeOut,:); % remove things to take out from the acute scores

end

lesSizeMdl=tbl.lesSize;

ROImdl=tbl{:,lbls};

tempTbl=tbl(~toTakeOut,:); % take bad ones out of the feature table
outData=thisData(~toTakeOut,:); % the response data
lesSizeMdl=lesSizeMdl(~toTakeOut,:); % the lesion size info
ROImdl=ROImdl(~toTakeOut,:); % and the ROI vector info

% combine all vars
modelTbl=tempTbl(:,ismember(tempTbl.Properties.VariableNames,{'pid','handLA','edu','age','sexF','isHem'}));
modelTbl=addvars(modelTbl,lesSizeMdl,'NewVariableNames',{'lesSize'});
modelTbl=[modelTbl array2table(ROImdl,'VariableNames',lbls)];

if useAcuteScore
    modelTbl=addvars(modelTbl,acData,'NewVariableNames',{'acuteOverall'},'After','lesSize');
end

% check if they're missing for anybody
finalBadInds=any(ismissing(modelTbl),2);

% if so, remove them from both the feature table
modelTbl=modelTbl(~finalBadInds,:);
outData=outData(~finalBadInds,:); % and the response data

% now add in data to predict - this is your final table for fitrsvm
modelTbl=addvars(modelTbl,outData,'NewVariableNames','scoresToPredict');

end