% This script analyses the volatility clustering features of stock returns 

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clc; clear; close all;

load DB_IBM

X=diff(log(Price));
% filter
Who=find(abs(X)>.2);
X(Who)=[];
Dates(Who)=[];

IIDAnalysis(Dates(2:end),X)
set(gca,'xlim',[-.08 .08],'ylim',[-.08 .08])

IIDAnalysis(Dates(2:end),X.^2)
set(gca,'xlim',[-.002 .005],'ylim',[-.002 .005])

break
% leverage
Window=4;
T=length(X);
for t=Window : (T-Window)
    Rets(t)=X(t);
    Var(t)=var(X(t-Window/2:t+Window/2));
end
figure
plot(Rets,Var,'.')