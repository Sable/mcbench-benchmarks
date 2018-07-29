function [ rms ] = rms( s )
%RMS finds the Root Mean Squared of the signal in question.
%s is a signal in the time domain.
%Written by David Berman, dberm22@gmail.com

rms = sqrt(mean(s.^2));


end

