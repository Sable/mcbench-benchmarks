function [mu, sigma] = mean2logn(m,s)
%MEAN2LOGN converts mean value and standard deviation to lognormal parameters
%
%Example:
%    [m, s] = mean2logn(2, 0.5)
%        m = 0.6628
%        s = 0.2462
%
%See also: logn2mean, lognfit, fit_logn, lognpdf, lognstat

	mu    = log(m.^2./sqrt(s.^2 + m.^2));
	if all(s.^2./m.^2 > 2e-16)
		sigma = sqrt(log(s.^2./m.^2 + 1));
	else
		sigma = 1e-10;
	end
end

% Copyright 2009-2013 Alexandra Heidsieck <aheidsieck@tum.de>,
%                     IMETUM, Technische Universitaet Muenchen
