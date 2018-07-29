%
% generate a figure for a cantilever
%
close all;
clear all;
%
setUpGraphics;
%
%
setUpGraphics(10)
FigureSize=[1 1 10 6];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.14 0.17 0.8 0.8];
set(0,'DefaultaxesPosition',MyAxesPosition);
%
fig1 = figure;
A = axes('position',[0.01,0.01,0.98,0.98]);
w = 1;
h = 0.05;
%
plot( [-w, w, w, -w, -w], [-h, -h, h, h, -h], 'k');
hold on
%
at = -1;
w2 = 0.03;
h2 = 0.2;
%
patch( [-w2, w2, w2, -w2, -w2] + at, [-h2, -h2, h2, h2, -h2], 'k');
%
at = 0.6;
w3 = 0.05;
h3 = 0.1;
patch( [-w3,w3,0] + at, [0, 0, h3] - (h3+h), 'k');
%
axis equal;
%
text( -0.9, 0.12, '$$\dot{y}(0) = 0$$');
text( -0.9, -0.12, '$${y}(0) = 0$$');
text( 0.7, -0.12, '$$\ddot{y}(1) = 0$$');
text( 0.7, 0.12, '$${y}^{\cdot \cdot \cdot}(1) = 0$$');
text( 0.2, -0.12, '$${y}(0.8) = 0$$');
axis off;
%
fileType = 'eps';

printFigure( fig1, 'cantileverWithSuppFig', fileType);