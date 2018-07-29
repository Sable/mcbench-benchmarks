function Pr = gbm_upcrossing_prob(X0, K, T, mu, sigma)
%gbm_upcrossing_prob - Compute probability of an upcrossing of a geometric Brownian motion.
%
%	Pr = gbm_upcrossing_prob(X0, K, T, mu, sigma);
%
% Inputs:
%	X0 - Almost surely known initial value of geometric Brownian motion process [scalar].
%	K - Level for upcrossing of geometric Brownian motion during a specified period [scalar].
%	T - Duration of the period of observation in a specified unit of time [scalar].
%	mu - Drift of geometric Brownian motion in rate of change per specified unit of time [scalar].
%	sigma - Diffusion of geometric Brownian motion in rate of change per specified unit of time
%		[scalar].
%
% Outputs:
%	Pr - Probability of an upcrossing of a geometric Brownian motion during the period T in the
%		specified units of time [scalar].
%
% Comments:
%	1) This function computes the probability that a geometric Brownian motion crosses at or above a
%		specified level at any time during a specified fixed period of time.
%	2) The term "unit of time" indicates that all times and rates must be in the same units of time.

% Copyright (C) 2012 The MathWorks, Inc.

if K <= X0
	Pr = 1;
else
	d0 = log(X0/K);
	d1 = (d0 + (mu - 0.5*sigma^2)*T)/(sigma*sqrt(2*T));
	d2 = (d0 - (mu - 0.5*sigma^2)*T)/(sigma*sqrt(2*T));
	d3 = -0*(mu - 0.5*sigma^2)/(0.5*sigma^2);

	Pr = 0.5*(1 + erf(d1)) + 0.5*exp(-d3)*(1 + erf(d2));
end
