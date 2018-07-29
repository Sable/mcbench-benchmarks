function y = nigcdf(x, alpha, beta, mu, delta)
%NIGCDF Normal-Inverse-Gaussian cumulative distribution function (cdf).
%   Y = NIGCDF(X, ALPHA, BETA, MU, DELTA) returns the cdf of the 
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA, evaluated at X.
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   ALPHA and DELTA must be positive values.
%   ALPHA > |BETA| must hold.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGPDF, NIGINV, NIGRND, NIGSTATS.
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

% pick only the valid inputs and transform them to vector
xTemp = x;
iInf = isinf(x);
x = x(not(iInf));
x = x(:);

%% switch depending on number of input elements in x
if numel(x) < 100
    y = nigcdfSmall(x, alpha, beta, mu, delta);
else
    y = nigcdfLarge(x, alpha, beta, mu, delta);
end

%% plug in the valid inputs and treat +/- Inf correctly
yTemp = zeros(size(xTemp));
yTemp(not(iInf)) = y;
yTemp(xTemp == Inf) = 1;
yTemp(xTemp == -Inf) = 0;
y = yTemp;
