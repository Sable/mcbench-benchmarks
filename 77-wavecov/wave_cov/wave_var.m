function C = wave_var(X)
%%
%% Compute wavelet variance with approximate 95% confidence interval
%% -----------------------------------------------------------------------
%% Input: X  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%
%% Output: C  Matrix containing the wavelet variance (column 1), lower 
%%            95% quantile for confidence interval, upper 95% quantile 
%%            for confidence interval
%%
[I, J] = size(X);
SSX = [];
for j = 1:J
  XNaN = X(~isnan(X(:,j)),j)';
  SSX = [SSX sum(XNaN.^2)];
end
NX = sum(~isnan(X),1);
Y = SSX ./ NX;

%%% Computes the variance of the wavelet variance via Chapter 8.

ACF = [];
for j = 1:J
  ACF = [ACF; myACF(X(:,j))];
end
ACF = ACF';
AA = [];
for j = 1:J
  ACFNaN = ACF(~isnan(ACF(:,j)),j)';
  A = sum(ACFNaN.^2) - ACFNaN(1).^2 ./ 2;
  AA = [AA A];
end
VARnu = 2 .* AA ./ I;
C = [Y; Y - norminv(0.975) * sqrt(VARnu); Y + norminv(0.975) * sqrt(VARnu)]';

%%% Computes eta_3 from Chapter 8.

% ETA3 _ pmax(NX ./ 2.^(1:J), 1);
% C = [Y; ETA3 .* Y ./ chi2inv(0.975, ETA3); ETA3 .* Y ./ chi2inv(0.025, ETA3)]';
