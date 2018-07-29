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
S = 100;    % Spot prices
T = 5;      % maturities
r = 0;      % discount factors
d = 0;      % dividends

titS = 'MC NIG - Asset Paths';

legend_base = 'Base scenario';

alpha = 10; % parameter
beta = 0;   % parameter
delta = 1;  % parameter
mu = 0;     % parameter


%% Simulation parameters
NTime = 120; NSim = 1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
K1 = K(2:end);

a_par = T/NTime;                         % parameter of IG distribution
b_par = delta*sqrt(alpha^2-beta^2);   % parameter of IG distribution
theta = a_par/b_par;                  
chi = a_par^2;

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;

PathS = MC_NIG(S,r,d,T,alpha,beta,delta,NTime,NSim,NBatches);
%% Changing lambda
alpha_low = 5;
alpha_high = 15;
    
    rstream.State = rstreamstate;
    PathS_low = MC_NIG(S,r,d,T,alpha_low,beta,delta,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_NIG(S,r,d,T,alpha_high,beta,delta,NTime,NSim,NBatches);
    
legend_low = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing kappa
beta_low = -2;
beta_high = 2;

    rstream.State = rstreamstate;
    PathS_low = MC_NIG(S,r,d,T,alpha,beta_low,delta,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_NIG(S,r,d,T,alpha,beta_high,delta,NTime,NSim,NBatches);
    
legend_low = 'Changing \beta low';
legend_high = 'Changing \beta high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);
%% Changing eta
delta_low = 0.25;
delta_high = 1.75;

    rstream.State = rstreamstate;
    PathS_low = MC_NIG(S,r,d,T,alpha,beta,delta_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_NIG(S,r,d,T,alpha,beta,delta_high,NTime,NSim,NBatches);
    
legend_low = 'Changing \delta low';
legend_high = 'Changing \delta high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);

clear; clc;