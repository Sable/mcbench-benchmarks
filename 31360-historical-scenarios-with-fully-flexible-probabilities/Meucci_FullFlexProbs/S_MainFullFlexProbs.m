% This script uses Entropy Pooling to compute Fully Flexible Probabilities for historical scenarios
% based on time periods, market conditions, constraints on moments, etc., as described in
% A. Meucci, "Personalized Risk Management: Historical Scenarios with Fully Flexible Probabilities"
% GARP Risk Professional, Dec 2010, p 47-51
% 
%  Most recent version of article and code available at
%  http://www.symmys.com/node/150

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% risk drivers scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load db

Infl=Data(:,end);
Vix=Data(:,end-1);
Crude=Data(:,end-3);
Swp10=Data(:,2);
SnP=Data(:,4);

X=diff(log([SnP Vix Swp10]));
Y=[Infl(1:end-1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assign probabilities to historical scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DefineProbs = 1 : rolling window
% DefineProbs = 2 : exponential smoothing
% DefineProbs = 3 : market conditions
% DefineProbs = 4 : kernel damping
% DefineProbs = 5 : partial information prox. kernel damping
% DefineProbs = 6 : partial information: match covariance
DefineProbs=6;

T=size(X,1);
p=zeros(T,1);

switch DefineProbs
    case 1 % rolling window
        tau=2*252;
        %p(end-tau:end)=1;
        p(1:tau)=1;
        p=p/sum(p);

    case 2 % exponential smoothing
        lmd=0.0166;
        p=exp(-lmd*(T-(1:T)'));
        p=p/sum(p);

    case 3 % market conditions
        Cond = Y>=2.8;
        p(Cond)=1;
        p=p/sum(p);

    case 4 % kernel damping
        y=3;
        h2=cov(diff(Y));
        p=mvnpdf(Y,y,h2);
        p=p/sum(p);
    
    case 5 % partial information prox. kernel damping
        y=3;
        h2=NaN; % set h2=NaN for no conditioning on second moments
        h2=cov(1*diff(Y));
        p=LeastInfoKernel(Y,y,h2);
    
    case 6 % partial information: match covariance
        l_c=0.0055;
        l_s=0.0166;
        [m,S]=DoubleDecay(X,l_c,l_s);
        p=Fit2Moms(X,m,S);
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P&L scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=20;

% call parameters
S_0=SnP(end);
vol_0=Vix(end);
rf_0=Swp10(end);
K=S_0*(linspace(.8,1.1,N));
Expiry=(2:N+1)/252;

S_T=S_0*exp(X(:,1));
vol_T=vol_0*exp(X(:,2));
rf_T=rf_0*exp(X(:,3));

% securities scenarios
for n=1:N
    Call_1=CallPrice(S_T, K(n), rf_T, Expiry(n)-1/252, vol_T);
    Call_0=CallPrice(S_0, K(n), rf_0, Expiry(n), vol_0);
    PnL(:,n)=Call_1-Call_0;
end

% portfolio scenarios
u=-[-ones(N/2,1); ones(N/2,1)]; % number of units (contracts/shares/etc)
PnL_u=PnL*u;

