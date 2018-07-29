%The code estimates the portfolio CVaR and the asset weights 

%INPUTS:
%The data matrix (historical returns or simulation) ScenRets size JxnAssets
% the confidence level beta (scalar, between 0.9 and 0.999, usually o.95 or
% 0.99)
%the Upper Bounds for the weights in order to inforce diversification 
%R0 the portfolio target return
[J, nAssets]=size(ScenRets);
i=1:nAssets;
beta=0.99; %change it if you want but stay between 0.9 and 0.999
UB=0.25;  %the upper bound to inforce diversification, positive between (0,1)
R0=0;  %the target return
ShortP=0; %If ShortP=1 allow for short positions, else if ShortP=0 only long positions are allowed
%function to be minimized
%w(31)=VaR
objfun=@(w) w(nAssets+1)+(1/J)*(1/(1-beta))*sum(max(-w(i)*ScenRets(:,i)'-w(nAssets+1),0));
% initial guess
w0=[(1/nAssets)*ones(1,nAssets)];
VaR0=abs(quantile(ScenRets*w0',1-beta)); % the initial guess for VaR is the
%HS VaR of the equally weighted portfolio
w0=[w0 VaR0];
% the (linear) equalities and unequalities matrixes
A=[-mean(ScenRets) 0];
if ShortP==0
A=[A;  -eye(nAssets) zeros(nAssets,1)];
A=[A; eye(nAssets) zeros(nAssets,1)];
b=[-R0 zeros(1,nAssets) UB*ones(1,nAssets)];
elseif ShortP==1
A=[A;  -eye(nAssets) zeros(nAssets,1)];
A=[A; eye(nAssets) zeros(nAssets,1)];
b=[-R0 -LB*ones(1,nAssets) UB*ones(1,nAssets)];
elseif ShortP~=0|ShortP~=1
    error('Input ShortP=1 (line14) if you allow short positions and 0 else!!')
end
b=b';
Aeq=[ ones(1,nAssets) 0];
beq=[1];
options=optimset('LargeScale','off');
options=optimset(options,'MaxFunEvals',10000);
[w,fval,exitflag,output]=fmincon(objfun,w0,A,b,Aeq,beq,[],[],[],options)
portfWeights=zeros(1, nAssets);
for i=1:nAssets
% clear rounding errors
    if w(i)<0.0001
        w(i)=0;
    end
% save results to the workfile
    portfWeights(1,i)=w(i);
end
Risk=zeros(1,2);
Risk(1,1)=w(nAssets+1); %Remember that w(31)= portfolio VaR
Risk(1,2)=fval;
