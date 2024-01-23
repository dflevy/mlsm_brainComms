function [newPreds]=get_adjusted_preds(mdl)
% adjusts output of fitrsvm mdl to real-world range (0-10)

origPreds=kfoldPredict(mdl);
newPreds=origPreds;

newPreds(origPreds>10)=10; % a prediction over 10 would never make sense
newPreds(origPreds<0)=0; % a prediction less than 0 would never make sense

end