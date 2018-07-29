% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



clear; clc;
% Parameters
S = 100;    % Spot prices
T = 1;      % maturities
K = 100;    % Strike price

r = 0;      % discount factors
d = 0;      % dividends

% Specify the model 
vInst = 0.04;      % instantanuous variance of base parameter set  
vLong = 0.04;      % long term variance of base parameter set
kappa = 0.25;      % mean reversion speed of variance of base parameter set
omega = 0.5;       % volatility of variance of base parameter set
rho = -0.6;        % correlation of base parameter set


% Simulation parameters
NTime = 1; NSim = 10000;

% method 1 creating paths and passing to payoff
[pathS, pathV] = MC_HestonFullSampling(S,r,T, ...
    vInst,vLong,kappa,omega,rho,NSim,NTime);
CallPut(pathS,100,1)                % Evaluate the payoff

% method 2 essentially the same but now with payoff in function
HestonFullSampling(S,K,r,T,kappa,vLong,omega,rho,vInst,NSim,NTime)

% price calculated using fft
CallPricingFFT('Heston',10,S,K,T,r,d,vInst, vLong, kappa, omega, rho)


