% There are two subsequent 3-D images in the testdata.
clear; clc;
load testdataHS3D.mat;
[ux,uy,uz]=HS3D(img1,img2,150,1);
% Enhance the quiver plot visually by downsizing vectors  
%   -f : downsizing factor
f=5;
x=ux(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 
y=uy(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 
z=uz(1:f:size(ux,1),1:f:size(ux,2),1:f:size(ux,3)); 

[X,Y,Z]=meshgrid(1:size(x,2),1:size(x,1),1:size(x,3));
figure;
quiver3(X,Y,Z,x,y,z,0); axis([1 size(x,2) 1 size(x,1) 1 size(x,3)]);


