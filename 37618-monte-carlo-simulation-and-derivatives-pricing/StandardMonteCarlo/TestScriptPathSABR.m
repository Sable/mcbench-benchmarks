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
T = 1;      % maturities

r = 0;                      % discount factors
d = 0;                              % dividends

titS = 'MC SABR - Asset';
titV =' MC SABR - Variance';

legend_base = 'Base scenario';

%% Specify the base model 
alpha = 0.2;                  % spot volatility  
beta = 0.5;                   % cev coefficient
rho = 0;                       % correlation of base parameter set
nu = 0.1;

%% Simulation parameters
NTime = 120; NSim = 1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
K1 = K(2:end);

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;


[PathS, PathV] = MC_SABR(S,r,d,T,alpha,beta,rho,nu,NTime,NSim,NBatches);
%% Changing alpha
alpha_low = 0.1;
alpha_high = 0.5;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_SABR(S,r,d,T,alpha_low,beta,rho,nu,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_SABR(S,r,d,T,alpha_high,beta,rho,nu,NTime,NSim,NBatches);


legend_low  = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS_low = calcreturns(PathS_low,0);
ReturnsS = calcreturns(PathS,0);
ReturnsS_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS_low, ReturnsS, ReturnsS_high, titS, legend_low, legend_base, legend_high);

%% Changing rho
rho_low = -0.8;
rho_high = 0.8;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_SABR(S,r,d,T,alpha,beta,rho_low,nu,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_SABR(S,r,d,T,alpha,beta,rho_high,nu,NTime,NSim,NBatches);
    

legend_low  = 'Changing \rho low';
legend_high = 'Changing \rho high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS_low = calcreturns(PathS_low,0);
ReturnsS = calcreturns(PathS,0);
ReturnsS_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS_low, ReturnsS, ReturnsS_high, titS, legend_low, legend_base, legend_high);

%% Changing nu
nu_low = 0.005;
nu_high = 0.2;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_SABR(S,r,d,T,alpha,beta,rho,nu_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_SABR(S,r,d,T,alpha,beta,rho,nu_high,NTime,NSim,NBatches);
    

legend_low  = 'Changing \nu low';
legend_high = 'Changing \nu high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS_low = calcreturns(PathS_low,0);
ReturnsS = calcreturns(PathS,0);
ReturnsS_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS_low, ReturnsS, ReturnsS_high, titS, legend_low, legend_base, legend_high);


clear;clc;
