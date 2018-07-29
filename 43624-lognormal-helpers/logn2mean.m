function [m, s, p] = logn2mean(mu,sigma)
%LOGN2MEAN converts lognormal parameters to mean, standard deviation and
%peak value
%
%Example:
%    [m, s, p] = logn2mean(1, 0.2)
%        m = 2.7732
%        s = 0.5602
%        p = 2.6117
%
%See also: mean2logn, lognfit, fit_logn, lognpdf, lognstat
%

	m = exp(mu + sigma.^2/2);
	s = sqrt(exp(2*mu + sigma.^2) .* (exp(sigma.^2) - 1));
	p = exp(mu - sigma.^2);
end

% Copyright 2009-2013 Alexandra Heidsieck <aheidsieck@tum.de>,
%                     IMETUM, Technische Universitaet Muenchen
