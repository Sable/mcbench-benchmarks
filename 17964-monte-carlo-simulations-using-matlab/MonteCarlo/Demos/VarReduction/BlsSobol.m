function [price, CI]  = blsSobol(S,E,r,T,sigma,nSims)
% 
%GetSobolVanillaPrice - Vanilla option pricing using simulation and Sobol
% generator
%
% Return the pice of a vanilla option and the standard deviation of the
% price simulated
%
% Inputs:
%   S   	- Current price of the underlying asset.
%
%   E        - Strike (i.e., exercise) price of the option.
%
%   r        - Annualized continuously compounded risk-free rate of return
%                 over the life of the option, expressed as a positive decimal
%                 number.
%
%   T        - Time to expiration of the option, expressed in years.
%
%   sigma    - Annualized asset price volatility (i.e., annualized standard
%                 deviation of the continuously compounded asset return),
%                 expressed as a positive decimal number.
%
%   
%   divYield  - Annualized continuously compounded yield of the underlying
%                 asset over the life of the option, expressed as a decimal
%                 number. If Yield is empty or missing. the default value is
%                 zero.
%
%                 For example, this could represent the dividend yield (annual
%                 dividend rate expressed as a percentage of the price of the
%                 security) or foreign risk-free interest rate for options
%                 written on stock indices and currencies, respectively.
%   nSims      - Number of Simulation used for the pricing
%   nSteps     - Number of time steps used to simulate
%  [SobolPrice,stdSobol] =   GetSobolVanillaPrice(S,E,r,T,sigma,divYield,nsim,nSteps);

Dt = T;

%Generate the random numbers using SOBOL sequences

% Sobol sequences have some zeros
% a common approach in the litterature is to suppress the 64 first points
% the sobol generator has been found on the web

P = sobolset(1);
SobolRandomNumbers = net(P,nSims);


% Sobol numbers are between 0 and  1
% We need to get a normal distribution from this pseudo uniform drawing

RandomNumbers = norminv(SobolRandomNumbers');
mat = exp( (r-sigma^2/2)*Dt + sigma*sqrt(Dt).*RandomNumbers  );
mat = cumprod(mat , 1);
mat = mat.*S;

% Discount and calculate the option price

V = exp(-r*T) * max(mat(end,:)-E , 0);
[price,VarParice,CI]= normfit(V);


