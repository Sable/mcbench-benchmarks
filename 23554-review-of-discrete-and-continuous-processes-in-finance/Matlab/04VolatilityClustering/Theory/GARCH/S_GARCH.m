% This script generates paths from a GARCH process.  

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

T=252*10; % NumSamples
N=1;   % NumPaths
dt=1/252;

m=0;
s=.2
VarPersist=.5;
VarInnov=.45;

Spec = garchset('P',1,'Q',1,'C',m*dt,'K',s^2*dt,'GARCH',VarPersist,'ARCH',VarInnov); 
[eps, sig, X] = garchsim(Spec,T, N);

figure

subplot(2,1,1)
plot(dt*[1:T],cumsum(X(:,1)))
grid on 
title('process')

%subplot(3,1,2)
plot(dt*[1:T],eps(:,1))
grid on 
title('shocks')

subplot(2,1,2)
plot(dt*[1:T],sig(:,1))
grid on 
title('volatility')

