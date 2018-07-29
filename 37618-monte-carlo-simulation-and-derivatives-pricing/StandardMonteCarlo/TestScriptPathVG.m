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

titS = 'MC Variance Gamma';

legend_base = 'Base scenario';

C = 4.3574;
G = 5.1704;                            % CEV exponent base scenario
M = 5.6699;


%% Simulation parameters
NTime = 120; NSim =1; NBatches = 1;
K = ones(NTime+1,1);
K = T*cumsum(K)/(NTime+1);
K1 = K(2:end);

rstream = RandStream('mt19937ar','Seed',12345);
rstreamstate = rstream.State;

PathS = MC_VG_CGM(S,r,d,T,C,G,M,NTime,NSim,NBatches);
%% Changing C
C_low = .5;
C_high = 5;

    rstream.State = rstreamstate;
    PathS_low = MC_VG_CGM(S,r,d,T,C_low,G,M,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_VG_CGM(S,r,d,T,C_high,G,M,NTime,NSim,NBatches);
    
legend_low = 'Changing C low';
legend_high = 'Changing C high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);

%% Changing G
G_low = 5;
G_high =6.5;

    rstream.State = rstreamstate;
    PathS_low = MC_VG_CGM(S,r,d,T,C,G_low,M,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_VG_CGM(S,r,d,T,C,G_high,M,NTime,NSim,NBatches);
    
legend_low = 'Changing G low';
legend_high = 'Changing G high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);

%% Changing  M
M_low = 5;
M_high = 6;


    rstream.State = rstreamstate;
    PathS_low = MC_VG_CGM(S,r,d,T,C,G,M_low,NTime,NSim,NBatches);
    rstream.State = rstreamstate;
    PathS_high = MC_VG_CGM(S,r,d,T,C,G,M_high,NTime,NSim,NBatches);
    
legend_low = 'Changing M low';
legend_high = 'Changing M high';

createfigure_path(K,PathS_low, PathS, PathS_high, titS, legend_low, legend_base, legend_high);

% calculate the returns
ReturnsS1_low = calcreturns(PathS_low,0);
ReturnsS1 = calcreturns(PathS,0);
ReturnsS1_high = calcreturns(PathS_high,0);

createfigure_returns(K1,ReturnsS1_low, ReturnsS1, ReturnsS1_high, titS, legend_low, legend_base, legend_high);

clear; clc;

