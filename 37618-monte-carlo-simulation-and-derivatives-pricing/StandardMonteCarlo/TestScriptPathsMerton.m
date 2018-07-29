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
T = 3;      % maturities

r = 0;                      % discount factors
d = 0;                              % dividends

titS = 'MC Merton - Asset';

legend_base = 'Base scenario';

%% Specify the base model 
sigma = 0.1;
sigj = 0.25;
muj = 0.2;
lambda = 1;

%% Simulation parameters
NTime = 180; NSim = 1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
%rand('seed', 1);
UV = rand(1,NTime);              % precompute all randoms
K1 = K(2:end);

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;

[PathS] = MC_M(S,r,d,T,sigma,muj,sigj,lambda,NTime,NSim,NBatches);
%% Changing vInst
muj_low = 0.05;
muj_high = 0.5;
    rstream.State = rstreamstate;
    [PathS_low] = MC_M(S,r,d,T,sigma,muj_low,sigj,lambda,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high] = MC_M(S,r,d,T,sigma,muj_high,sigj,lambda,NTime,NSim,NBatches);
    
legend_low = 'Changing \mu_j low';
legend_high = 'Changing \mu_j high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing vLong
sigj_low = 0.1;
sigj_high = 0.5;
    
    rstream.State = rstreamstate;
    [PathS_low] = MC_M(S,r,d,T,sigma,muj,sigj_low,lambda,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high] = MC_M(S,r,d,T,sigma,muj,sigj_high,lambda,NTime,NSim,NBatches);

    legend_low  = 'Changing \sigma_j low';
    legend_high = 'Changing \sigma_j high';
    
createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing kappa
lambda_low = 0.2;
lambda_high = 2;
    
    rstream.State = rstreamstate;
    [PathS_low] = MC_M(S,r,d,T,sigma,muj,sigj,lambda_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high] = MC_M(S,r,d,T,sigma,muj,sigj,lambda_high,NTime,NSim,NBatches);


legend_low  = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
