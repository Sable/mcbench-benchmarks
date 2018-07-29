% This script generates paths of a subordinated Brownian motion with CIR-induced subordinator

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=.1;
s=.4;

Kappa=.6;  % 2*Kappa*T_dot>Lambda^2;
T_dot=1;
Lambda=1;
T=252*10;
dt=1/252;
J=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dB=sqrt(dt)*randn(J,T);
yt=1;
y=[];
d_Xs=[];
d_taus=[];
for t=1:T
    dy=Kappa*(T_dot-yt)*dt+ Lambda*sqrt(yt).*dB(:,t);
    yt=max(yt+dy,10^(-10));
    
    d_tau=yt*dt;
    dX=normrnd(m*d_tau,s*sqrt(d_tau));

    y=[y yt];
    d_taus=[d_taus d_tau];
    d_Xs=[d_Xs dX];

end
tau=cumsum(d_taus,2);
X=cumsum(d_Xs,2);

figure
subplot(2,1,1)
h3=plot(dt*[1:T],X(1,:),'k');
title('CIR-subordinated process')
grid on

subplot(2,1,2)
h1=plot(dt*[1:T],y(1,:));
hold on 
h2=plot(dt*[1:T],tau(1,:),'r');
grid on
legend('CIR','stoch. time','location','northwest')