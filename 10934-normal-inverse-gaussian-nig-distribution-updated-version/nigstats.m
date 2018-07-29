function [m, v, s, k] = nigstats(alpha, beta, mu, delta)
%NIGSTAT mean, variance, skewness and kurtosis for the 
%   Normal-Inverse-Gaussian distribution.
%   [M, V, S, K] = NIGSTAT(ALPHA, BETA, MU, DELTA) returns the mean, 
%   the variance, the skewness and the kurtosis of the
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA.
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   ALPHA and DELTA must be positive values.
%   ALPHA > |BETA| must hold.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGPDF, NIGCDF, NIGINV, NIGRND, NIGPAR.
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
if nargin < 1
    alpha = 1;
end
if nargin < 2
    beta = 0;
end
if nargin < 3
    mu = 0;
end
if nargin < 4
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

% auxiliary variable
gamma = sqrt(alpha^2 - beta^2);             

% evaluate the moments
m = mu + delta * (beta / gamma);
v = delta * (alpha^2 / gamma^3);
s = 3 * beta / alpha / sqrt(delta * gamma);
k = 3 + 3 * (1 + 4 * (beta / alpha)^2) / (delta * gamma);
