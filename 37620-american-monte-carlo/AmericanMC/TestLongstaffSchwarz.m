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

% Script for testing american option pricing using MC

Nr = 13;       % exercise possibilities 
NSim = 10000;    % number of simulations
NSSim = 100;
S0 = 100;      % spot price
K = 100;       % strike price

ScaleFactor = 150;

T=.25;
dt = T/Nr; %Intervalllänge
r = 0.06;      % zero rate
d = 0.0;         % dividend yield
sigma = 0.15;
type = -1;

S0 = S0 * exp(-d*T);

S0 = S0 / ScaleFactor;
K = K / ScaleFactor;

gp = @(x,y,z) getPaths(x, r, sigma, dt, y, z);   % Paths
pay = @(x) putpayoff(x,K);                      % Payoff

S = gp(S0, NSim, Nr);
S2 = gp(S0, NSim/10,Nr);
h = pay(S(:,2:end));
h2 = pay(S2(:,2:end));

df = exp(-r*dt) * ones(Nr,1);   % discounts for all time points

B = @(x) {{ones(length(x),1) x x.^2}}; % choose the basis functions
Nb = 3;

fprintf('Tree price:');
% binomail cox ross rubinstein tree for comparison
BinTree_CP(S0*ScaleFactor, K*ScaleFactor, r, T, sigma, 100, type)

fprintf('Regression:');
% Longstaff Schwarz - regression and pricing at once
[price, se, low, high] ...
    = LongstaffSchwartz(S, h, df, B, Nr, NSim, 0.99);
[price * ScaleFactor, se, price * ScaleFactor-se*norminv(.99), ...
    price * ScaleFactor+se*norminv(.99)]
% 
% 
% Longstaff Schwarz - Separation regression and pricing
RC = RegCoeff(S2, h2, df, B, Nb, Nr);
[price, se, low, high] ...
    = LongstaffSchwartz_2(S, h, df, B, RC, Nr, NSim, 0.99);
[price * ScaleFactor, se, price * ScaleFactor - norminv(.99) * se, ...
    price * ScaleFactor + se*norminv(.99)]
lb = price;

fprintf('Upper Bounds:');
NSSim = 100;
% upper bound 1 - Broadie
[lower, upper] = UpperBound1(S, h, df, B, RC, lb, Nr, NSim, NSSim, gp, pay);
[lower * ScaleFactor, upper * ScaleFactor]

% upper bound 2 - Glasserman
[lower, upper] = UpperBound2(S, h, df, B, Nb, Nr, NSim, NSSim, gp, pay);
[lower * ScaleFactor, upper * ScaleFactor]

% upper bound 3 - Broadie
[lower, upper] = UpperBound3(S, h, df, B, RC, Nr, NSim, NSSim, gp, pay);
[lower * ScaleFactor, upper * ScaleFactor]

fprintf('Policy Iteration:');
% Policy Iteration 1 -still alive europeans initial stopping rule
price = PIter_E(S, h, K, r, T, sigma, Nr, NSim, NSSim, type, gp, pay);
price * ScaleFactor

% Policy Iteration 2 - regression for initial stopping rule
price = PIter_R(S, h, r, T, Nr, B, Nb, NSim, NSSim, gp, pay);
price * ScaleFactor