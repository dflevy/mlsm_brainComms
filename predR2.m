function r2=predR2(actual,predicted)
% prediction r2 as defined by Alexander et al., 2015

r2=1-sum((actual-predicted).^2)/sum((actual-mean(actual)).^2);

end