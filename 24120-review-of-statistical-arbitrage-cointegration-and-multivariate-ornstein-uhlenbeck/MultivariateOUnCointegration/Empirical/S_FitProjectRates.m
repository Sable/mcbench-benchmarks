% this script fits the swap rates dynamics to a multivariate Ornstein-Uhlenbeck process 
% and computes and plots the estimated future distribution
% see A. Meucci (2009) 
% "Review of Statistical Arbitrage, Cointegration, and Multivariate Ornstein-Uhlenbeck"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

%%%%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TimeStep=5; % select time interval (days)
Taus=[1/252 5/252 1/12 .5 1 2 10]; % select horizon projection (years)
Pick=[2 3];

%%%%%% estimation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load DB_SwapParRates
StepRates=Rates(1:TimeStep:end,:);
[Mu,Theta,Sigma]=FitOU(StepRates,TimeStep/252);

for s=1:length(Taus)

    RGB=.6*[rand rand rand]';
    tau=Taus(s);
   
    %%% projection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %x_T=Mu;
    x_T=Rates(end,:);
    [X_tau,Mu_tau,Sigma_tau]=OUstep(x_T,tau,Mu,Theta,Sigma);

    %%% plot  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % historical observations
    hold on
    h5=plot(Rates(:,Pick(1)),Rates(:,Pick(2)),'.');
    set(h5,'color',.6*[1 1 1],'markersize',4)

%     % current observation
%     hold on
%     h1=plot(x_T(Pick(1)),x_T(Pick(2)),'.');

%     % horizon location
%     hold on
%     h4=plot(Mu_tau(Pick(1)),Mu_tau(Pick(2)),'.');
%     set(h4,'color',RGB,'markersize',5)

    % horizon dispersion ellipsoid
    hold on
    h3=TwoDimEllipsoid(Mu_tau(Pick),Sigma_tau(Pick,Pick),1,0,0);
    set(h3,'color',RGB,'linewidth',1);

    xlabel(Names{Pick(1)})
    ylabel(Names{Pick(2)})
    %legend([h1 h3 h5],'current','horizon','historical','location','best');
end
grid off