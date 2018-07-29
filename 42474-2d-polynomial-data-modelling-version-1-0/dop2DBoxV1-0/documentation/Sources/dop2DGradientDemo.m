%% 2D Regularized and Non-Regularized Gradients
%
% (C) 2013 Matthew harker and Paul O'Leary
% Institute for Automation
% University of Leoben
% A-8700 Leoben
% Austria
%
% email: office@harkeroleary.org
%
% This program demonstrates the application of discrete orthogonal
% polynomials to computing regularized and non-regularized gradients.
%
% This HTML file is a published MATLAB code, the theory behing the code can
% be found in dop2DGradientDemo.pdf.
%
% This tool requires the discrete orthogonal toolbox: dopBox:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/41250
%
%%
close all;
clear;
%
%% Load the Test Data Set
% \cellName{dataSet}
% 
% This is a data set originating from the inspection of copper plates in an
% electrolysis plant.
% 
load test3dData;
%
%% Compute the Gradient
% \cellName{gradients}
%
% The support length |lsX| and the number of basis functions |nbX| are
% selected to be equal. This ensures that no regularization is applied
% during computation of the gradient.
%
lsX = 3;
nbX = lsX;
dx = xScale(2) - xScale(1);
%
lsY = 3;
nbY = lsY;
dy = yScale(2) - yScale(1);
%
% Compute the gradient using loacl polynomial methods
%
[gX, gY, gT] = dop2DGradient( D, lsX, nbX, lsY, nbY, dx, dy) ;
%
%% Compute the Regularized Gradient
%\cellName{regGradients}
%
% Here the support length is significantly larger than the number of basis
% functions. This implements local polynomial approximation as a means of
% generating a regularization.
%
lsX = 11;
nbX = 3;
dx = xScale(2) - xScale(1);
%
lsY = 7;
nbY = 3;
dy = yScale(2) - yScale(1);
%
% Compute the gradient using loack polynomial methods
%
[gXr, gYr, gTr] = dop2DGradient( D, lsX, nbX, lsY, nbY, dx, dy) ;
%% Normalize the Gradient to Make them Comparable
%
% Normalize the gradients to make them easier to present
%
mingT = min( gT(:));
maxgT = max( gT(:));
gT = ( gT - mingT)/(maxgT - mingT);
%
mingTr = min( gTr(:));
maxgTr = max( gTr(:));
gTr = ( gTr - mingTr)/(maxgTr - mingTr);
%
%% View the Original Data
% \cellName{originalData}
%
fig1 = figure;
imagesc( xScale, yScale, D );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colorbar;
%
% \caption{Original data.}
%% View the Gradients
% \cellName{visual}
%
fig1 = figure;
b(1) = subplot(2,1,1);
imagesc( xScale, yScale,(1 - gT)  );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colorbar;
%
b(2) = subplot(2,1,2);
imagesc( xScale, yScale, (1 - gTr) );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colormap(gray)
colorbar;
linkaxes( b, 'xy');
%
% \caption{Top: gradient without regularization. Bottom: Gradient with 
% regularization, different regularization degrees are used in the 
% $x$ and $y$ directions.}
%%