% testdata contains two subsequent 3-D images.
clear; clc;
load testdataLKPR3D.mat;
[ux,uy,uz]=LKPR3D(img1,img2,4,2,0,1);

% Enhance the quiver plot visually by downsizing vectors  
%   -f : downsizing factor
f=5;
x=ux(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 
y=uy(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 
z=uz(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 

[X,Y,Z]=meshgrid(1:size(x,2),1:size(x,1),1:size(x,3));
quiver3(X,Y,Z,x,y,z); axis([1 size(x,2) 1 size(x,1) 1 size(x,3)]);


