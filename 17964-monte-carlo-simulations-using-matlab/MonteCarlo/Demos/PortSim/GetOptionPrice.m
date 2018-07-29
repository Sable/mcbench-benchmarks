function [Price, ProbaITM , CI] = GetOptionPrice(Paths,Exercise,TimeToExpiry,RiskFreeRate,Optiontype)

switch Optiontype
    case 'Asian'
        
        MeanPrices = mean(Paths,1) ;
        OptionPricesAtMaturity = max(MeanPrices- Exercise,0);
           case 'Vanilla'
        OptionPricesAtMaturity = max(Paths(end,:)- Exercise,0);
       
end;
[MeanPriceAtMaturity, dummy,CI] = normfit(OptionPricesAtMaturity,0.01);
CI                     = CI* exp(-TimeToExpiry * RiskFreeRate);
Price                  = MeanPriceAtMaturity * exp(-TimeToExpiry * RiskFreeRate);
ProbaITM               = 100 * sum(OptionPricesAtMaturity > 0) ./ length(OptionPricesAtMaturity);
