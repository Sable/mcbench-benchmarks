%
% This example shows how a triangular mesh can be resampled on a
% "meshgrid"-generated square grid. We illustrate the usage of
% both functions "gridtrimesh" and "mxgridtrimesh". These two should
% produce identical results. Funcion "mxgridtrimesh" is a compiled
% MEX function written in C and should execute quicker than
% "gridtrimesh".
%
%
%   Author:  Willie Brink  [ w.brink@shu.ac.uk ]
%            April 2007



load beethoven   % load MAT file containing F and V that describes a triangular mesh

nx = 120;  % the size of the grid
ny = 120;  % the size of the grid

% create a grid in x and y
x = linspace(min(V(:,1)),max(V(:,1)),nx);
y = linspace(min(V(:,2)),max(V(:,2)),ny);
[X,Y] = meshgrid(x,y);

% find corresponding z-values by means of gridtrimesh.m
fprintf(['gridtrimesh.......']); tic
Z = gridtrimesh(F,V,X,Y);
fprintf([num2str(toc), ' sec','\n']); 

% find corresponding z-values by means of mxgridtrimesh.dll
% NOTE: the MEX file can be recompiled as follows:
%    mex -setup           % choose appropriate C compiler
%    mex mxgridtrimesh.c  % compile the file
fprintf(['mxgridtrimesh.....']); tic
mxZ = mxgridtrimesh(F,V,X,Y);
fprintf([num2str(toc), ' sec','\n']); 


% display original mesh and output from "gridtrimesh"
figure

% surface plot of the original triangular mesh
% (note that the surface is plotted as z,x,y so that xy plane appears to be upright)
h1 = subplot(1,2,1); hold on
trisurf(F,V(:,3),V(:,1),V(:,2),'facecolor',[.9 .8 .6],'edgecolor','k');
axis image, view(125,10), axis vis3d, axis off, zoom(1.5); vv = axis;
camlight headlight
title('input triangular mesh');

% surface plot of the grid data
% (note that the surface is plotted as z,x,y so that xy plane appears to be upright)
h2 = subplot(1,2,2); hold on
surf(Z,X,Y,'facecolor',[.9 .8 .6],'edgecolor','k');
axis image, view(125,10), axis vis3d, axis off, zoom(1.5); axis(vv);
camlight headlight
title(['resampled into ',num2str(nx),' x ',num2str(ny),' grid']);

% link axes properties so that rotation, zooming and panning are performed simultaneously on both axes
linkprop([h1,h2],{'CameraPosition','CameraTarget','CameraUpVector','CameraViewAngle'});
rotate3d on

