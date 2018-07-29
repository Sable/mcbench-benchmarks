% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.


% Test script for illustration


% base scenario
t=0; T=1; 
f = 0.03; 
alpha = 0.075; 
beta = 0.5; 
nu = 0.1; 
rho = 0;

sabrdensity = @(x,y) psabr3(t,T,f,x,alpha,y,beta,nu,rho);

lcoeff = 1; ucoeff = 1;
lowerbound = f-lcoeff*f;
upperbound = f + ucoeff*f;

xvals = lowerbound:.0005:upperbound;

zvals1d = density1d(xvals,sabrdensity,0,1);

% change rho
rho = -.9;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dm = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dm)
rho = .9;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dp = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dp)
figure('Color',[1 1 1]);
hold on;
plot(xvals,zvals1dm,'r','LineWidth',2); plot(xvals,zvals1d,'b','LineWidth',2); plot(xvals,zvals1dp,'g','LineWidth',2);
title('Plot of SABR densities for different \rho')
xlabel('0\leq x \leq .1')
ylabel('density')
legend('\rho=-0.9','\rho=0','\rho=0.9')
hold off;
rho = 0.0;

% change nu
nu = 0.05;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dm = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dm)
nu = .15;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dp = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dp)
figure('Color',[1 1 1]);
hold on;
plot(xvals,zvals1dm,'r','LineWidth',2); plot(xvals,zvals1d,'b','LineWidth',2); plot(xvals,zvals1dp,'g','LineWidth',2);
title('Plot of SABR densities for different \nu')
xlabel('0\leq x \leq .1')
ylabel('density')
legend('\nu=0.05','\nu=0.4','\nu=0.2')
hold off;
nu = 0.1;

% change beta
beta = 0.4;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dm = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dm)
beta = 0.8;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dp = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dp)
figure('Color',[1 1 1]);
hold on;
plot(xvals,zvals1dm,'r','LineWidth',2); plot(xvals,zvals1d,'b','LineWidth',2); plot(xvals,zvals1dp,'g','LineWidth',2);
title('Plot of SABR densities for different \beta')
xlabel('0\leq x \leq .1')
ylabel('density')
legend('\beta=0.4','\beta=0.5','\beta=0.6')
hold off;
beta = 0.5;

% change alpha
alpha = 0.05;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dm = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dm)
alpha = .1;
sabrdensity = @(x,y) psabr30(t,T,f,x,alpha,y,beta,nu,rho);
zvals1dp = density1d(xvals,sabrdensity,0,1);
intdensity(xvals,zvals1dp)
figure('Color',[1 1 1]);
hold on;
plot(xvals,zvals1dm,'r','LineWidth',2); plot(xvals,zvals1d,'b','LineWidth',2); plot(xvals,zvals1dp,'g','LineWidth',2);
title('Plot of SABR densities for different \alpha')
xlabel('0\leq x \leq .1')
ylabel('density')
legend('\alpha=0.05','\alpha=0.075','\alpha=0.1')
hold off;
alpha = 0.075;