% this file fits an AR(1) process to swap rate changes for different time steps

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

TimeSteps=[1 : 22]; % select time interval (days)
PickRate=3;  % select node on the curve: 1:'1y', 2:'2y', 3:'5y', 4:'7y', 5:'10y', 6:'15y',7:'30y'
load DB_SwapParRates

for s=1:length(TimeSteps)
    TimeStep=TimeSteps(s);
    StepRates=Rates(1:TimeStep:end,PickRate); 
    [m,theta,v_tau,b]=FitOU(StepRates,TimeStep/252);
    
    hold on
    plot(TimeStep,b,'.')
    grid on
end