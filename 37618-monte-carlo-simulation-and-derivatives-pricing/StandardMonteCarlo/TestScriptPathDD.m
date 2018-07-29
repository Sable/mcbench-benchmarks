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

titS = 'Paths Displaced Diffusion Model';

legend_base = 'Base scenario';

%% Specify the base model 
sigma = 0.02;                  % instantanuous variance of base parameter set  
a_base = 5;                  % long term variance of base parameter set


%% Simulation parameters
NTime = 120; NSim = 1;          % MC parameter
NBatches = 1;                   % MC batch parameter
K = ones(NTime+1,1);            % init grid
K = T*cumsum(K)/(NTime+1);      % time grid
K1 = K(2:end);                  % time grid for returns

rstream = RandStream('mt19937ar','Seed',12345); % set the random stream
rstreamstate = rstream.State;                   % save state for later

PathS = MC_DD(S,r,d,T,sigma,a_base,NTime,NSim,NBatches);
%% Changing a
a_low = 0;
a_high = 10;

rstream.State = rstreamstate;
PathS_low = MC_DD(S,r,d,T,sigma,a_low,NTime,NSim,NBatches);
rstream.State = rstreamstate;
PathS_high = MC_DD(S,r,d,T,sigma,a_high,NTime,NSim,NBatches);
    
legend_low = 'Changing a low';
legend_high = 'Changing a high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS_low = calcreturns(PathS_low,0);
ReturnsS = calcreturns(PathS,0);
ReturnsS_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS_low, ReturnsS, ReturnsS_high, titS, legend_low, legend_base, legend_high);

