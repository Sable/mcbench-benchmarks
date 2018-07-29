function ZeroRates = par2zero(ParRates)
% =========================================================================
% Bootstraps from Par Rates to Zero Rates (Spot Rates)
% INPUT:
% ParRates - matrix of par rates (yield curve in rows) in decimal form            
%               
% OUTPUT:
% DiscountFactor     - matrix of discount factors 
% ZeroRates          - matrix of Zero Rates (Spot Rates)
%
% Kamil Kladivko
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% ========================================================================
                      
   [Nobs Ntau] = size(ParRates);  
   if Ntau == 1, error('Only 1 maturity? Maturities must be in rows!'), end;
   if any(ParRates) > 1, error('Rates must be in decimal form!'), end
   
   DiscountFactor = zeros(Nobs, Ntau);  
   DiscountFactor(:,1) = 1./(1 + ParRates(:,1));
    for i = 2 : Ntau
       DiscountFactor(:, i) = (1 - ParRates(:, i).*sum(DiscountFactor, 2))./(1 + ParRates(:, i));
    end        
    tau = 1:Ntau;
    ZeroRates = (DiscountFactor.^(-1./tau)) - 1;    
   
end