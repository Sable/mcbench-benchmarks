function D=Delta(Time_to_Maturity,Stock_Value,Stock_Volatility,Strike,Riskfree_Rate)

Time_to_Maturity=max(Time_to_Maturity,10^(-9));  % avoid division by zero message

d1 = 1/(Stock_Volatility*sqrt(Time_to_Maturity))*( log(Stock_Value/Strike) + ...
                (Riskfree_Rate* Stock_Volatility^2/2)*Time_to_Maturity  );

D =normcdf(d1,0,1);
