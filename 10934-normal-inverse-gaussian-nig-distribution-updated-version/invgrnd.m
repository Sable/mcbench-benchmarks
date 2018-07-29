function R = invgrnd(delta, gamma, M, N)
%INVGRND Random arrays from Inverse-Gaussian distribution.
%   R = INVGRND(DELTA, GAMMA, M, N) returns an array of random 
%   numbers chosen from Inverse-Gaussian distribution with the 
%   parameters DELTA and GAMMA.
%
%   The size of R is [M, N].
%
%   DELTA and GAMMA must be positive values.

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

V = chi2rnd(1, M, N);

x1 = delta / gamma * ones(M, N) + 1 / (2 * gamma^2) * (V + sqrt(4 * gamma * delta * V + V.^2));
x2 = delta / gamma * ones(M, N) + 1 / (2 * gamma^2) * (V - sqrt(4 * gamma * delta * V + V.^2));

Y = unifrnd(0, 1, M, N);

p1 = (delta * ones(M, N)) ./ (delta * ones(M, N) + gamma * x1);
p2 = ones(M, N) - p1;

C = (Y < p1);
R = C .* x1 + (ones(M, N) - C) .* x2;
