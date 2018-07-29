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

titS = 'MC Heston - Asset';
titV =' MC Heston - Variance';

legend_base = 'Base scenario';

%% Specify the base model 
vInst = 0.04;                  % instantanuous variance of base parameter set  
vLong = 0.04;                  % long term variance of base parameter set
kappa = 0.2;                   % mean reversion speed of variance of base parameter set
omega = 0.1;                   % volatility of variance of base parameter set
rho = 0;                       % correlation of base parameter set


%% Simulation parameters
NTime = 120; NSim = 1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);

K1 = K(2:end);

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;

[PathS, PathV] = MC_QE(S,r,d,T,vInst,vLong,kappa,omega,rho,NTime,NSim,NBatches);
%% Changing vInst
vInst_low = 0.01;
vInst_high = 0.08;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_QE(S,r,d,T,vInst_low,vLong,kappa,omega,rho,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_QE(S,r,d,T,vInst_high,vLong,kappa,omega,rho,NTime,NSim,NBatches);
    
legend_low = 'Changing V(0) low';
legend_high = 'Changing V(0) high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing vLong
vLong_low = 0.01;
vLong_high = 0.08;
    

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_QE(S,r,d,T,vInst,vLong_low,kappa,omega,rho,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_QE(S,r,d,T,vInst,vLong_high,kappa,omega,rho,NTime,NSim,NBatches);

    legend_low  = 'Changing \Theta low';
    legend_high = 'Changing \Theta high';
    
createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing kappa
kappa_low = 0.005;
kappa_high = 0.5;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_QE(S,r,d,T,vInst,vLong,kappa_low,omega,rho,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_QE(S,r,d,T,vInst,vLong,kappa_high,omega,rho,NTime,NSim,NBatches);


legend_low  = 'Changing \kappa low';
legend_high = 'Changing \kappa high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing nu
omega_low = 0.05;
omega_high = 0.3;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_QE(S,r,d,T,vInst,vLong,kappa,omega_low,rho,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_QE(S,r,d,T,vInst,vLong,kappa,omega_high,rho,NTime,NSim,NBatches);
    

legend_low  = 'Changing \nu low';
legend_high = 'Changing \nu high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

%% Changing rho
rho_low = -0.8;
rho_high = 0.8;

    rstream.State = rstreamstate;
    [PathS_low, PathV_low] = MC_QE(S,r,d,T,vInst,vLong,kappa,omega,rho_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    [PathS_high PathV_high] = MC_QE(S,r,d,T,vInst,vLong,kappa,omega,rho_high,NTime,NSim,NBatches);
    

legend_low  = 'Changing \rho low';
legend_high = 'Changing \rho high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
createfigure_path(K,PathV_low, PathV, PathV_high, titV, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
clear;clc;
