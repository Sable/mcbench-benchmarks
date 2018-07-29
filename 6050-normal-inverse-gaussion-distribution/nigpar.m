function [alpha, beta, mu, delta] = nigpar(m, v, skew, kurt)
%NIGPAR Parameters for the Normal-Inverse-Gaussian distribution.
%   [ALPHA, BETA, MU, DELTA] = NIGPAR(M, V, SKEW, KURT) returns the scale 
%   paramter ALPHA, BETA which determines the skewness, the location 
%   parameter MU and the scale parameter DELTA of the Normal-Inverse-Gaussian 
%   distribution with mean M, variance V, skewness SKEW and kurtosis KURT.
%
%   See also NIGCDF, NIGFITC, NIGFITG, NIGFITM, NIGFITP, NIGINV, NIGMM, 
%            NIGPDF, NIGRND, NIGSTAT.

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
if nargin < 1
    m = 0;
end
if nargin < 2
    v = 1;
end
if nargin < 4
    if nargin < 3
        skew = 0;
        kurt = 3 + Tol;
    else
        kurt = 3 + 5/3*skew^2 + Tol;
    end
end

% Constraints for the parameters

if v <= 0
    error('The variance V must be positive.');
end

errortest_1 = kurt - 5/3*skew^2 - 3;

if errortest_1 <= 0
    error('KURT must be greater than 3 + 5/3skew^2.');
else
    % evaluate the parameters
    alpha = sqrt((3*kurt - 4*skew^2 - 9) / (v*(kurt-5/3*skew^2 - 3)^2));
    beta = skew/(sqrt(v)*(kurt - 5/3*skew^2 - 3));
    mu = m - 3*skew*sqrt(v)/(3*kurt - 4*skew^2 - 9);
    delta = 3^(3/2)*sqrt(v*(kurt - 5/3*skew^2 - 3))/(3*kurt - 4*skew^2 - 9);
end
