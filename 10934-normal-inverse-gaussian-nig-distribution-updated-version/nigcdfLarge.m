function y = nigcdfLarge(x, alpha, beta, mu, delta)
%NIGCDFLARGE Normal-Inverse-Gaussian cumulative distribution function (cdf).
%
%   This version is called by nigcdf and should not be used on its own.
%   This version is optimized for large vectors x (numel(x) > 100).

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


% transform input into column vector
[nx, mx] = size(x);
x = x(:);
n = nx * mx;

% further parameters
xMax = max(x) + delta;
xMin = min(x);

% get bounds for the integration function
yTemp = nigcdfSmall([xMin, xMax], alpha, beta, mu, delta);
yMin = yTemp(1);
yMax = yTemp(2);

% now define the real function to be integrated
% uses the NIG density for integration
helpfunction = @(u)(nigpdf(u, alpha, beta, mu, delta));

% use intermediate values and then linear interpolation
nNodes = 4;                             % number of Gauss nodes
nDivisionLevel = 13;                    % number of recursive splits
                                        % should give exactness 1.0e-007
nDivisionLevel = max(nDivisionLevel, floor(0.60*log2(n)));

[dummy, allIntegrationValues, allIntegrationPts] = gaussIntegration(helpfunction, xMin, xMax, nDivisionLevel, nNodes);

allIntegrationValues = allIntegrationValues + yMin;

% plot(allIntegrationPts, allIntegrationValues, '.');

% now interpolate / extrapolate integration values at given input points

if n > 1
    y = interp1q([xMin; allIntegrationPts; xMax], [yMin; allIntegrationValues; yMax], x);
else
    y = yMin;
end

% transform input vector back to input format
y = reshape(y, nx, mx);

