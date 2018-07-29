function [t,x] = manchester(bits, bitrate)
% MANCHESTER Encode bit string using Manchester code.
%   [T, X] = MANCHESTER(BITS, BITRATE) encodes BITS array using Manchester
%   code with given BITRATE. Outputs are time T and encoded signal
%   values X.

% Copyright (c) 2013 Yuriy Skalko <yuriy.skalko@gmail.com>

T = length(bits)/bitrate; % full time of bit sequence
n = 200;
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
x = zeros(1,length(t)); % output signal

for i = 0:length(bits)-1
  if bits(i+1) == 1
    x(i*n+1:(i+0.5)*n) = 1;
    x((i+0.5)*n+1:(i+1)*n) = -1;
  else
    x(i*n+1:(i+0.5)*n) = -1;
    x((i+0.5)*n+1:(i+1)*n) = 1;
  end
end
