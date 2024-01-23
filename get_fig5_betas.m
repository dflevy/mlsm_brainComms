load(sprintf('mdls_012124/model1/stage3/twelveMo_qab-overall.mat')); % load relevant model

fullMdl=fitrsvm(mdl.X,mdl.Y,'PredictorNames',mdl.PredictorNames); % use that model to run with all data (no LOO-CV)

% look only at LLV predictors
roiPreds=endsWith(fullMdl.PredictorNames,'_l','IgnoreCase',true) |  endsWith(fullMdl.PredictorNames,'_b','IgnoreCase',true); % mask
roiBetas=fullMdl.Beta(roiPreds); %  get the associated betas
roiLbls=fullMdl.PredictorNames(roiPreds); % and labels

isNeg=roiBetas<0; % limit to negative betas (where positive lesion status is associated with lower score)

% threshold to one standard deviation below the mean
thresh=mean(roiBetas(isNeg))-std(roiBetas(isNeg)); 
threshLbls=roiLbls(roiBetas<thresh); 
threshBetas=roiBetas(roiBetas<thresh);

[val,ord]=sort(threshBetas,'ascend'); % sort these from most extreme negative to least extreme negative

table(val,threshLbls(ord)','VariableNames',{'betaVal','roiLbl'}) % display