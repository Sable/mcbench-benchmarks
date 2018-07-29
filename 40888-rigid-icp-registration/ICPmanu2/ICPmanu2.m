function [error,Reallignedsource,transform]=ICPmanu2(target,source)

% This function rotates, translates and scales a 3D pointcloud "source" of N*3 size (N points in N rows, 3 collumns for XYZ)
% to fit a similar shaped point cloud "target" again of N by 3 size
% 
% The output shows the minimized value of dissimilarity measure in "error", the transformed source data set and the 
% transformation, rotation, scaling and translation in transform.T, transform.b and transform.c such that
% Reallignedsource = b*source*T + c;

%EXAMPLE

% load EXAMPLE
% [error,Reallignedsource,transform]=ICPmanu2(target,source);
% trisurf(ftarget,target(:,1),target(:,2),target(:,3),'facecolor','y','Edgecolor','none');
% hold
% light
% lighting phong;
% set(gca, 'visible', 'off')
% set(gcf,'Color',[1 1 0.88])
% view(90,90)
% set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
% trisurf(fsource,source(:,1),source(:,2),source(:,3),'facecolor','m','Edgecolor','none');
% trisurf(fsource,Reallignedsource(:,1),Reallignedsource(:,2),Reallignedsource(:,3),'facecolor','b','Edgecolor','none');


[Prealligned_source,Prealligned_target,transformtarget ]=Preall(target,source);



index=1;
[errortemp(index,:),Reallignedsourcetemp]=ICPmanu_allign2(Prealligned_target,Prealligned_source);
display ('error')
d=errortemp(index,:)

[errortemp(index+1,:),Reallignedsourcetemp]=ICPmanu_allign2(Prealligned_target,Reallignedsourcetemp);
index=index+1;
d=errortemp(index,:)

while ((errortemp(index-1,:)-errortemp(index,:)))>0.000001
[errortemp(index+1,:),Reallignedsourcetemp]=ICPmanu_allign2(Prealligned_target,Reallignedsourcetemp);
index=index+1;
d=errortemp(index,:)

end

error=errortemp(index,:);
Reallignedsource=Reallignedsourcetemp*transformtarget.T+repmat(transformtarget.c(1,1:3),length(Reallignedsourcetemp(:,1)),1);
[d,Reallignedsource,transform] = procrustes(Reallignedsource,source);

