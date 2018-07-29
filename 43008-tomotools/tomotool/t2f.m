function [f, sf] = t2f(t, st)
% This is a function using fft fcn to calculate a signal's FT.
% Input is time and signal vectors, the length of time must greater than 2.
% Output is frequency and signal spectrum.
%
% Phymhan Studio, $ 18-May-2013 15:16:35 $

if nargin < 2
    fprintf('Not enough input arguments.\n')
    return
end
if length(t) < 2
    fprintf('length of time must greater than 2.\n')
    return
end

dt = t(2)-t(1);
T = t(end)-t(1)+dt;
df = 1/T;
N = length(st);

f = (-N/2:N/2-1)*df;
sf = T/N*fftshift(fft(st)); % rearranges the outputs of fft
end
