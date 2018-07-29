function [yout] = vowel_ir(fmts,bandwidths,fs)
% synthesize vowel impulse response from formants and bandwidths and fs
% INPUTS:
%   fmts: first four formants for selected vowel
%   bandwidths: first four bandwidths for selected vowel
%   fs: sampling rate in Hz
%
    xin=[1 zeros(1,499)];
    for resonance=1:4
        f=fmts(resonance);
        bw=bandwidths(resonance);
        num=1-2*exp(-bw*2*pi/fs)*cos(2*pi*f/fs)+exp(-2*bw*pi/fs);
        den=[1 -2*exp(-bw*2*pi/fs)*cos(2*pi*f/fs) exp(-2*bw*pi/fs)];
        yout=filter(num, den, xin);
        xin=yout;
    end
end

