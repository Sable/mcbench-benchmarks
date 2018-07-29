%% Demonstration of 2D Discrete Orthogonal Polynomials for Surfce Modelling
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
% polynomials to surface modelling. This published MATLAB code documents
% only the code implementation, see the corresponding PDF document for the
% theoritial derivations.
%
% This HTML file is a published MATLAB code, the theory behing the code can
% be found in dop2DApproxDemo.pdf.
%
% This tool requires the discrete orthogonal toolbox: dopBox:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/41250
%
%%
close all;
clear;
publishFigureFormat;
%% Example 1: Surface Modelling
%
% \cellName{dataSet}
% Load the test data
% 
load test3dData;
%% View the Original Data as an Image
% Present the original data.
% 
fig1 = figure;
imagesc( xScale, yScale, D );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colorbar;
%
%\caption{Measurement of the 3D geometry of a copper plate from an electrolysis plant. The elevation is in millimeters.}
%
%% View the Data as a Surface
%
% \cellName{OriginalSurf}
%
[X,Y] = meshgrid( xScale, yScale );
%
fig5 = figure;
surf( X, Y, D, 'EdgeColor', 'none', 'Facelighting', 'phong');
axis equal;
set(gca,'DataAspectRatio',[5 5 1]);
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
material shiny;
camlight headlight;
%\caption{Measurement of the 3D geometry of a copper plate from an electrolysis plant. The elevation is in millimeters, 
% whereby the aspect ration in the z direction has been magnified by a factor 5.}
%
%% Compute the 2D Spectrum and Approximation
%
% \cellName{compute}
%
% Define the degree of approximation in x and y.
%
degreeX = 15;
degreeY = 3;
%
nrBfsX = degreeX + 1;
nrBfsY = degreeY + 1;
% 
% compute the 2D polynomial approximatuion.
%
[Z, S] = dop2DApprox( D, nrBfsX, nrBfsY );
%
%% Show the 2D Approximation
%
% \cellName{approxFigure}
% Present the 2D polynomial approximation
%
fig2 = figure;
a(1) = subplot(2,1,1);
imagesc( xScale, yScale, D );
axis image;
ylabel('y [mm]');
colorbar;
%
a(2) = subplot(2,1,2);
imagesc( xScale, yScale, Z );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colorbar;
%
linkaxes( a, 'xy');
%
%\caption{Top: Original data. Bottom: 2D Polynomial approximation to the surface.}
%
%% Prepare the Spectrum for Presentation
%
% Define the scales for the x and y directions in the 2D spectrum
%
specX = 0:(nrBfsX-1);
specY = 0:(nrBfsY-1);
%
% Remove the S(1,1) value, this corresponds to the mean value o fthe image
% and is irrelevant for the structure of the data.
%
S(1,1) = 0;
%
%% 2D Polynomials Spectrum
%
% \cellName{polySpec}
%
% Present the 2D polynomial spectrum.
%
fig3 = figure;
imagesc( specX, specY, S );
xlabel('Polynomial degree in x');
ylabel('Polynomial degree in y');
colorbar;
%\caption{2D Polynomial spectrum.}
%
%% Presente the Surface Anomalies 
%
%\cellName{anomalies}
%
% Compute the difference between the 2D approximation and the original
% suface.
%
L = D - Z;
%
fig4 = figure;
subplot(2,1,1);
imagesc( xScale, yScale, Z );
axis image;
ylabel('y [mm]');
colorbar;
%
subplot(2,1,2);
imagesc( xScale, yScale, L );
axis image;
xlabel('x [mm]');
ylabel('y [mm]');
colorbar;
%\caption{Top: Global polynomial surface model $\M{Z}$, Bottom: Local surface 
% anomalies, i.e., the difference between the 2D polynomial surface model and the original data.}
%
%% Global Surface Model
% 
% The model data D is modelled as a gloabel smooth surface Z pule a set of
% local anomalies L, i.e.
%
% $$D = Z + L$$
%
% The global surface model Z is obtained by approximation the surface data
% D with a low degree tensor polynomial. In the following two images both
% the Z and L surfaces are presented.
%
[X,Y] = meshgrid( xScale, yScale );
%
fig5 = figure;
surf( X, Y, Z, 'EdgeColor', 'none', 'Facelighting', 'phong');
axis equal;
set(gca,'DataAspectRatio',[5 5 1]);
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
material shiny;
camlight headlight;
title('Global Surface Model');
%
%% Local Surface Anomalies
%
% This figure shown the local surface anomalies
%
[X,Y] = meshgrid( xScale, yScale );
%
fig5 = figure;
surf( X, Y, L, 'EdgeColor', 'none', 'Facelighting', 'phong');
axis equal;
set(gca,'DataAspectRatio',[5 5 1]);
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
material shiny;
camlight headlight;
title('Local Aurface Anomalies');
%
%% Example 2: High Degree Approximations
%
% This example shows the possability of performing high degree polynomial
% approcximation using the DOP library. The data used comes form the
% measurement of a metallic surface with imbossed digits.
%
% The task is to remove the background surface structure so that the digits
% and embossed code can be identified with higher reliability.
%
% \cellName{digitsOnMetal}
%
load digitsOnMetal;
%
figH1 = figure;
imagesc( D );
%
% \caption{Surface data for a metal part with imbodded digits and code.}
%
%% High Degree Fit
%
% \cellName{digitsOnMetal2}
%
degreeX = 125;
degreeY = 5;
%
nrBfsX = degreeX + 1;
nrBfsY = degreeY + 1;
% 
% compute the 2D polynomial approximatuion.
%
[Z, S] = dop2DApprox( D, nrBfsX, nrBfsY );
%
T = D - Z ;
%
figH2 = figure;
imagesc( T);
%
% \caption{Surface data for a metal part with embossed digits and code, 
% after elimination of a surface approximation of degree $ d_x = 125 $ 
% and $ d_y = 5 $.}
%% Perform Local Smoothing
%
% \cellName{localSmoothing}
%
% Now a local polynomial approximation is used to smooth the surface
% approximation.
%
lsX = 15;
dx = 3;
%
lsY = 15;
dy = 3;
%
Ts = dop2DApproxLocal( T,  lsX, dx, lsY, dy );
%
figH3 = figure;
imagesc( Ts);
%
% \caption{Surface data for a metal part with embossed digits and code, 
% after elimination of a surface approximation of degree $ d_x = 125 $ 
% and $ d_y = 5 $. local polynomial smoothing has been applied.}
%%
%


