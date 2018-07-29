%% Demonstration of the 2D Discrete Gram Transformation
%
% (C) 2013 Matthew harker and Paul O'Leary
% Institute for Automation
% University of Leoben
% A-8700 Leoben
% Austria
%
% email: office@harkeroleary.org
%
% This file produces a demonstration of the 2D discrete gram polynomial
% transformation of an image and the corresponding inverse transformation.
% It used the function |dgt| to compute the discrete Gram transformation
% and the function |idgt| to compute the inverse transformation.
%
% It is also demonstarted that the error in the reconstrcuted image ins
% negligible, i.e., approaching the numerical accuracy available in MATLAB.
% This demonstrates that the polynomial basis functions are free from error
% evant at very high degrees in this example d = 1024.
%
% This tool requires the discrete orthogonal toolbox: dopBox:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/41250
%
%%
close all;
clear all;
%
% Set some defaults
%
FontSize = 12;
set(0,'DefaultaxesFontName','Times');
set(0,'DefaultaxesFontSize',FontSize);
set(0,'DefaulttextFontName','Times');
set(0,'DefaulttextFontSize',FontSize);
set(0,'DefaultTextInterpreter', 'latex');
%
%% Load an image and convert to a double gray data set
%
% This is an image of an art object. The snails are modelled in modelling
% material, they are not real animals.
%
[pic, map] = imread('snails1.jpg');
%
% Make the data mean free so that the spectrum is better viwible
%
D = double( rgb2gray( pic ));
D = D - mean(D(:));
%% View the Test Image
%
% View the image
%
fig1 = figure;
imagesc( pic );
axis image;
%
title('Photo Finish ($$\copyright$$ 2012 Paul O''Leary and Wolfgang Trettnak)');
xlabel('These are artificial snails and not real animals');
%
%% Compute the Gram Spectrum
%
% Call the |dgt2| function to compute the two dimensional Gram polynomial
% transformation. This is akin to the fft2 for the Fourier basis.
%
[S, Bx, By] = dgt2( D );
%
[ny,nx] = size( S );
%
% Compute the degrees in x and y directions.
%
xScale = 0:(nx-1);
yScale = 0:(ny-1);
%% View the 2D Polynomial Spectrum
%
% This is the complete 2D spectrum for the complete image.
%
fig2 = figure;
imagesc( xScale, yScale, S );
axis image;
colorbar
title('2D Gram Spectrum (information is at lower degrees)');
xlabel('Polynomial degree in $$x$$');
ylabel('Polynomial degree in $$y$$');
%
%% Zoomed Section of Spectrum
%
% Virtually all of the Information of the test image is concentrated at
% lower degrees. This can be shown by zooming in on the relevant portion
% of the spectrum.
%
fig3 = figure;
imagesc( xScale, yScale, S);
axis image;
colorbar
title('2D Gram Spectrum');
xlabel('Polynomial degree in $$x$$');
ylabel('Polynomial degree in $$y$$');
axis([0,20,0,20]);
%
%
%% Reconstruct the Image and Test for Errors
%
% The aim here is to reconstruct the image from its spectrum and then to
% compute a norm for the total error. This gives a measure for the quality
% of the transform inverse-transform pair.
%
% Note: the basis functions computed for the transform are passed to the
% inverse transform. this avoids the necessity to recompute the polynomial
% basis functions.
%
% As can be seen in the final figure, the Frobeneus norm of the error is in
% the order of $10^{-15}$, consequently, the polynomial transformation can
% be regarded as free from error.
%
Dr = idgt2( S, Bx, By );
%
% Calculate the difference between the original gray scale image and its
% reconstruction.
%
E = D - Dr;
%
% Compute the ratio of the Frobenius of the error to the norm of the data. 
%
normE = norm( E, 'fro');
normD = norm( D, 'fro');
normEtoD = normE / normD;
%
%% View the Reconstructed Image.
%
fig3 = figure;
imagesc( Dr );
axis image;
colormap gray;
axis off;
title(['Reconstructed Gray Image ($$ \epsilon = ',num2str(normEtoD),' $$)']);
xlabel('These are artificial snails and not real animals');
