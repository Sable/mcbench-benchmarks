function r = nigrnd(alpha, beta, mu, delta, M, N)
%NIGRND Random arrays from  Normal-Inverse-Gaussian distribution.
%   R = NIGRND(ALPHA, BETA, MU, DELTA, M, N) returns an array of random 
%   numbers chosen from Normal-Inverse-Gaussian distribution with the 
%   parameter BETA which determines the skewness, shape parameter ALPHA, 
%   location parameter MU and scale parameter DELTA.
%
%   The size of R is [M, N].
%   
%   ALPHA, BETA, MU, DELTA must be scalar values.
%   
%   ALPHA and DELTA must be positive values.
%
%   MU must be a value greater than -inf and smaller than inf.
%
%   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%
%   See also INVGRND, NORMRND, NIGCDF, NIGFITC, NIGFITG, NIGFITM, NIGFITP, 
%            NIGINV, NIGMM, NIGPAR, NIGPDF, NIGSTAT.

%   References:
%      [1] Raible, S. (2000) Levy Processes in Finance - Theory, Numerics 
%          and Empirical Facts - PhD Thesis

% -------------------------------------------------
%
% risklab germany GmbH
% Nypmhenburger Strasse 112 - 116
% D-80636 Muenchen
% Germany
% Internet:     www.risklab.de
% email:        info@risklab.de    
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

% use inverse gaussian to compute normal inverse gaussian

X = invgrnd(delta, sqrt(alpha^2 - beta^2), M, N);
Y = normrnd(0, 1, M, N);

r = sqrt(X) .* Y + mu * ones(M, N) + beta * X;
