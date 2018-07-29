function C = wave_cor(X, Y)
%%
%% Compute wavelet correlation with approximate 95% confidence interval
%% -----------------------------------------------------------------------
%% Input: X  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%        Y  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%
%% Output: C  Matrix containing the wavelet correlation (column 1), lower 
%%            95% quantile for confidence interval, upper 95% quantile 
%%            for confidence interval
%%
[I, J] = size(X);

XY = X .* Y;
SSX = []; SSY = []; SSXY = [];
for j = 1:J
  XNaN = X(~isnan(X(:,j)),j)';
  SSX = [SSX sum(XNaN.^2)];
  YNaN = Y(~isnan(Y(:,j)),j)';
  SSY = [SSY sum(YNaN.^2)];
  XYNaN = XY(~isnan(XY(:,j)),j)';
  SSXY = [SSXY sum(XYNaN)];
end
NX = sum(~isnan(X),1);
COR = (SSXY./NX) ./ (sqrt(SSX./NX) .* sqrt(SSY./NX));

NDWT = floor(I ./ 2.^(1:J));

C = [COR; tanh(atanh(COR) - norminv(0.975) ./ sqrt(NDWT-3)); 
             tanh(atanh(COR) + norminv(0.975) ./ sqrt(NDWT-3))]';
