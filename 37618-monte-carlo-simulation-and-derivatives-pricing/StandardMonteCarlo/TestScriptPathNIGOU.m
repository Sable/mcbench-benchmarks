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
S = 100;                        % spot prices
T = 5;                          % maturities
r = 0;                          % risk free rate
d = 0;                          % dividend yield

titS = 'MC NIG OU';             % diagram title
legend_base = 'Base scenario';  % legend entry

alpha = .6;                      % alpha NIG
beta = -.5;                      % beta NIG
delta = .2;                      % delta NIG
mu = 0;                         % mu NIG
lambda = 1;                     % lambda GOU clock
a = 1;                          % a GOU clock
b = 1;                          % b GOU clock

%% Simulation parameters
NTime = 120; NSim = 1;          % MC parameter
NBatches = 1;                   % MC batch parameter
K = ones(NTime+1,1);            % init grid
K = T*cumsum(K)/(NTime+1);      % time grid
K1 = K(2:end);                  % time grid for returns

rstream = RandStream('mt19937ar','Seed',12345); % set the random stream
rstreamstate = rstream.State;                   % save state for later

PathS = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda,a,b,NTime,NSim,NBatches);

%%Changing lambda
lambda_low = .5;
lambda_high = 2;

rstream.State = rstreamstate;
PathS_low = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda_low,a,b,NTime,NSim,NBatches);
rstream.State = rstreamstate;
PathS_high = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda_high,a,b,NTime,NSim,NBatches);
  
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, ...
    titS, legend_low, legend_base, legend_high);

%% Changing a
a_low = .5;
a_high = 2;

rstream.State = rstreamstate;
PathS_low = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda,a_low,b,NTime,NSim,NBatches);
rstream.State = rstreamstate;
PathS_high = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda,a_high,b,NTime,NSim,NBatches);
  
legend_low = 'Changing a low';
legend_high = 'Changing a high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, ...
    titS, legend_low, legend_base, legend_high);

%% Changing b
b_low = .5;
b_high = 2;


    rstream.State = rstreamstate;
    PathS_low = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda,a,b_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_NIGGOU(S,r,d,T,alpha,beta,delta,lambda,a,b_high,NTime,NSim,NBatches);
  
legend_low = 'Changing b low';
legend_high = 'Changing b high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, ...
    titS, legend_low, legend_base, legend_high);

clear; clc;