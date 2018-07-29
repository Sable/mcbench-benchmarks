% this script analyses the long-memory/autocorrelation features 
% of swap rate changes for different time steps

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all;

%%%%%%%% process inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=3;  % 1y 2y 5y 7y 10y 15y 30y

load DB_SwapParRates; 
Ind=find(Rates(:,n));
Data=Rates(Ind,n);   
Dates=Dates(Ind);
Name=Names{n};

%%%%%%%% analysis of jumps %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data=FilterJumps(Dates,Data,Name);

%%%%%%%% analysis of aggregation variance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AggregationVariance=[1 : 70];
Annualize_Lag=5;
NumSimulations=300;  
AnalyzeVarianceAggregation(Dates,Data,AggregationVariance,Annualize_Lag,NumSimulations,Name);

%%%%%%%% analysis of aggregation persistence %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AggregationPersistence=[1 : 30];
LagsSamplAutCorr=15;
Annualize_Lag=22;
AnalyzePersistence(Data,AggregationPersistence,LagsSamplAutCorr,Name);