function [m, v, skew, kurt] = nigstat(alpha, beta, mu, delta)
%NIGSTAT Mean, variance, skewness and kurtosis for the 
% Normal-Inverse-Gaussian distribution.
%   [M, V, SKEW, KURT] = NIGSTAT(ALPHA, BETA, MU, DELTA) returns the mean, 
%   the variance, the skewness and the kurtosis of the
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA.
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   
%   ALPHA and DELTA must be positive values.
%
%   MU must be a value greater than -inf and smaller than inf.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGCDF, NIGFITC, NIGFITG, NIGFITM, NIGFITP, NIGINV, NIGMM, 
%            NIGPAR, NIGPDF, NIGRND.

%   References:
%      [1] Schäffler, A. (2004) Reduktion von Schätzfehlern in der
%      Portfoliooptimierung durch Einsatz von robusten Schätzern

% -------------------------------------------------------------------------
% 
% risklab germany GmbH
% Nymphenburger Strasse 112 - 116
% D-80636 Muenchen
% Germany
% Internet:    www.risklab.de
% email:       info@risklab.de
% 
% Implementation Date:  2004 - 10 - 14
% Author:               Dr. Ralf Werner, Michaela Tempes
%                       ralf.werner@risklab.de
% -------------------------------------------------


% Constraints for the parameters
if alpha <= 0
    error('ALPHA must be positive.');
end
if delta <= 0
    error('DELTA must be positive.');
end
if (mu == -inf || mu == inf)
    error('MU muss aus (-inf,inf) sein');
end
if abs(beta)>=alpha
    error('|BETA| muss kleiner gleich ALPHA sein');
end

%auxiliary variable
gamma = sqrt(alpha^2 - beta^2);             

% evaluate the moments
m = mu + delta * (beta / gamma);
v = delta * (alpha^2 / gamma^3);
skew = 3 * beta / alpha / sqrt(delta * gamma);
kurt = 3 + 3 * (1 + 4 * (beta / alpha)^2) / (delta * gamma);
