function C = ComputeCrossCorrelation(Y_F, Y_Z, Corr_Y_F)
%C = ComputeCrossCorrelation(Y_ZZ, Y_F, Corr_Y_F, exp_window_size)
%   Computes a cross correlation between two random vectors given their
%   joint realizations and a cleaned correlation matrix estimate Corr_Y_F
%   for Y_F. Every column of Y_F and Y_Z are assumed to have unit variance.
% Code by S. Gollamudi. This version December 2009. 

exp_window_size=10^9;

[T,KZ] = size(Y_Z);
KF = size(Y_F,2);

% compute exponential weights
lambda = 2/exp_window_size;
exp_wts = (1-lambda).^(T-1:-1:0)*(lambda/(1-(1-lambda)^T));
mF_exp_wts = repmat(exp_wts',1,KF);
mZ_exp_wts = repmat(exp_wts',1,KZ);

% compute exponentially weighted sample means
meanYF = sum(mF_exp_wts.*Y_F, 1);
meanYZ = sum(mZ_exp_wts.*Y_Z, 1);

% remove mean from the time series Y_F and Y_Z
Y_F = Y_F - repmat(meanYF,T,1);
Y_Z = Y_Z - repmat(meanYZ,T,1);

% Compute the regresssion weights for Y_Z on Y_F using weighted least squares
B = ((mF_exp_wts.*Y_F)'*Y_F) \ ((mF_exp_wts.*Y_F)'*Y_Z);

% Compute the cross-correlation matrix that gives the same regression
% weights B when used with the cleaned correlation matrix of Y_F
C = Corr_Y_F*B;
