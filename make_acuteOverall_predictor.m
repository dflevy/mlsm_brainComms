function [acPredictor]=make_acuteOverall_predictor(acuteOverallScores)

acPredictor=acuteOverallScores;
isNeg=acPredictor<0;
acPredictor(isNeg)=0;
acPredictor=rescale(acPredictor,'InputMin',0,'InputMax',10);
acPredictor(isNeg)=-2;