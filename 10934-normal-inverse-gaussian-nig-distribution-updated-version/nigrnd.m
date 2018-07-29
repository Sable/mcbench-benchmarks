function r = nigrnd(alpha, beta, mu, delta, m, n)
%NIGRND random arrays from Normal-Inverse-Gaussian distribution.
%   R = NIGRND(ALPHA, BETA, MU, DELTA, M, N) returns an array of random 
%   numbers chosen from Normal-Inverse-Gaussian distribution with the 
%   parameter BETA which determines the skewness, shape parameter ALPHA, 
%   location parameter MU and scale parameter DELTA.
%
%   The size of R is [M, N].
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   ALPHA and DELTA must be positive values.
%   ALPHA > |BETA| must hold.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGPDF, NIGCDF, NIGINV, NIGSTATS.
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
if nargin < 5
    m = 1;
    n = 1;
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

% use inverse gaussian to compute normal inverse gaussian
x = invgrnd(delta, sqrt(alpha^2 - beta^2), m, n);
y = normrnd(0, 1, m, n);

r = sqrt(x) .* y + mu * ones(m, n) + beta * x;

