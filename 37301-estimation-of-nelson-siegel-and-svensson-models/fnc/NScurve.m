function [ZeroRates InstFwdRates] = NScurve(Params, Tau, Model)
% =========================================================================
% NSCURVE calculates Nelson-Siegel and Svensson zero a instanteneous forward curves
% 
% INPUTS:  
%         Params - Parameters of the curve Model
%         Tau    - Vector of times to maturity in years
%         Model  - Yield curve Model 
%                   'NS' for Nelson-Siegel curve
%                   'Svensson' for Svensson curve
% 
% OUTPUTS:
%        ZeroRates      - Vector of zero coupon rates (spot rates) using continuous
%                         compounding
%        InstFwdRates   - Vector of instanteneous forward rates using
%                         continuous compounding
% 
% 
% Kamil Kladivko
% email: kladivko@gmail.com
% December 2010 
% Cite as: 
% Kladivko Kamil (2010). The Czech Treasury Yield Curve from 1999 to the Present, 
% Czech Journal of Economics and Finance, 60(4): 307-335
% =========================================================================
switch Model
    case 'NS'
        beta0 = Params(1);
        beta1 = Params(2);
        beta2 = Params(3);
        lambda = Params(4);
        InstFwdRates = beta0 + beta1.*exp(-lambda.*Tau) + beta2.*lambda.*Tau.*exp(-lambda.*Tau);
        ZeroRates = beta0 + beta1*((1-exp(-lambda.*Tau))./(lambda.*Tau)) +...
                    beta2*((1-exp(-lambda.*Tau))./(lambda.*Tau) - exp(-lambda.*Tau));
    case 'Svensson'
        beta0 = Params(1);
        beta1 = Params(2);
        beta2 = Params(3);
        beta3 = Params(4);
        lambda = Params(5);
        gamma = Params(6);                             
        InstFwdRates = beta0 + beta1.*exp(-lambda.*Tau) + beta2.*lambda.*Tau.*exp(-lambda.*Tau) + beta3.*gamma.*Tau.*exp(-gamma.*Tau);
        ZeroRates = beta0 + beta1.*(1-exp(-lambda.*Tau))./(lambda.*Tau) + ...
                    beta2.*((1-exp(-lambda.*Tau))./(lambda.*Tau) - exp(-lambda.*Tau)) +...
                    beta3.*((1-exp(-gamma.*Tau))./(gamma.*Tau) - exp(-gamma.*Tau));      
    otherwise
        error('Unknown Model')
end
% Check for zero time to maturity and set limitng valaues
ZeroRates(Tau == 0) = beta0 + beta1;

end
