function y = nigpdf(x, alpha, beta, mu, delta)
%NIGPDF Probability density function (pdf) for Normal-Inverse-Gaussian distribution.
%   Y = NIGPDF(X, ALPHA, BETA, MU, DELTA) returns the pdf of the 
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA, evaluated at the values in X.
%   
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   ALPHA and DELTA must be positive values.
%   ALPHA > |BETA| must hold.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGCDF, NIGINV, NIGRND, NIGSTATS.
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
[nx, mx] = size(x);
x = reshape(x, nx * mx, 1);

% calculate leading factor
q = (delta * alpha / pi) * exp(delta * sqrt(alpha^2 - beta^2));
xbar = x - mu;
z = sqrt(delta^2 + xbar .* xbar);

% modified Bessel function of the third kind 
K = besselk(1, (alpha * z));

y = q ./ z .* K .* exp(beta * (x - mu));

% transform input vector back to input format
y = reshape(y, nx, mx);
y(isinf(x)) = 0;
