function [ Pxx, Pyy, Pxy, coh, pha, freq ] = func_coherence( f1, f2, nfft, Fs, filt, n_overlap )

%
% Computing power spectrum, cross spectrum, coherence and phase
%
% All input parameters are equivalent to csd or the other spectrum 
% related function in MATLAB.
%
% This program use csd.m in Signal Processing Toolbox.
%
% Input
%	f1 and f2	input data
%	nfft		number of data for FFT
%	Fs		sampling frequency
%	filt		filter vector, hanning(nfft/2)
%	n_overlap	number of overlap for smoothing
%
% Output
%	Pxx		spectrum of f1
%	Pyy		spectrum of f2
%	Pxy		cross spectrum between f1 and f2
%	coh		coherence
%	pha		phase
%	freq		frequency vector
%
%======================================================================
% Terms:
%
%       Distributed under the terms of the terms of the BSD License
%
% Copyright:
%
%       Nobuhito Mori
%           Disaster Prevention Research Institue
%           Kyoto University
%           mori@oceanwave.jp
%
%========================================================================

[Pxx,freq] = csd( f1, f1, nfft, Fs, filt, n_overlap );
[Pyy,freq] = csd( f2, f2, nfft, Fs, filt, n_overlap );
[Pxy,freq] = csd( f1, f2, nfft, Fs, filt, n_overlap );

Kxy  = real( Pxy );
Qxy  = imag( Pxy );
coh  = Pxy.*conj(Pxy)./(Pxx.*Pyy);
pha  = atan2( Qxy, Kxy );

