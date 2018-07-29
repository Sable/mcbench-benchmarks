function K=Solve4Strike(Strike,Time_to_Maturity,Stock_Value,Stock_Volatility,Riskfree_Rate,Initial_Investment,Maximum_Loss)

d1 = 1/(Stock_Volatility*sqrt(Time_to_Maturity))*( log(Stock_Value/Strike) + (Riskfree_Rate* Stock_Volatility^2/2)*Time_to_Maturity  );
d2 = d1 - Stock_Volatility*sqrt(Time_to_Maturity);

PV=exp(-Riskfree_Rate*Time_to_Maturity);

Call_Price = Stock_Value*normcdf(d1,0,1) -PV*Strike*normcdf(d2,0,1);

Guaranteed=Initial_Investment-Maximum_Loss;
Cash_Available=Initial_Investment-PV*Guaranteed;

K=Cash_Available-Call_Price;
