function [ExpectedValue,Volatility, Composition] = EfficientFrontier(NumPortf, Covariance, ExpectedValues)

% This function returns the NumPortf x 1 vector expected returns,
%                       the NumPortf x 1 vector of volatilities and
%                       the NumPortf x NumAssets matrix of compositions
% of NumPortf efficient portfolios whose expected returns are equally spaced along the whole range of the efficient frontier

warning off;
NumAssets=size(Covariance,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of minimum-risk portfolio
FirstDegree=zeros(NumAssets,1);
SecondDegree=Covariance;
Aeq=ones(1,NumAssets);
beq=1;
A=-eye(NumAssets);          % no-short constraint
b=zeros(NumAssets,1);       % no-short constraint
x0=1/NumAssets*ones(NumAssets,1);
MinVol_Weights = quadprog(SecondDegree,FirstDegree,A,b,Aeq,beq,[],[],x0);
MinVol_Return=MinVol_Weights'*ExpectedValues;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine return of maximum-return portfolio
[MaxRet_Return,MaxRet_Index]=max(ExpectedValues);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% slice efficient frontier in NumPortf equally thick horizontal sectors in the upper branch only
Step=(MaxRet_Return-MinVol_Return)/(NumPortf-1);
TargetReturns=[MinVol_Return : Step : MaxRet_Return];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the NumPortf compositions and risk-return coordinates of the optimal allocations relative to each slice

% start with min vol portfolio
Composition=MinVol_Weights';
Volatility=sqrt(MinVol_Weights'*Covariance*MinVol_Weights);
ExpectedValue=MinVol_Weights'*ExpectedValues;

for i=2:NumPortf-1

    % determine least risky portfolio for given expected return
    AEq=[ones(1,NumAssets);
        ExpectedValues'];
    bEq=[1
        TargetReturns(i)];
    Weights = quadprog(SecondDegree,FirstDegree,A,b,AEq,bEq,[],[],x0)';
    Composition=[Composition
        Weights];
    Volatility=[Volatility
        sqrt(Weights*Covariance*Weights')];
    ExpectedValue=[ExpectedValue
        Weights*ExpectedValues];
end
% % add max ret portfolio
% Weights=zeros(1,NumAssets);
% Weights(MaxRet_Index)=1;
% Composition=[Composition
%     Weights];
% Volatility=[Volatility
%     sqrt(Weights*Covariance*Weights')];
% ExpectedValue=[ExpectedValue
%     Weights*ExpectedValues];
