function FDAU=FDA(ftrs,gnd)
%Fisher’s discriminant analysis (FDA) 

[ftrDim,numSpl]=size(ftrs);
ftrmean=mean(ftrs,2);
numCls=length(unique(gnd));

SB = zeros(ftrDim);
for i = 1:numCls
    idxs=find(gnd==i);
    clsFtrs=ftrs(:,idxs);
    clsMean=mean(clsFtrs,2)-ftrmean;
    SB = SB + length(idxs)*clsMean*clsMean';
end   
SW = ftrs*ftrs' - SB;
if rank(SW)<ftrDim %regularization for singular SW
    SW=SW+1e-6*eye(ftrDim); 
end
option=struct('disp',0);
[FDAU, FDAV] = eigs(inv(SW)*SB,numCls-1,'lm',option);


