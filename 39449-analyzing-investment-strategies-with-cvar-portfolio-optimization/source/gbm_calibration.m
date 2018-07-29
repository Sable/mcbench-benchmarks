function [x0, mu, gamma] = gbm_calibration(t0, X, t)
%gbm_calibration - Calibrate a multivariate geometric Brownian motion process.
%
%	[x0, mu, gamma] = gbm_calibration(t0, X, t);
%
% Inputs:
%	t0 - Initial time [scalar].
%	X - A single realization of a geometric Brownian motion process at times in t [matrix].
%
% Optional Inputs:
%	t - Times at which the realization X is observed with default values t0 + 1, t0 + 2, ...
%		[vector].
%
% Outputs:
%	x0 - Initial price [vector].
%	mu - Drift coefficient [vector].
%	gamma - Diffusion coefficient [matrix].
%
% Comments:
%	1) The multivariate geometric Brownian motion process has stochastic differential equation in
%		the form
%			dX(t) = f(X(t), t)*dt + G(X(t), t)*dB(t)
%		for t >= t0 with standard Brownian motion B(t) and almost sure initial X(t0) = x0. The drift
%		function is
%			f(X(t), t)i = mu(i)*Xi(t)
%		for i = 1, ... , n and the diffusion function is
%			G(X(t), t)ij = gamma(i,j)*Xi(t)
%		for i, j = 1, ... , n.
%		Note that the "covariance" matrix for this process is covar = gamma*gamma' and that the
%		"standard deviations" are sigma = sqrt(diag(covar)).
%	2) An equivalent multivariate geometric Brownian motion process has stochastic differential
%		equation in the form
%			dX(t) = mu(i)*Xi(t)*dt + sigma(i)*Xi(t)*dBi(t)
%		for t >= t0 with correlated Brownian motion B(t) and almost sure initial X(t0) = x0. The
%		correlated Brownian motion process has
%			E[ Bi(t) ] = 0
%			var(Bi(t)) = 1
%			cov(Bi(t), Bj(t)) = rho(i,j)
%		for i, j = 1, ... , n.
%		Note that gamma is a Cholesky decomposition of rho .* (sigma*sigma').
%	4) WARNING: This function works best if X has no NaN values or large gaps in the data. If X has
%		NaN values, then this function throws out times and data (rows in X) with NaN values in at
%		least one element of X at that time. If X has large gaps, then this function can have large
%		errors in the parameter estimates.

% Copyright (C) 2012 The MathWorks, Inc.

if nargin < 2 || isempty(t0) || isempty(X)
	error('Missing or empty required input arguments initial time t0 or realization X.');
end

if nargin < 3
	t = [];
end

N = size(X,1);

if isempty(t)
	t = t0 + (1:N);
end

t = t(:);

if numel(t) ~= N
	error('Non-conformable realization X and times t.');
end

ii = all(~isnan(X),2);

X = X(ii,:);
t = t(ii,:);

[N, n] = size(X);

if isempty(X)
	error('The realization X has a NaN value in at least one element at every time in t.');
end

if t(1) <= t0
	error('The first time in t must be greater than the initial time t0.');
end

Y = log(X);

psi = (Y(end,:) - Y(1,:))'/(t(end) - t(1));

sigma = 0;
for i = 2:N
	dt = t(i) - t(i-1);
	dY = (Y(i,:) - Y(i-1,:))';
	sigma = sigma + (dY - psi*dt)*(dY - psi*dt)'/dt;
end
sigma = sigma/N;

xi = Y(1,:)' - psi*(t(1) - t0);

gamma = chol(sigma)';

mu = psi;
for i = 1:n
	mu(i) = mu(i) + 0.5*sum(gamma(i,:) .^ 2);
end

x0 = exp(xi);
