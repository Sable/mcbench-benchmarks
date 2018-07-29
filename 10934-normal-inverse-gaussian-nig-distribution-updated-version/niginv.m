function x = niginv(p, alpha, beta, mu, delta)
%NIGINV Inverse of the Normal-Inverse-Gaussian cumulative distribution function (cdf).
%   X = NIGINV(P, ALPHA, BETA, MU, DELTA) returns the inverse cdf of the 
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA, evaluated at the values in P.
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   ALPHA and DELTA must be positive values.
%   ALPHA > |BETA| must hold.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGPDF, NIGCDF, NIGSTATS, NIGRND.
%
%   References:
%   [1] Prause, K. (1999). The Generalized Hyperbolic Model

% -------------------------------------------------------------------------
% 
% Allianz, Group Risk Controlling
% Risk Methodology
% Koeniginstr. 28
% D-80802 Muenchen
% Germany
% Internet:    www.allianz.de
% email:       ralf.werner@allianz.de
% 
% Implementation Date:  2006 - 05 - 01
% Author:               Dr. Ralf Werner
%
% -------------------------------------------------------------------------

%% Default input values
if nargin < 2
    alpha = 1;
end
if nargin < 3
    beta = 0;
end
if nargin < 4
    mu = 0;
end
if nargin < 5
    delta = 1;
end

%% Constraints for the parameters
if alpha <= 0
    error('ALPHA must be positive.');
end
if delta <= 0
    error('DELTA must be positive.');
end
if abs(beta)>=alpha
    error('|BETA| must be smaller than ALPHA');
end

% transform input into column vector
[np, mp] = size(p);
p = p(:);
n = np * mp;
x = zeros(size(p));

% partition p into three vectors
iLow = (p <= 0);
iHigh = (p >= 1);
iOK = and((p>0), (p<1));

pLow = p(iLow);
pHigh = p(iHigh);
pOK = p(iOK);

x(iLow) = -Inf;
x(iHigh) = Inf;
xOK = zeros(size(pOK));

pMin = min(pOK);
pMax = max(pOK);

% get lower and upper bounds for the cdf, faster than optimization
[m, v] = nigstats(alpha, beta, mu, delta);
kappa = 1;
lower = m - kappa * sqrt(v);
while (nigcdf(lower, alpha, beta, mu, delta) > pMin)
    lower = lower - kappa*sqrt(v);
    kappa = kappa + 1;
end
kappa = 1;
upper = m + kappa * sqrt(v);
while (nigcdf(upper, alpha, beta, mu, delta) < pMax)
    upper = upper + kappa*sqrt(v);
    kappa = kappa + 1;
end

xMin = lower;
xMax = upper;

%% evaluate nigcdf at a lot of interpolation points first
% calculate the interpolation points
% use standard value or amount similar to input size
steps = 14;
steps = max(steps, floor(0.8*log2(length(p))));

t = (0:1:2^steps) / 2^steps;
t = xMin + (xMax - xMin) * t;

% this defines the nigcdf with the appropriate parameters
nigcum = @(u)(nigcdf(u, alpha, beta, mu, delta));
y = nigcum(t);

% use calculated values for linear interpolation
xOK = interp1q(y', t', pOK);

x(iOK) = xOK;

% transform input vector back to input format
x = reshape(x, np, mp);

end