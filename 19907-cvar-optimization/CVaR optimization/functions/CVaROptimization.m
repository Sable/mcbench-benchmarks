%-------------PORTFOLIO OPTIMIZATION FUNCTION UNDER CVAR MINIMIZATION----
%
function [fval,w]=CVaROptimization(ScenRets, R0, VaR0, beta,  UB, LB)
%
%
% The function estimates the optimal portfolio weights that minimize CVaR
% under a given target return R0
%
%INPUTS: ScenRets: Portfolio returns matrix
%       R0: The target return
%       beta:The confidence level between 0.9 and 0.999
%       LB, UB the upper and lower bound for the optimal weights. For example If
%       you imput UB=.25 none of the stocks can consist more than the 25% of the
%       portfolio. 
%       VaR0= the initial guess for the portfolio VaR
%
%OUTPUTS: fval = CVaR of the optimal portfolio
%         w= the weights of the optimal portfolio, The last element in w
%         equals the VaR of the optimal portfolio
%
%---------------- INPUT ARGUMENTS--------------------------------------
% The function accepts 6 imputs however only the two first are required
% If you dont supply the 6 argument then LB=0 (no short positions)
% If you dont supply the 5 argument then UB=1
% If you dont supply the 4 argument then beta=0.95
% If you dont supply the 3 argument VaR0 equals the HS VaR of the equally weighted
% portfolio 


% Author: Manthos Vogiatzoglou, Un of Macedonia, 20/08/2008
% contact: vogia@yahoo.com

[J, nAssets]=size(ScenRets);
w0=[(1/nAssets)*ones(1,nAssets)];
if isempty(LB)
    LB=0;
end
if isempty(UB)
    UB=1;
end
if isempty(beta)
   beta=.95;
end
if isempty(VaR0)
   VaR0=quantile(ScenRets*w0',.95);
end
if beta>1|beta<0.9
    error('The confidence level beta = 1 - alpha, should be in (0.9 0.99)')
end
if LB>=UB
    error('The LB has to be smaller than UB')
end
if UB>1
    error('The upper bound should be less than 1')
end
if LB<-1
    error('The lower bound should be greater than -1')
end
i=1:nAssets;
% the objective function
Riskfun=@(w) w(nAssets+1)+(1/J)*(1/(1-beta))*sum(max(-w(i)*ScenRets(:,i)'-w(nAssets+1),0));
w0=[w0 VaR0];
% the (linear) equalities and unequalities matrixes
A=[-mean(ScenRets) 0];
A=[A;  -eye(nAssets) zeros(nAssets,1)];
A=[A; eye(nAssets) zeros(nAssets,1)];
b=[-R0 -LB*ones(1,nAssets) UB*ones(1,nAssets)];
b=b';
Aeq=[ ones(1,nAssets) 0];
beq=[1];
options=optimset('LargeScale','off');
options=optimset(options,'MaxFunEvals',5000);
% The VaR of the optimal portfolio equals w(nassets+1) 
[w,fval,exitflag,output]=fmincon(Riskfun,w0,A,b,Aeq,beq,LB,UB,[],options)

