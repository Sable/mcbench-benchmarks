function [error,Reallignedsource]=ICPmanu_allign2(target,source)

IDX1=knnsearch(target,source);
IDX2=knnsearch(source,target);

Datasetsource=vertcat(source,source(IDX2,:));
Datasettarget=vertcat(target(IDX1,:),target);

[error,Reallignedsource] = procrustes(Datasettarget,Datasetsource);
Reallignedsource=Reallignedsource(1:length(source(:,1)),:);