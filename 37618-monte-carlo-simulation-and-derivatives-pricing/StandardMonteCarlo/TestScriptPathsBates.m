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

titS = 'MC Bates - Asset';
titV =' MC Bates - Variance';

legend_base = 'Base scenario';

%% Specify the base model 
vInst = 0.04;                  % instantanuous variance of base parameter set  
vLong = 0.04;                  % long term variance of base parameter set
kappa = 0.2;                   % mean reversion speed of variance of base parameter set
omega = 0.1;                   % volatility of variance of base parameter set
rho = 0;                       % correlation of base parameter set
sigj = 0.25;
muj = 0.2;
lambda = 0.5;

%% Simulation parameters
NTime = 750; NSim = 1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
%rand('seed', 1);
UV = rand(1,2*NTime);              % precompute all randoms
K1 = K(2:end);

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;

[PathS, PathV] = MC_QE_j(S,r,d,T,vInst,vLong,...
    kappa,omega,rho,muj,sigj,lambda,NTime,NSim,NBatches);
%MC_Bates_path(S,r,d,T,vInst,vLong,kappa,omega,rho,muj,sigj,lambda,UV);
%% Changing vInst
muj_low = 0.05;
muj_high = 0.5;

    PathS_low  = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj_low,sigj,lambda,NTime,NSim,NBatches);
    PathS_high = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj_high,sigj,lambda,NTime,NSim,NBatches);
    
legend_low = 'Changing \mu_j low';
legend_high = 'Changing \mu_j high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);
%% Changing vLong
sigj_low = 0.1;
sigj_high = 0.5;
    

    PathS_low = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj,sigj_low,lambda,NTime,NSim,NBatches);
    PathS_high = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj,sigj_high,lambda,NTime,NSim,NBatches);

    legend_low  = 'Changing \sigma_j low';
    legend_high = 'Changing \sigma_j high';
    
createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

%% Changing kappa
lambda_low = 0.2;
lambda_high = 0.8;

    PathS_low = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj,sigj,lambda_low,NTime,NSim,NBatches);
    PathS_high = MC_QE_j(S,r,d,T,vInst,vLong,kappa,omega,rho,muj,sigj,lambda_high,NTime,NSim,NBatches);


legend_low  = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

