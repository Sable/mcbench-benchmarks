function [C, L] = wave_cross_cov(X, Y, LMAX)
%%
%% Compute wavelet cross-covariances for arbitrary lag
%% -----------------------------------------------------------------------
%% Input: X     Matrix containing wavelet coefficients with appropriate 
%%              boundary condition
%%        Y     Matrix containing wavelet coefficients with appropriate 
%%              boundary condition
%%        LMAX  Maximum lag to compute
%%
%% Output: C  Matrix containing the wavelet cross-covariance (same 
%%            number of columns as X and Y)
%%         L  Vector of lags (for plotting)
%%
[I J] = size(X);
L = (-LMAX+1):(LMAX-1);

XYCrossCov = []; C = [];
for j = 1:J
  XNaN = X(~isnan(X(:,j)),j)';
  ZNaN = XNaN;
  YNaN = Y(~isnan(Y(:,j)),j)';
  NX = length(XNaN);
  NXX = min(length(XNaN) - 1, LMAX);

  LAG1 = []; LAG2 = [];
  for i = 1:NXX
    XYNaN = XNaN .* YNaN;
    ZYNaN = ZNaN .* YNaN;
    LAG1 = [LAG1 sum(XYNaN(~isnan(XYNaN))) ./ NX];
    LAG2 = [LAG2 sum(ZYNaN(~isnan(ZYNaN))) ./ NX];
    XNaN = [XNaN(2:NX) NaN];
    ZNaN = [NaN ZNaN(1:(NX-1))];
  end
  XYCrossCov = [fliplr(LAG2) LAG1(2:LMAX)];
  C = [C XYCrossCov'];
end
