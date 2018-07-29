function [Price, CI] = BlsMCCV(S0,X,r,T,sigma,NRepl,NPilot)
% Price a vanilla cal using the stock price s a control variable
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);

%% Compute parameters first 

StockVals = S0*exp(nuT+siT*randn(NPilot,1));
OptionVals = exp(-r*T) * max( 0 , StockVals - X);
MatCov = cov(StockVals, OptionVals);

%% Compute Expected value and Variacne of our control Variable

VarY = S0^2 * exp(2*r*T) * (exp(T * sigma^2) - 1);
ExpY = S0 * exp(r*T);

%% compute the optimal control parameter

c = - MatCov(1,2) / VarY;

% % Compute the MC expected value  
NewStockVals = S0*exp(nuT+siT*randn(NRepl,1));
NewOptionVals = exp(-r*T) * max( 0 , NewStockVals - X);
%% Use the control parameter
ControlVars = NewOptionVals + c * (NewStockVals - ExpY);
[Price, VarPrice, CI] = normfit(ControlVars);