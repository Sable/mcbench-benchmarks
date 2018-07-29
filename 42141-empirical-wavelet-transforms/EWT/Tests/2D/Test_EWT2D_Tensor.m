%% This script permits to test the 2D tensor EWT
% It generates all the results given in the papers
% J. Gilles, "Empirical Wavelet Transform", IEEE
% Trans. on Signal Processing, 2013
% J. Gilles, G. Tran, S. Osher, "2D Empirical tranforms. Wavelets, 
% Ridgelets and Curvelets Revisited" submitted at SIAM Journal on
% Imaging Sciences. 2013
%
% Don't hesitate to modify the parameters and try
% your own images!
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
clear all

%% User setup
% Choose the image you want to analyze (texture,lena,barb)
signal = 'barb';

% Choose the wanted preprocessing (none,plaw,poly,morpho,tophat)
params.preproc = 'morpho';
params.degree=5; % degree for the polynomial interpolation


% Choose the wanted detection method (locmax,locmaxmin,ftc)
params.method = 'locmaxmin';
params.N = 4; % maximum number of band for the locmaxmin method
params.completion=0;

% Perform the detection on the log spectrum instead the spectrum
params.log=1;

% Choose the results you want to display (Show=1, Not Show=0)
Bound=1;   % Display the detected boundaries on the spectrum
Comp=1;    % Display the EWT components
Rec=0;     % Display the reconstructed signal
           
switch lower(signal)
    case 'texture'
        load('texture.mat');
    case 'lena'
        load('lena.mat');
    case 'barb'
        load('barb.mat');
end

%% We perform the 2D Tensor EWT
[ewtc,mfbR,mfbC,BR,BC]=EWT2D_Tensor(f,params);

%% Show results
if Comp==1
   Show_EWT2D_Tensor(ewtc);
end

if Rec==1
   rec=iEWT2D_Tensor(ewtc,mfbR,mfbC);
   figure;imshow(rec,[]); 
end

if Bound==1
   Tensor_Plot_Boundaries(f,BR,BC);
end