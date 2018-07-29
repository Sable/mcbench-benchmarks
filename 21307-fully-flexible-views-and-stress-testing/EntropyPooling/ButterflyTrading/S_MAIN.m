% This script performs the butterfly-trading case study for the 
% Entropy-Pooling approach by Attilio Meucci, as it appears in 
% "A. Meucci - Fully Flexible Views: Theory and Practice -
% The Risk Magazine, October 2008, p 100-106"
% available at www.symmys.com > Research > Working Papers

% Code by A. Meucci, September 2008
% Last version available at www.symmys.com > Teaching > MATLAB

clear; close all; clc; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load panel X of joint factors realizations and vector p of respective probabilities
% In real life, these are provided by the estimation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 'FactorsDistribution.mat'; % 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load current prices, deltas and other analytics of the securities 
% In real life, these are provided by data provider
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 'ButterfliesAnalytics.mat'; % 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map factors scenarios into p&l scenarios at the investment horizon
% In real life with complex products, the pricing can be VERY costly 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PnL = HorizonPricing(Butterflies,X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute mean-risk efficient frontier based on prior market distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Options.Quant=.95;  % quantile level for CVaR
Options.NumPortf=30; % number of portfolios in efficient frontier
Options.FrontierSpan=[.1 .8]; % range of normalized exp.vals. spanned by efficient frontier
Options.DeltaNeutral=1; % 1 = portfolio is delta neutral, 0 = no constraint
Options.Budget=0; % initial capital
Options.Limit=10000; % limit to absolute value of each investment

[Exp,SDev,CVaR,w] = LongShortMeanCVaRFrontier(PnL,p,Butterflies,Options);
%PlotEfficientFrontier(Exp,CVaR,w)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process views (this is the core of the Entropy Pooling approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p_1 = ViewImpliedVol(X,p); 
p_2 = ViewRealizedVol(X,p);
p_3 = ViewCurveSlope(X,p);

% assign confidence to the views and pool opinions
c=[.35 .2 .25 .2]; % sum of weights should be equal 1
p_=[p p_1 p_2 p_3]*c';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute mean-risk efficient frontier based on posterior market distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Exp_,SDev_,CVaR_,w_] = LongShortMeanCVaRFrontier(PnL,p_,Butterflies,Options);
%PlotEfficientFrontier(Exp_,CVaR_,w_)