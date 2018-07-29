function w = hann(n)
% function w = hann(n)
% A Hann window of length n. Does not smear tones located exactly in a bin.
w = .5*(1 - cos(2*pi*(0:n-1)/n) );
