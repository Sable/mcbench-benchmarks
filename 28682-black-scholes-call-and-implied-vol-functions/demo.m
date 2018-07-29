
% Stock price
S=100;

% Strike price
K=105;

% Interest rate
r=0.01;

% Dividend yield
q=0.04;

% Time now
t=0;

% Maturity time
T=1;

% Various volatilities
sigma=(0.05:0.001:1)';

% Call prices
C=call(S,K,r,sigma,t,T,q);

% Implied vol
implied_sigma=impvol(C,S,K,r,t,T,q);

% Check results
error_max=max(abs(C-call(S,K,r,implied_sigma,t,T,q)));