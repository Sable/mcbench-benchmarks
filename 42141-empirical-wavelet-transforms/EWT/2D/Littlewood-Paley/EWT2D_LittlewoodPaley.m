function [ewtLP,mfb,boundaries]=EWT2D_LittlewoodPaley(f,params)

%==========================================================================
% function [ewtLP,mfb,boundaries]=EWT2D_LittlewoodPaley(f,params)
%
% This function performs the 2D Littlewood-Paley EWT. The Fourier 
% boundaries are detected using the Pseudo-Polar FFT. 
%
% TO RUN THIS FUNCTION YOU NEED TO HAVE THE MATLAB POLARLAB TOOLBOX OF 
% MICHAEL ELAD: http://www.cs.technion.ac.il/~elad/Various/PolarLab.zip
%
% Input:
%   -f: input image
%   -params: structure containing the following parameters:
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log of the ff
%       -params.preproc: 'none','plaw','poly','morpho','tophat'
%       -params.method: 'locmax','locmaxmin','ftc'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%
% Output:
%   -ewtLP: cell containing each filtered output subband
%   -mfb: cell containing the set of detected filters in the Fourier domain
%   -boundaries: list of the detected boundaries
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==========================================================================

W0=size(f,2);
H0=size(f,1);

% Pseudo Polar FFT of f
PseudoFFT=PPFFT(f);

% Compute the mean spectrum with respect to the angle
meanppfft=sum(abs(PseudoFFT),2);

% Detect the boundaries
boundaries = EWT_Boundaries_Detect(fftshift(meanppfft),params);
boundaries = boundaries*pi/round(length(meanppfft)/2);

% We mirror the input image (half on each side) in order to get rid of border effects
W1=floor(W0/2);
H1=floor(H0/2);
f=[f(H1:-1:1,W1:-1:1) f(H1:-1:1,:) f(H1:-1:1,end:-1:end-W1+1) ; f(:,W1:-1:1) f f(:,end:-1:end-W1+1) ; f(end:-1:end-H1+1,W1:-1:1) f(end:-1:end-H1+1,:) f(end:-1:end-H1+1,end:-1:end-W1+1)];

W=size(f,2);
H=size(f,1);

% Build the 2D filter bank
mfb=EWT2D_Meyer_FilterBank(boundaries,W,H);

% We filter the signal to extract each subband
ff=fft2(f);

ewtLP=cell(length(mfb),1);
for k=1:length(mfb)
    ewtLP{k}=real(ifft2(conj(mfb{k}).*ff));
    ewtLP{k}=ewtLP{k}(H1+1:H1+H0,W1+1:W1+W0);
end