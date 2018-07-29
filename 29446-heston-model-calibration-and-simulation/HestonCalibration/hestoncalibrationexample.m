%Author: Moeti Ncube

%Comments: This code calibrates the heston model to any dataset of the form
%of the marketdata.txt file. It also simulates the heston model given the
%optimized parameters.

%Marketdata=[strike, maturity,impvol,time till expiry]

%Strike: Strike price of options
%Maturity: (1=Prompt month, 2=Prompt month+1,...)
%Impvol: Market Implied vol
%Time till expiry: Days until option expires

clear all

global impvol; global strike; global T; global F0; global r;

%Initial Parameter Guess for Hestion Model
%V(1), Kappa, Theta, Vol of Volatility (sig), Correlation (rho)
x0=[.5,.5,.5,.05,.5];
%Constraints (Lower and Upper bounds on Parameters)
lb = [0, 0, 0, 0, -.9];
ub = [1, 100, 1, .5, .9];
%Number of MCMC simulations of Heston Model
M=50000;
%Current Asset Price (Prompt Month Price) and Interest rate
F0=1250; r=0;

load marketdata.txt

T=marketdata(:,4)/365;
strike=marketdata(:,1);
impvol=marketdata(:,3);

%Optimization
x = lsqnonlin(@costf2,x0,lb,ub);

for k=1:length(T);
%Initial asset price
shes(1)=F0;
%Number of Time Steps,time step size
N=round(T(k)/(1/360));dt=T(k)/N;

%Heston Parameters
vhes(1)=x(1);  kappa=x(2); theta=x(3); vsigma=x(4);rho=x(5); simPath=0;

%Simulation of Heston Model
for i = 1:M  
for j=1:N
%heston model
r1 = randn;
r2 = rho*r1+sqrt(1-rho^2)*randn;   
shes(j+1)=shes(j)*exp((-0.5*vhes(j))*dt+sqrt(vhes(j))*sqrt(dt)*r1);
vhes(j+1)=vhes(j)*exp(((kappa*(theta - vhes(j))-0.5*vsigma^2)*dt)/vhes(j) + vsigma*(1/sqrt(vhes(j)))*sqrt(dt)*r2);
end
simPath = simPath + exp(-r*T(k)) * max(shes(j+1) - strike(k), 0);
end
simhes(k)=simPath/M;
simimpvol(k)=blkimpv(shes(1), strike(k), r, T(k), simhes(k));
modhes(k)=HestonCall(shes(1),strike(k),r,T(k),vhes(1),kappa,theta,vsigma,rho,0);
hesimpvol(k)=blkimpv(shes(1), strike(k), r, T(k), modhes(k));
end

for i=1:length(T)
bsprice(i)=blsprice(F0,strike(i),r,T(i),impvol(i));
end

%Output optimized Parameters
x

%Compare blackscholes option price, analytical heston price, and simulated
%heston prices for a given maturity and strike
pricedata=[T,strike,bsprice',modhes',simhes']

%Compare blackscholes option IV, analytical heston IV, and simulated
%heston IV for a given maturity and strike

voldata=[T,strike,impvol,hesimpvol',simimpvol']
