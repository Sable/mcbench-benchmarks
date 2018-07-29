function [ rms ] = frms( S )
%FRMS uses Parseval's theorem to calculate the RMS of a signal 
%by examining the frequency domain of the signal.
%S is the signal in the frequency domain, i.e. fft(s)
%Written by David Berman, dberm22@gmail.com

rms = sqrt(sum((abs(S)/length(S)).^2));


end

