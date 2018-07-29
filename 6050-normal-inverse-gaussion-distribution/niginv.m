function x = niginv(p, alpha, beta, mu, delta)
%NIGINV Inverse of the Normal-Inverse-Gaussian cumulative distribution function (cdf).
%   X = NIGINV(P, ALPHA, BETA, MU, DELTA) returns the inverse cdf of the 
%   Normal-Inverse-Gaussian distribution with the parameter BETA which 
%   determines the skewness, shape parameter ALPHA, location parameter MU 
%   and scale parameter DELTA, evaluated at the values in P.
%
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   
%   ALPHA and DELTA must be positive values.
%
%   MU must be a value greater than -inf and smaller than inf.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also NIGCDF, NIGFITC, NIGFITG, NIGFITM, NIGFITP, NIGMM, NIGPAR, 
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

helpfun = inverseFunction(@nigcdf, alpha, beta, mu, delta);
x = helpfun(p);

end

% -------------------------------------------------------------------------

function invFunction = inverseFunction(preimageFunction, varargin)
%INVERSEFUNCTION gives the inverse function of the preimageFunction back.
%   INVFUNCTION = INVERSEFUNCTION(PREIMAGEFUNCTION, VARARGIN) evaluates the
%   inverse of the PREIMAGEFUNCTION with the parameters VARARGIN.

% -------------------------------------------------------------------------
% 
% risklab germany GmbH
% Nymphenburger Strasse 112 - 116
% D-80636 Muenchen
% Germany
% Internet:    www.risklab.de
% email:       info@risklab.de
% 
% Implementation Date:  2004 - 07 - 22
% Author:               Michaela Tempes

% bounds of the intervall in which the preimage of the invFunction should
% be
eps = 10^(-6);
lowerBound = -5;                         % lower bound
f_l = preimageFunction(lowerBound, varargin{:});
while f_l > eps
    lowerBound = 2 * lowerBound;
    f_l = preimageFunction(lowerBound, varargin{:});
end

upperBound = 5;                        % upper bound
f_u = preimageFunction(upperBound, varargin{:});
while f_u < 1-eps
    upperBound = upperBound*2;
    f_u = preimageFunction(upperBound, varargin{:});
end

% supporting points
N = 16384;                  % number of supporting points - 1   
x = lowerBound :((upperBound-lowerBound)/N):upperBound;
f = preimageFunction(x,varargin{:});

if size(f,2) <=1                % transpose f if it isn't a row vector
    f = f';
end
if size(x,2) <=1                % transpose f if it isn't a row vector
    x = x';
end

% define nested function and return handle to it as new inverse function

    function h = imageFunction(p)

        if size(p, 1) <= 1          % transpose p if it isn't a column vector
            p = p';
        end

        h = interp1(f, x, p, 'linear');

    end    

invFunction = @imageFunction;

end