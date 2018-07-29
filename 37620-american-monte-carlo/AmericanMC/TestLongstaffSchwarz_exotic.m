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

% Script for testing american exotic option prices with MC

Nr = 13;       % exercise possibilities 
NSim = 10000;    % number of simulations
S0 = 100;      % spot price
K = 100;       % strike price

ScaleFactor = 156;

T=1;
dt = T/Nr; %Intervalllänge
r = 0.06;      % zero rate
d = 0.0;         % dividend yield
sigma = 0.15;
type = -1;

S0 = S0 * exp(-d*T);

S0 = S0 / ScaleFactor;
K = K / ScaleFactor;

gp = @(x,y,z) getPathsAsian(x, r, sigma, dt, y, z);   % Paths
pay = @(x) putpayoff(x,K);                      % Payoff

[S,M] = gp(S0, NSim, Nr);

h = [S(:,1) pay(M(:,2:end))];
%h = pay(M(:,2:end));

df = exp(-r*dt) * ones(Nr,1);   % discounts for all time points

B = @(x,y) {{ones(length(x),1)  x  x.^2  y  y.^2  x.*y  (x.^2).*y  x.*(y.^2)}}; % choose the basis functions



fprintf('Tree Value:');
% binomial cox ross rubinstein tree for comparison
BinTree_A(S0, K, r, T, sigma, 20, type)*ScaleFactor

fprintf('Asian Option:');
% Longstaff Schwarz - Arithmetic Asian option
[price, se, low, high] ...
    = LongstaffSchwartz_M(S, M, 3, h, df, B, Nr, NSim, 0.99);
price * ScaleFactor

RC = RegCoeff_M(S, M, 3, h, df, B, 8, Nr);

[price, se, low, high] = LongstaffSchwartz_M2(S, M, 3, h, df, RC, B, Nr, NSim, 0.99);
price * ScaleFactor


Bki = @(x) {{ones(length(x),1)  x  x.^2 }}; % choose the basis functions

Barrier = 95;
Barrier = Barrier / ScaleFactor;

fprintf('Tree Value:');
price = BinTree_KI(S0, K, r, T, sigma, 20, Barrier, type);
price * ScaleFactor

fprintf('Barrier Options:');
payki = @(x) knockinpayoff(x,K,Barrier,type);
hki = payki(S(:,2:end));
% Longstaff Schwarz - Barrier option
[price, se, low, high] = LongstaffSchwartz(S, hki, df, Bki, Nr, NSim, 0.99);
price * ScaleFactor

