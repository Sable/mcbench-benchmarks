function [alpha, beta, mu, delta] = nigpar(m, v, s, k)
%NIGPAR Parameters for the Normal-Inverse-Gaussian distribution.
%   [ALPHA, BETA, MU, DELTA] = NIGPAR(M, V, S, K) returns the scale 
%   paramter ALPHA, BETA which determines the skewness, the location 
%   parameter MU and the scale parameter DELTA of the Normal-Inverse-Gaussian 
%   distribution with mean M, variance V, skewness S and kurtosis K.
%
%   See also NIGPDF, NIGCDF, NIGINV, NIGRND, NIGSTATS.
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

Tol = 1.0e-007;

%% Default values
if nargin < 1
    m = 0;
end
if nargin < 2
    v = 1;
end
if nargin < 4
    if nargin < 3
        s = 0;
        k = 3 + Tol;
    else
        k = 3 + 5/3*s^2 + Tol;
    end
end

%% Constraints for the parameters

if v <= 0
    error('The variance V must be positive.');
end

if (k - 5/3*s^2 - 3 <= 0)
    error('K must be greater than 3 + 5/3 S^2.');
end
    
alpha = sqrt((3*k - 4*s^2 - 9) / (v*(k-5/3*s^2 - 3)^2));
beta = s/(sqrt(v)*(k - 5/3*s^2 - 3));
mu = m - 3*s*sqrt(v)/(3*k - 4*s^2 - 9);
delta = 3^(3/2)*sqrt(v*(k - 5/3*s^2 - 3))/(3*k - 4*s^2 - 9);
