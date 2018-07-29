% This script performs ranking allocation using the 
% Entropy-Pooling approach by Attilio Meucci, as it appears in 
% "A. Meucci - Fully Flexible Views: Theory and Practice -
% The Risk Magazine, October 2008, p 100-106"
% available at www.symmys.com > Research > Working Papers

% Code by A. Meucci, September 2008
% Last version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load panel X of joint returns realizations and vector p of respective probabilities
% In real life, these are provided by the estimation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 'ReturnsDistribution.mat'; % 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute and plot efficient frontier based on prior market distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Options.NumPortf=20; % number of portfolios in efficient frontier
Options.FrontierSpan=[.3 .9]; % range of normalized exp.vals. spanned by efficient frontier

[e,s,w,M,S] = EfficientFrontier(X,p,Options);
PlotResults(e,s,w,M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process ordering information (this is the core of the Entropy Pooling approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the expected return of each entry of Lower is supposed to be smaller than respective entry in Upper
Lower=[4];  
Upper=[3];
p_ = ViewRanking(X,p,Lower,Upper); 

%confidence
c=.5; 
p_=(1-c)*p+c*p_;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute and plot efficient frontier based on posterior market distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[e_,s_,w_,M_,S_] = EfficientFrontier(X,p_,Options);
PlotResults(e_,s_,w_,M_,Lower,Upper)
