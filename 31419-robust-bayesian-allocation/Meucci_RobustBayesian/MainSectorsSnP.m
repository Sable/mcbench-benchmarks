% ========================= 
%  Robust Bayesian allocation in the stock market, as described in
%  Meucci, A., (2005) "Robust Bayesian Allocation"
% 
%  Most recent version of article and code available at http://symmys.com/node/102
%  =========================

clear; clc;

load SectorsSnP500

% compute weekly returns
Ps=P(1:5:end,:);
R=Ps(2:end,:)./Ps(1:end-1,:)-1;

[Ttot,N]=size(R);


W=120; % rolling estimation period
NumPortf=10;
for t=W+1:Ttot
    
    Rets=R(t-W:t,:);

    % sample
    m=mean(Rets)';
    S=cov(Rets);
    [d,d,w] = EfficientFrontier(NumPortf, S, m);

    % prior
    S0=diag(diag(S));
    m0=2.5*S0*ones(N,1)/N;
    [d,d,w0] = EfficientFrontier(NumPortf, S0, m0);
    
    T=size(Rets,1);
    T0=T;
    nu0=T;
    
    % Bayesian posterior parameters
    T1=T+T0;
    m1=1/T1*(m*T+m0*T0);
    nu1=T+nu0;
    S1=1/nu1*( S*T + S0*nu0 + (m-m0)*(m-m0)'/(1/T+1/T0)  );
    [d,d,w1] = EfficientFrontier(NumPortf, S1, m1);
    
end