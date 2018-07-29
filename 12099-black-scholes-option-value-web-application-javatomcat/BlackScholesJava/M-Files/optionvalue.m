function optionValueReturned = optionvalue(SpotPrice, StrikePrice, RiskFreeRate,TimeExpiry, Volatility,theOptionType,ButterflyRange)
% mcc -d compiled -B 'ccom:BSOptionModel,BSOptionModelClass,1' optionvalue.m webvizroutine.m      
%CALCROUTINE Calculate the value of the option

OptionType = lower(theOptionType);

if (strcmpi(OptionType,'call') == 1) %Call option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Calculate the value of the option
     optionValueReturned = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);
     

     
elseif (strcmpi(OptionType,'put') == 1) %Put option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Calculate the value of the put option
     optionValueReturned = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);

elseif (strcmpi(OptionType,'straddle') == 1) %Straddle option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Compute the value of the straddle
     
     optionValueReturned = blsstrval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);
        
elseif (strcmpi(OptionType,'butterfly') == 1) %Butterfly option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Compute the value of the butterfly
     optionValueReturned = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange);
       
end

%--------------------------------------------------------------------------

function StraddleValue = blsstrval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility)
%BLSSTRVAL Black Scholes value of a straddle option

%Calculate the value of both the call and put option
[CallValue, PutValue] = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Compute the value of the straddle
StraddleValue = CallValue + PutValue;

%end of BLSSTRVAL subroutine

function ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange)
%BLSBTYVAL Black Scholes value of a butterfly option

%Set the different strike prices
LowStrike = StrikePrice .* (1 - ButterflyRange);
HighStrike = StrikePrice .* (1 + ButterflyRange);

%Value the long positions in the low and high struck calls
LowValue = blsprice(SpotPrice, LowStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);
HighValue = blsprice(SpotPrice, HighStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Value the short position in the calls struck at the initial strike
%price
ShortValue = 2 .* -(blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility));

%Calculate the total value of the butterfly
ButterflyValue = LowValue + HighValue + ShortValue;

%end of BLSBTYVAL subroutine
