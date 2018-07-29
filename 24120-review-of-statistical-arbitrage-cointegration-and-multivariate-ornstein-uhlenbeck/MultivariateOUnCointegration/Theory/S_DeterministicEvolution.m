% this script animates the evolution of the determinstic component of an OU process 
% see A. Meucci (2009) 
% "Review of Statistical Arbitrage, Cointegration, and Multivariate Ornstein-Uhlenbeck"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input parameters of multivariate OU process
K=1;
J=1;

x0=1*ones(K+2*J,1);

Mu=0*rand(K+2*J,1);

A=[1 0 0
   0 1 0
   0 0 1];

    ls=-10;
gs=10;
os=100;

ts=.001*[0:300];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process inputs
Gamma=diag(ls);
for j=1:J
    G=[gs(j)  os(j)
           -os(j) gs(j)];
    Gamma=blkdiag(Gamma,G);
end
Theta=A*Gamma*inv(A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process dynamics 
S=0*rand(K+2*J,K+2*J);
Sigma=S*S';
for j=1:length(ts)
    t=ts(j);
    X_t(:,j)=OUstep(x0',t,Mu,Theta,Sigma);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
figure
subplot(3,1,1)
plot(ts,X_t(1,:))
xlim([ts(1) ts(end)])
subplot(3,1,2)
plot(ts,X_t(2,:))
xlim([ts(1) ts(end)])
subplot(3,1,3)
plot(ts,X_t(3,:))
xlim([ts(1) ts(end)])

figure
t = 0:pi/50:10*pi;
AnimateTrajectory(X_t(1,:),X_t(2,:),X_t(3,:))
