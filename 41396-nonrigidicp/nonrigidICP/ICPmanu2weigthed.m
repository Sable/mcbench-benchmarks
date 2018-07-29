function [error,Reallignedsource,transform]=ICPmanu2weigthed(target,source,d2)

% This function rotates, translates and scales a 3D pointcloud "source" of N*3 size (N points in N rows, 3 collumns for XYZ)
% to fit a similar shaped point cloud "target" again of N by 3 size with a
% specifc weigth given to a surface are on the source mesh defined by d2
% 
% The output shows the minimized value of dissimilarity measure in "error", the transformed source data set and the 
% transformation, rotation, scaling and translation in transform.T, transform.b and transform.c such that
% Reallignedsource = b*source*T + c;

index=1;
[errortemp(index,:),Reallignedsourcetemp,transform]=ICPmanu_allignweigthed(target,source,d2);
d=errortemp(index,:);

[errortemp(index+1,:),Reallignedsourcetemp,transform]=ICPmanu_allignweigthed(target,Reallignedsourcetemp,d2);
index=index+1;
d=errortemp(index,:);

while ((errortemp(index-1,:)-errortemp(index,:)))>0.0000001
[errortemp(index+1,:),Reallignedsourcetemp,transform]=ICPmanu_allignweigthed(target,Reallignedsourcetemp,d2);
index=index+1;
d=errortemp(index,:);

end

error=errortemp(index,:);
[d,Reallignedsource,transform] = procrustes(Reallignedsourcetemp,source);



