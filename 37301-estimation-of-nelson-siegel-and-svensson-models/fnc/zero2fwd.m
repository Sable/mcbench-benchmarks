function [FwdRates FwdTau] = zero2fwd(ZeroRates)
% =========================================================================
% Calculets Forward Rates with one year maturity from Zero Rates (Spot Rates).

% Assumes continuous compounding
% 
% INPUT:
% ZeroRates - matrix of Spot Rates (continuously compounded, decimal form, yield curve in rows)
%             Spot Rates should go as 1Y, 2Y, 3Y,...
%                         
% OUTPUT: 
% FwdRates - matrix of 1Y Forward Rates (continuously compounded)
% FwdTau   - settlement years of this forward rates
%
% Kamil Kladivko
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% ========================================================================
   [Nobs Ntau] = size(ZeroRates);  
   if Ntau == 1, warning('Only 1 maturity?'), end;
    
   tau = 1:Ntau;
   tau = repmat(tau, Nobs, 1);
   DF(i,1:Ntau) = exp(-ZeroRates.*tau);
   
   DFt1 = DF(:, 1:end-1); 
   DFt2 = DF(:, 2:end);
   
   FwdTau = tau(1:end-1);     
   FwdRates = log(DFt1./DFt2);

end