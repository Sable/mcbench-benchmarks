function CVaR=ComputeCVaR(Units,Scenarios,Conf)

PnL=Scenarios*Units;
Sort_PnL=sort(PnL);

J=length(PnL);
Cut=round(J*(1-Conf));

CVaR=-mean(Sort_PnL(1:Cut));
