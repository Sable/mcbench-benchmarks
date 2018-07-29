function [error,Reallignedsource,transform]=ICPmanu_allignweigthed(target,source,d2)

%function to add progressively weigth to the source mesh to force improved transformation on the specifc surface area defined in d2
IDX1=knnsearch(target,source);
IDX2=knnsearch(source,target);

%weigth is given by repeating similar points with increments from 1 to 25
%depending on the surface distance defined in d2
d2=round(d2*25);
d2(:,2)=1:length(d2(:,1));

IDX2(:,2)=d2(IDX2,1);
IDX2(:,3)=1:length(target(:,1));
Matrixsource1=[];Matrixsource2=[];Matrixtarget2=[];Matrixtarget1=[];


for i=1:25
    tempd2=d2(d2(:,1)==i,2);
    Matrixsource1=vertcat(Matrixsource1,repmat(source(tempd2,:),round(exp((i-1)/12)*i),1));
    Matrixtarget1=vertcat(Matrixtarget1,repmat(target(IDX1(tempd2,:),:),round(exp((i-1)/12)*i),1));

    temp2d2=IDX2(IDX2(:,2)==i,:);
    Matrixsource2=vertcat(Matrixsource2,repmat(source(temp2d2(:,1),:),round(exp((i-1)/12)*i),1));
    Matrixtarget2=vertcat(Matrixtarget2,repmat(target(temp2d2(:,3),:),round(exp((i-1)/12)*i),1));
end

Datasetsource=vertcat(Matrixsource1,Matrixsource2);
Datasettarget=vertcat(Matrixtarget1,Matrixtarget2);

[error,Reallignedsource,transform]=procrustes(Datasettarget,Datasetsource);
Reallignedsource=transform.b*source*transform.T+repmat(transform.c(1,1:3),length(source(:,1)),1);
