% This script generates paths from a Heston stochastic volatility process.  

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=.0;

Kappa=.6;  % 2*Kappa*Eta>Lambda^2;
Eta=.3^2;
Lambda=.25;

T=252*20;
dt=1/252;
J=2;

r=-.7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dB_1=sqrt(dt)*randn(J,T);
dB_2u=sqrt(dt)*randn(J,T);
dB_2=r*dB_1+sqrt(1-r^2)*dB_2u;

vt=Eta*ones(J,1);
v=[];
d_Xs=[];
vts=[];
for t=1:T
    dv=Kappa*(Eta-vt)*dt+ Lambda*sqrt(vt).*dB_2(:,t);
    dX=m*dt+sqrt(vt*dt).*dB_1(:,t);
    
    vt=vt+dv;
    
    vts=[vts vt];
    d_Xs=[d_Xs dX];
   
end
X=cumsum(d_Xs,2);

figure
subplot(2,1,1)
h3=plot(dt*[1:T],X(1,:),'k');
title('Heston process')
grid on

subplot(2,1,2)
h1=plot(dt*[1:T],sqrt(vts(1,:)));
title('CIR volatility')
grid on