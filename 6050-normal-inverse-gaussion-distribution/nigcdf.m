function y = nigcdf(x, alpha, beta, mu, delta)
%NIGCDF Normal-Inverse-Gaussian cumulative distribution function (cdf).
%   Y = NIGCDF(X, ALPHA, BETA, MU, DELTA) returns the cdf of the 
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
%   See also NIGFITC, NIGFITG, NIGFITM, NIGFITP, NIGINV, NIGMM, NIGPAR, 
%            NIGPDF, NIGRND, NIGSTAT.

%   References:
%      [1] de Beus, P., Bressers, M. and de Graaf, T. (2003) Alternative
%          Investments and Risk Measurement, Appendix 2.

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
if ((mu == -inf) || (mu == inf))
    error('MU muss aus (-inf,inf) sein');
end
if abs(beta)>=alpha
    error('|BETA| muss kleiner gleich ALPHA sein');
end

% approximation of the integral through a summation
N = 1000;           % number of addends
ind = (1:N-1);
ind = 1./ind;
dummy = N*ind-1;

if size(x, 1) <= 1  % make x a column vector
    x = x';
end

M = length(x);

% the following is necessary due to limitations in available memory
% this accelerates computation time

maxSize = 1000;
nSteps = ceil(M / maxSize);
xLarge = x;
y = [];

for iSteps = 1:nSteps
    
    xSize = min(length(xLarge), maxSize);    
    x = xLarge(1:xSize);
    
    constFact = N*delta/sqrt(2*pi)*exp(delta*sqrt(alpha^2-beta^2));
    firstFact = ind.^2;
    secondFact = dummy.^(-1.5);
    expFact = exp(-1/2*(delta^2./dummy + (alpha^2-beta^2)*dummy));

    X = repmat(x, 1, N-1);
    DUMMY = repmat(dummy, xSize, 1);
    normalFact = normcdf(X, mu + beta*DUMMY, sqrt(DUMMY));

    y1 = constFact*firstFact.*secondFact.*expFact;
    ySmall = repmat(y1, xSize, 1).*normalFact;
   
    ySmallSum = sum(ySmall, 2);
    y = [y; ySmallSum];
    
    xLarge = xLarge(xSize + 1:end);
    
end

