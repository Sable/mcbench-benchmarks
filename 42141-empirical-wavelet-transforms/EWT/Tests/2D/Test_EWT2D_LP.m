%% This script permits to test the 2D Littlewood-Paley EWT
% It generates all the results given in the paper
% J. Gilles, G. Tran, S. Osher, "2D Empirical tranforms. Wavelets, 
% Ridgelets and Curvelets Revisited" submitted at SIAM Journal on
% Imaging Sciences. 2013
%
% Don't hesitate to modify the parameters and try
% your own images!
%
% Author: Jerome Gilles - Giang Tran
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
params.N = 6; % maximum number of band for the locmaxmin method
params.completion = 0;

% Perform the detection on the log spectrum instead the spectrum itself
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

%% We perform the 2D Littlewood-Paley EWT
[ewtc,mfb,boundaries]=EWT2D_LittlewoodPaley(f,params);

%% Show results
if Comp==1
   Show_EWT2D(ewtc);
end

if Rec==1
   rec=iEWT2D_LittlewoodPaley(ewtc,mfb);
   figure;imshow(rec,[]); 
end

if Bound==1
   LP_boundaries(f,boundaries)
end