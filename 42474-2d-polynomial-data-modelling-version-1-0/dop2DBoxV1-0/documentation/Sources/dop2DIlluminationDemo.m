%% Example of dop2Dbox Applied to Illumination Correction
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
% polynomials to illumination correction in an image.
%
% This tool requires the discrete orthogonal toolbox: dopBox:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/41250
%
%%
close all;
clear;
%
%% Load the Test Data
% \cellName{loadData}
% 
% This is an image of a metallurgical sample taken with a microscope
%
load metallurgy;
%
fig1 = figure;
imagesc( D );
colormap(gray);
axis image;
%
%\caption{Example metallurgical image, note the inhomogeneous illumination}
%
%% Generate the Basis Functions for the X and Y Directions
% \cellName{genBases}
%
% Determine the size of the image
%
[ny, nx] = size( D );
%
% Define the degree of the basis functions for the x and y directions
%
degreeX = 2;
degreeY = 2;
%
% The function call dop uses the number of basis functions not degree
%
noBfsX = degreeX + 1;
noBfsY = degreeY + 1;
%
% Generate the discrete orthogonal basis functions
%
Bx = dop( nx, noBfsX );
By = dop( ny, noBfsY );
%
%% Compute the 2D Polynomial Spectrum
% \cellName{computeSpec}
%
% Only a few basis functions have been used. Consequently the 2D polynomial
% is of low degree. The fit will model the global intensity of the image.
%
Sp = By' * D * Bx;
%
% generate scale vectors for the x and y directions
%
xScale = 0:degreeX;
yScale = 0:degreeY;
%
fig2 = figure;
imagesc( xScale, yScale, Sp );
xlabel('Degree in $$x$$');
ylabel('Degree in $$y$$');
colorbar;
%
% \caption{2D polynomial spectrum}
%
%% Compute the Illumination Approximation
% \cellName{approx}
%
% Reconstructing the 2D data set corresponds to the global illumination
% approximation.
%
Z = By * Sp * Bx';
%
fig3 = figure;
imagesc( Z );
colorbar;
colormap(gray);
%
% \caption{2D Polynomial approximation to the image. The low degree of 
% approximation ensures that the details in the image are not modelled. 
% In this manner the approximation corresponds to the global illumination}
%
%% Correct the Image Intensity
% \cellName{correct}
%
C = D - Z;
%
fig4 = figure;
imagesc( C );
colorbar;
colormap(gray);
%
% \caption{Metallurgical image corrected for the non-uniform illumination.}
