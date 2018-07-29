function ParRates = zero2par(ZeroRates)
% =========================================================================
% Calculets Par Rates from Zero Rates (Spot Rates). Assumes yearly
% compounding
% 
% INPUT:
% ZeroRates - matrix of Zero Rates (yield curve in rows) in decimal form
%                         
% OUTPUT: 
% ParRates - matrix of Par Rates
%
% Kamil Kladivko
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% ========================================================================

   [Nobs Ntau] = size(ZeroRates);  
   if Ntau == 1, error('Only 1 maturity? Maturities must be in rows!'), end;
   if any(ZeroRates > 1), error('Rates must be in decimal form!'), end

   tau = 1:Ntau;
   tau = repmat(tau, Nobs, 1);
   DiscountFactors = (1./(1 + ZeroRates)).^tau;   
   ParRates = (1 - DiscountFactors)./cumsum(DiscountFactors, 2);
  
end