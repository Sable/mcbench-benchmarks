%------------------- EFFICIENT FRONTIER ESTIMATION---------------------
%The code estimates the portfolio CVaR and the asset weights 
%
%INPUTS:
%The data matrix (historical returns or simulation) ScenRets size JxnAssets
% the confidence level beta (scalar, between 0.9 and 0.999, usually 0.95 or
% 0.99)
%the Upper and lower  bounds for the weights in order to inforce diversification 
%R0 the portfolio target return. For a desired yearly return of 10% the
%daily return should be around 0.04% and the weekly return around .2%
clc;
[J, nAssets]=size(ScenRets);
i=1:nAssets;
beta=0.95; 
UB=0.25;  % the weight of each asset can't be more that 25%
LB=-0.1;
R0=0.025:0.01:.15;
portfWeights=zeros(length(R0), nAssets);
Risk=zeros(length(R0),2);
% the (linear) equalities and unequalities matrixes
A=[-mean(ScenRets) 0];
A=[A;  -eye(nAssets) zeros(nAssets,1)];
A=[A; eye(nAssets) zeros(nAssets,1)];
Aeq=[ ones(1,nAssets) 0];
beq=[1];
objfun=@(w) w(31)+(1/J)*(1/(1-beta))*sum(max(-w(i)*ScenRets(:,i)'-w(31),0));
for k=1:length(R0)
b=[-R0(1,k) -LB*ones(1,nAssets) UB*ones(1,nAssets)];
b=b';
options=optimset('LargeScale','off');
options=optimset(options,'MaxFunEvals',10000);
w0=[(1/nAssets)*ones(1,nAssets) 1.5];    % initial guess
%function to be minimized
[w,fval,exitflag,output]=fmincon(objfun,w0,A,b,Aeq,beq,LB,UB,[],options);
for i=1:nAssets
% clear rounding errors
    if w(i)<0.0001
        w(i)=0;
    end
% save results to the workfile
    portfWeights(k,i)=w(i);
end
Risk(k,1)=w(31); %Remember that w(31)= portfolio VaR
Risk(k,2)=fval;
clear w
end
%%
% The VaR and CVaR of the equaly weighted portfolio
eqweights=(1/nAssets)*ones(nAssets,1);
ewportf=ScenRets*eqweights;
ewVaR=quantile(ewportf,1-beta);
lowerTail=ewportf<=ewVaR;
ewVaR=abs(quantile(ewportf,1-beta))
ewCVaR=abs(mean(ewportf(lowerTail)))
%%
plot(Risk(:,2),R0) %the efficient frontier
xlabel('CVaR')
ylabel('portfolio Return')
title('Efficient frontier')
