%% Test of different Fourier boundaries detection strategies

clear all

%% User setup
% Choose the signal you want to analyze
% (sig1,sig2,sig3,sig4=ECG,sig5=seismic,lena,textures)
signal = 'sig4';

% Choose the wanted preprocessing (none,plaw,poly,morpho)
params.preproc = 'none';
params.degree=5; % degree for the polynomial interpolation

% Choose the wanted detection method (locmax,locmaxmin,ftc)
params.method = 'locmaxmin';
params.N = 6; % maximum number of band for the locmaxmin method
params.completion = 0;

% Perform the detection on the log spectrum instead the spectrum
params.log=0;

%% Load signals
switch lower(signal)
    case 'sig1'
        load('sig1.mat');
        t=0:1/length(f):1-1/length(f);
    case 'sig2'
        load('sig2.mat');
        t=0:1/length(f):1-1/length(f);
    case 'sig3'
        load('sig3.mat');
        t=0:1/length(f):1-1/length(f);
    case 'sig4'
        load('sig4.mat');
        t=0:length(f)-1;
    case 'sig5'
        load('seismic.mat');
        f=f(10000:20000); %sub portion of the signal used in the paper
        t=0:length(f)-1;
    case 'lena'
        load lena
        l=round(size(f,2)/2);
        imR=[f(:,(l-1:-1:1)) f f(:,(end:-1:end-l+1))];
        fftim=fft(imR');
        ff=abs(sum(abs(fftim),2)/size(fftim,2));
    case 'textures'
        load('texture.mat');
        l=round(size(f,2)/2);
        imR=[f(:,(l-1:-1:1)) f f(:,(end:-1:end-l+1))];
        fftim=fft(imR');
        ff=abs(sum(abs(fftim),2)/size(fftim,2));
end

if (~strcmp(signal,'lena')) && (~strcmp(signal,'textures'))
    % We extend the signal by miroring to deal with the boundaries
    l=round(length(f)/2);
    f=[f(l-1:-1:1);f;f(end:-1:end-l+1)];

    % We compute the Fourier transform of f
    ff=abs(fft(f));
end

%% Perform the detection and plot the detected boundaries
boundaries = EWT_Boundaries_Detect(ff,params);
boundaries = boundaries*pi/round(length(ff)/2);
Show_EWT_Boundaries(abs(fft(f)),boundaries,10);
