function C = modwt_dbp(X, wavelet, nlevels, boundary)
%%
%% Purpose:  Compute the (partial) maximal overlap discrete wavelet 
%%           transform
%% -------------------------------------------------------------------------
%% Reference: Percival and Guttorp (1994).  Long-memory processes, the 
%%            Allan variance and wavelets.  In "Wavelets and Geophysics,"
%%            pages 325-344.  Academic Press, Inc, San Diego.
%%            Percival and Mofjeld (1997).  Analysis of Subtidal Coastal 
%%            Sea Level Fluctuations Using Wavelets.  Journal of the 
%%            American Statistical Association 92, pp. 868-880.
%%
%% Input: X         Vector of observations
%%        wavelet   Character string; 'haar', 'd4', 'la8', 'la16'
%%        nlevels   Level of partial MODWT
%%        boundary  Character string; 'periodic' or 'reflection'
%%
%% Output : C  Matrix of MODWT wavelet coefficients
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

if 2.^J > N
  error('Wavelet transform exceeds sample size in DWT');
end

[h, g, l] = myfilter(wavelet);

ht = h ./ sqrt(2);
gt = g ./ sqrt(2);

C = [];
for j = 1:J
  [W, V] = modwt(X, ht, gt, j);
  C = [C W'];
  X = V; 
end
C = [C V'];
