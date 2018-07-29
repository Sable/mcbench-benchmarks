clear; close all; clc;
% this script illustrates the recursive computation of the ML estimators 
% of correlation matrix and the d.o.g. of a t copula with isotropic structure
% see A. Meucci (2008) "Estimation of Structured T-Copulas"
% available at www.symmys.com > Research > Working Papers


load DB_SwapParRates
X=Rates(2:end,:)-Rates(1:end-1,:);

% only first three eigendirections significant, the remaining dimensions isotropic
K=3; 

Tolerance=10^(-10);
[Nu,C]=StrucTMLE(X,K,Tolerance);

bar(eig(C))
