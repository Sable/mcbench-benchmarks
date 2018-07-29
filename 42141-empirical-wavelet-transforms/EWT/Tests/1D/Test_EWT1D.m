%% Script to test the Empirical Wavelet Transform
% It generates all the results given in the paper
% J. Gilles, "Empirical Wavelet Transform", IEEE
% Trans. on Signal Processing, 2013
%
% Don't hesitate to modify the parameters and try
% your own signals!
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
clear all

%% User setup

% Choose the signal you want to analyze
% (sig1,sig2,sig3,sig4=ECG,sig5=seismic)
signal = 'sig2';

% Choose the wanted preprocessing (none,plaw,poly,morpho,tophat)
params.preproc = 'none';
params.degree=5; % degree for the polynomial interpolation

% Choose the wanted detection method (locmax,locmaxmin,ftc)
params.method = 'locmaxmin';
params.N = 6; % maximum number of band for the locmaxmin method (default 
              % value, it is adjusted for each signal below
params.completion = 0; % choose if you want to force to have params.N modes
                       % in case the algorithm found less ones (0 or 1)

% Perform the detection on the log spectrum instead the spectrum
params.log=0;

% Choose the results you want to display (Show=1, Not Show=0)
Bound=0;   % Display the detected boundaries on the spectrum
Comp=1;    % Display the EWT components
Rec=1;     % Display the reconstructed signal
TFplane=0; % Display the time-frequency plane (by using the Hilbert 
           % transform: YOU NEED TO HAVE FLANDRIN'S EMD TOOLBOX)
Demd=0;    % Display the Hilbert-Huang transform (YOU ALSO NEED
           % TO HAVE FLANDRIN'S EMD TOOLBOX)

switch lower(signal)
    case 'sig1'
        load('sig1.mat');
        t=0:1/length(f):1-1/length(f);
        params.N=2;
    case 'sig2'
        load('sig2.mat');
        t=0:1/length(f):1-1/length(f);
        params.N=3;
    case 'sig3'
        load('sig3.mat');
        t=0:1/length(f):1-1/length(f);
        params.N=2;
    case 'sig4'
        load('sig4.mat');
        t=0:length(f)-1;
        params.N=5;
    case 'sig5'
        load('seismic.mat');
        f=f(10000:20000); %sub portion of the signal used in the paper
        t=0:length(f)-1;
        params.N=30;
end


%% We perform the empirical transform and its inverse
% compute the EWT (and get the corresponding filter bank and list of 
% boundaries)
%[ewt,mfb,boundaries,BO,BN]=EWT1D(f,Nbscales,detect,0,params);
[ewt,mfb,boundaries]=EWT1D(f,params);


%% Show the results

if Bound==1 %Show the boundaries on the spectrum
    Show_EWT_Boundaries(abs(fft(f)),boundaries,10);
end

if Comp==1 %Show the EWT components and the reconstructed signal
    if Rec==1
        %compute the reconstruction
        rec=iEWT1D(ewt,mfb);
        Show_EWT(ewt,f,rec);
    else
        Show_EWT(ewt);
    end    
end

if TFplane==1 %Show the time-frequency plane by using the Hilbert transform
    Hilbert_EWT(ewt,t,f,1,1);
end

%% EMD comparison: if you have Patrick Flandrin's EMD toolbox you can 
%% uncomment the following line to perform the EMD and display the corresponding 
%% Time-Frequency plane

%TEST EMD Flandrin
if Demd==1
    imf=emd(f);
    Disp_HHT(imf,t,f,1,1);
end

