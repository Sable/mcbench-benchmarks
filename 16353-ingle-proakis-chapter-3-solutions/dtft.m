function [X] = dtft(x,nx,w)
% Computes Discrete-time Fourier Transform 
% [X] = dtft(x,n,w)
%
% X = DTFT values are computed at w frequencies 
% x = finite duration sequence over n 
% n = sample position vector 
% w = frequency location vector
M = 250;
k = -M:M;                       % k = 501 points
X = x*(exp(-j*pi/M)).^(nx'*k);  % Computes DTFT