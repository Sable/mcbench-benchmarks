function C = modwt_brick_wall(X, wavelet, N)
%%
%% Purpose:  Sets the first N_j coefficients to NaN, for j = 1,...,J.
%% -------------------------------------------------------------------------
%% Reference: Lindsay et al. (1996).  The Discrete Wavelet Transform
%%            and the Scale Anlaysis of the Surface Properties of Sea
%%            Ice.  IEEE Trans. on Geo. and Rem. Sen., 34(3), pp. 
%%            771-787.
%%
%% Input: X        Matrix containing wavelet coefficients with appropriate 
%%                 boundary condition
%%        wavelet  Character string; 'haar', 'd4', 'la8', 'la16'
%%        N        Length of original vector of observations
%%
%% Output: C  Matrix containing wavelet coefficients where ones affected
%%            by boundary conditions are replaced with NaNs
%%
[h, g, l] = myfilter(wavelet);
[I, J] = size(X);

C = X;
for j = 1:(J-1)
  n = (2.^j - 1) * (l - 1);
  C(1:n,j) = NaN;
end
C(1:n,j+1) = NaN;
