function phi_1=phi1(S, T, gamma, H, X, r, b, sigma)

%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Function used in the call option approximatio function of 
% Bjerksund and Stensland (1993)
%
%
% Reference:
%
% Petter Bjerksund and Gunnar Stensland,  
% "Closed form approximations of american options", 
% Scandinavian Journal of Management, 20(5):761-764, 1993.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%   S,      spot price
%   T:      time to maturity
%   gamma:  function parameter
%   H:      function parameter
%   X:      exercise price
%   r:      interest rate
%   b:      dividend  yield
%   sigma:  volatility
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% phi_1: input to Bjerkesund and Stensland (1993)
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------

sigma_sqr=sigma^2;
kappa = 2.0*b/sigma_sqr + 2.0*gamma - 1.0;
lambda = (-r + gamma * b + 0.5*gamma*(gamma-1.0)*sigma_sqr)*T; %// check this, says lambda in text
d1= - (log(S/H)+(b+(gamma-0.5)*sigma_sqr)*T)/(sigma*sqrt(T));
d2= - (log((X*X)/(S*H))+(b+(gamma-0.5)*sigma_sqr)*T)/(sigma*sqrt(T));
phi_1 = exp(lambda) * (S^gamma) * (normpdf(d1) - ((X/S)^kappa) * normpdf(d2));

