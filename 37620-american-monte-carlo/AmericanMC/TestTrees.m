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

% Script for testing different tree methods for pricing Americans

Nr = 13;       % exercise possibilities 
NSim = 1000;    % number of simulations
S0 = 100;      % spot price
K = 100;       % strike price

ScaleFactor = 156;

T=1;
dt = T/Nr; %Intervalllänge
r = 0.06;      % zero rate
d = 0.0;         % dividend yield
sigma = 0.15;
type = 1;       % a put

S0 = S0 * exp(-d*T);

S0 = S0 / ScaleFactor;
K = K / ScaleFactor;

Barrier = 95;
Barrier = Barrier / ScaleFactor;


fprintf('Tree Values:');
% binomial cox ross rubinstein tree for comparison
tic;
BinTree_CP(S0, K, r, T, sigma, 20, type)*ScaleFactor
toc
tic;
BinTree_A(S0, K, r, T, sigma, 20, type)*ScaleFactor
toc
tic;
BinTree_KI(S0, K, r, T, sigma, 20, Barrier, type)* ScaleFactor
toc

