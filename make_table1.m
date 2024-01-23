load('table1Data.mat'); % full dataset patient demographic / initial presentation / lesion size information 
% full dataset as input to models including all observed subscores at each timepoint (relevant for separating data into different timepoints)
load('finalTbl.mat'); 

% sanity check
unique(table1Data.pid==tbl.pid);

% get relevant patients at each time point
tbl1Data{1}=table1Data;
tbl1Data{2}=table1Data(~isnan(tbl.oneMo(:,1)),:);
tbl1Data{3}=table1Data(~isnan(tbl.threeMo(:,1)),:);
tbl1Data{4}=table1Data(~isnan(tbl.twelveMo(:,1)),:);

newTbl=table;
for tp=1:4

    meanAge=mean(tbl1Data{tp}{:,'age'});
    stdAge=std(tbl1Data{tp}{:,'age'});
    minAge=min(tbl1Data{tp}{:,'age'});
    maxAge=max(tbl1Data{tp}{:,'age'});

    meanEdu=mean(tbl1Data{tp}{:,'edu'});
    stdEdu=std(tbl1Data{tp}{:,'edu'});
    minEdu=min(tbl1Data{tp}{:,'edu'});
    maxEdu=max(tbl1Data{tp}{:,'edu'});

    isFemale=sum(tbl1Data{tp}{:,'sexF'});
    isMale=sum(~tbl1Data{tp}{:,'sexF'});

    isA=sum(tbl1Data{tp}{:,'handLA'}==3);
    isL=sum(tbl1Data{tp}{:,'handLA'}==2);
    isR=sum(tbl1Data{tp}{:,'handLA'}==1);

    isHem=sum(tbl1Data{tp}{:,'isHem'});
    isIsch=sum(~tbl1Data{tp}{:,'isHem'});

    meanLesExt=mean(tbl1Data{tp}{:,'lesSize'});
    stdLesExt=std(tbl1Data{tp}{:,'lesSize'});
    minLesExt=min(tbl1Data{tp}{:,'lesSize'});
    maxLesExt=max(tbl1Data{tp}{:,'lesSize'});

    allOverall=tbl1Data{tp}{:,'acuteOverall'};
    meanAcute=mean(allOverall(allOverall>=0));
    stdAcute=std(allOverall(allOverall>=0));
    minAcute=min(allOverall(allOverall>=0));
    maxAcute=max(allOverall(allOverall>=0));

    newTbl=[newTbl;table([meanAge,stdAge,minAge,maxAge],[meanEdu,stdEdu,minEdu,maxEdu],[isMale,isFemale],[isR,isL,isA],[isIsch,isHem],[meanLesExt,stdLesExt,minLesExt,maxLesExt],[meanAcute,stdAcute,minAcute,maxAcute], ...
        'VariableNames',{'age','edu','sex','hand','strType','lesExt','acuteOverall'})];

end