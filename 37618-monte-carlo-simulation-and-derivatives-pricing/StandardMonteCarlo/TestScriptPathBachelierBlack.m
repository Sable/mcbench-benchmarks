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
%% Parameters
S = 100;                                   % Spot prices
T = 5;      % maturities

r = 0;                      % discount factors
d = 0;                              % dividends

titS = 'Paths Black-Scholes Model';
titV =' Paths Bachelier Model';

legend_base = 'Base scenario';

%% Specify the base model 
sigmaB_base = 0.02;                  % instantanuous variance of base parameter set  
sigmaBS_base = 0.2;                  % long term variance of base parameter set


%% Simulation parameters
NTime = 130;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
Z = randn(1,NTime);              % precompute all randoms


[PathS1, PathS2] = MC_B_path(S,r,d,sigmaB_base,sigmaBS_base,T,Z);
%% Changing sigma
sigmaB_low = 0.01;
sigmaB_high = 0.003;
sigmaBS_low = 0.05;
sigmaBS_high = 0.4;

    [PathS1_low, PathS2_low] = MC_B_path(S,r,d,sigmaB_low,sigmaBS_low,T,Z);
    [PathS1_high PathS2_high] = MC_B_path(S,r,d,sigmaB_high,sigmaBS_high,T,Z);
    
legend_low = 'Changing \sigma low';
legend_high = 'Changing \sigma high';

createfigure_path(K,PathS1_low, PathS1, PathS1_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathS2_low, PathS2, PathS2_high, titV, legend_low, legend_base, legend_high);
