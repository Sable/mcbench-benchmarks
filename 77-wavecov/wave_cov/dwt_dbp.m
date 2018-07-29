function [C, L] = dwt_dbp(X, wavelet, nlevels, boundary)
%%
%% Purpose:  Compute the (partial) discrete wavelet transform
%% -------------------------------------------------------------------------
%% Reference: Percival and Walden (1999).  Wavelet Methods for Time Series
%%            Analysis.  Cambridge University Press, Cambridge.
%%
%% Input: X         Vector of observations
%%        wavelet   Character string; 'haar', 'd4', 'la8', 'la16'
%%        nlevels   Level of partial DWT
%%        boundary  Character string; 'periodic' or 'reflection'
%%
%% Output : C  Matrix of DWT wavelet coefficients (padded with NaNs to
%%             retain proper dimension)
%%          L  Vector containing number of wavelet coefficients for each 
%%             level
%%
N = length(X);
J = nlevels;

switch boundary
  case 'reflection'
    X = [X fliplr(X)];
    N = length(X);
  case 'periodic'
    ;
  otherwise
    error('Invalid boundary rule in dwt_dbp');
end

if log2(N) ~= floor(log2(N))
  error('Sample size is not a power of 2');
end

if 2.^J > N
  error('Wavelet transform exceeds sample size in DWT');
end

[h, g, l] = myfilter(wavelet);

C = []; L = [];
for j = 1:J
  [W, V] = dwt(X, h, g);
  C = [W C];
  L = [N/2.^j L];
  X = V; 
end
C = [V C];
