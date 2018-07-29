function C = wave_cov(X, Y)
%%
%% Compute wavelet covariance with approximate 95% confidence interval
%% -----------------------------------------------------------------------
%% Input: X  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%        Y  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%
%% Output: C  Matrix containing the wavelet covariance (column 1), lower 
%%            95% quantile for confidence interval, upper 95% quantile 
%%            for confidence interval
%%
[I, J] = size(X);
XY = X .* Y;
SSXY = [];
for j = 1:J
  XYNaN = XY(~isnan(XY(:,j)),j)';
  SSXY = [SSXY sum(XYNaN)];
end
NX = sum(~isnan(X),1);
Z = SSXY ./ NX;

XACF = []; YACF = []; SUMXYCCF = [];
for j = 1:J
  XACF = [XACF; myACF(X(:,j))];
  YACF = [YACF; myACF(Y(:,j))];
  SUMXYCCF = [SUMXYCCF; myCCF(X(:,j),Y(:,j))];
end
XACF = XACF'; YACF = YACF'; SUMXYCCF = SUMXYCCF';

AA = [];
for j = 1:J
  XACFNaN = XACF(~isnan(XACF(:,j)),j)';
  YACFNaN = YACF(~isnan(YACF(:,j)),j)';
  A = sum(XACFNaN .* YACFNaN) + SUMXYCCF(j);
  AA = [AA A];
end

VARgamma = AA ./ (2 .* NX);
C = [Z; Z - norminv(0.975) .* sqrt(VARgamma);
        Z + norminv(0.975) .* sqrt(VARgamma)]';
