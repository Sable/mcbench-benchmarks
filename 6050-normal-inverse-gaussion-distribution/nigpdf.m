function y = nigpdf(x, alpha, beta, mu, delta)
%NIGPDF Probability density function (pdf) for Normal-Inverse-Gaussian distribution.
%   Y = NIGPDF(X, ALPHA, BETA, MU, DELTA) returns the pdf of the 
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA, evaluated at the values in X.
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
%            NIGPAR, NIGRND, NIGSTAT.

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


% Default values
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


q = (delta*alpha / pi) * exp(delta * sqrt(alpha^2 - beta^2));

z = sqrt(delta^2 + (x-mu).*(x-mu));

%Modified Bessel function of the third kind 
K = besselk(1, (alpha * z));

y = q./z .* K .* exp(beta * (x - mu));
