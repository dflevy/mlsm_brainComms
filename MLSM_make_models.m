%% loads subject information

load('finalTbl.mat'); % loading this in defines the variable  "tbl"; full dataset including transformed variables (see README for details)
% age = minMaxFun(table1Data.age), edu = minMaxFun(table1Data.edu), acuteOverall = make_acuteOverall_predictor(table1Data.acuteOverall), each lesSize = sum(subLes(:)) * 8 / 1000, each LLV comes from make_LLV(subLes)

tps={'acute','oneMo','threeMo','twelveMo'};
lbls=tbl.Properties.VariableNames(endsWith(tbl.Properties.VariableNames,'_l','IgnoreCase',true) | endsWith(tbl.Properties.VariableNames,'_b','IgnoreCase',true));
subscores={'QAB overall', 'Word comp', 'Sentence comp', 'Word finding', 'Gram constr', 'Speech mot prog', 'Speech mot exec', 'Reading','Repetition'};
subscores=lower(strrep(subscores,' ','-'));

%% makes and saves all models

topSaveDir='mdls_012124';
if ~exist(topSaveDir,'dir')
    mkdir(topSaveDir);
end

stageParams=make_stage_params;
useAcuteParams=[false,true];
numStages=3;

allNs=nan(length(subscores),length(tps),numStages,length(useAcuteParams));
allR2s=allNs;
allRMSEs=allNs;

for m=1:length(useAcuteParams)

    useAcuteScore=useAcuteParams(m);

    for tp=1:length(tps)

        for ss=1:length(subscores)

            ssName=subscores{ss};

            % scores marked as -2 (untestable) are imputed to 0 only when
            % predicting QAB overall
            if ss==1
                useNegs=true;
            else
                useNegs=false;
            end

            tpName=tps{tp};
            [modelTbl]=modelPrep(tbl,ss,tpName,useAcuteScore,useNegs,lbls);

            for st=1:numStages

                bottomSaveDir=sprintf('%s/model%d/stage%d',topSaveDir,m,st);
                if ~exist(bottomSaveDir,'dir'); mkdir(bottomSaveDir); end

                if useAcuteScore
                    predictors=stageParams.predictors_useAcute{st};
                else
                    predictors=stageParams.predictors_noUseAcute{st};
                end

                mdl=build_mdl_from_predictors(predictors,modelTbl);

                save(sprintf('%s/%s_%s.mat',bottomSaveDir,tps{tp},ssName),'mdl');

                actuals=mdl.Y;
                newPreds=get_adjusted_preds(mdl);

                N=size(newPreds,1);

                r2=predR2(mdl.Y,newPreds);

                RMSE=sqrt((sum((mdl.Y-newPreds).^2))/N);

                % if this is the LLV+IP model (which uses acute scores in
                % predictors), exclude from stats to avoid
                % inflated metrics of accuracy
                if m==2 && tp==1
                    allNs(ss,tp,st,m)=nan;
                    allR2s(ss,tp,st,m)=nan;
                    allRMSEs(ss,tp,st,m)=nan;
                else
                    allNs(ss,tp,st,m)=N;
                    allR2s(ss,tp,st,m)=r2;
                    allRMSEs(ss,tp,st,m)=RMSE;
                end

            end

        end

    end

end

LLV_full_metrics=allR2s(:,:,3,1); % fig 3 scatters
LLVIP_full_metrics=allR2s(:,:,3,2); % fig 4 scatters

