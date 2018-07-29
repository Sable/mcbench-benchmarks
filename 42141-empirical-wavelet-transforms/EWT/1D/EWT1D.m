function [ewt,mfb,boundaries]=EWT1D(f,params)

% ======================================================================
% function ewt=EWT1D(f,params)
% 
% Perform the Empirical Wavelet Transform of f over Nscale scales
%
% Inputs:
%   -f: the input signal
%   -params: structure containing the following parameters (see the
%            documentation of EWT_Boundaries_Detect for more details):
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log spectrum
%       -params.preproc: 'none','plaw','poly','morpho,'tophat'
%       -params.method: 'locmax','locmaxmin','ftc'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%       -params.completion: 0 or 1 to indicate if we try to complete
%                           or not the number of modes if the detection
%                           find a lower number of mode than params.N
%
% Outputs:
%   -ewt: cell containing first the low frequency component and
%         then the successives frequency subbands
%   -mfb: cell containing the filter bank (in the Fourier domain)
%   -boundaries: vector containing the set of boundaries corresponding
%                to the Fourier line segmentation (normalized between
%                0 and Pi)
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
% ======================================================================

% We extend the signal by miroring to deal with the boundaries
l=round(length(f)/2);
f=[f(l-1:-1:1);f;f(end:-1:end-l+1)];

% We compute the Fourier transform of f
ff=fft(f);

% We extract the boundaries of Fourier segments
boundaries = EWT_Boundaries_Detect(abs(ff(1:round(length(ff)/2))),params);
boundaries = boundaries*pi/round(length(ff)/2);

% We build the corresponding filter bank
mfb=EWT_Meyer_FilterBank(boundaries,length(ff));

% We filter the signal to extract each subband
ewt=cell(length(mfb),1);
for k=1:length(mfb)
    ewt{k}=real(ifft(conj(mfb{k}).*ff));
    ewt{k}=ewt{k}(l:end-l);
end