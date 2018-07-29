function VaR = garchkvar2(data, resids, ht, kt, parameters, model, ar, ma, p, q, max_forecast, alpha)
%{
-----------------------------------------------------------------------
 PURPOSE: 
 Value-at-Risk Estimation for both long and short positions
-----------------------------------------------------------------------
 USAGE:
 VaR = garchvar(data, model, ar, ma, p, q, max_forecast, alpha)
 
 INPUTS:
 data:          (T x 1) vector of data
 model:         'GARCH', 'GJR', 'AGARCH','NAGARCH'
 ar:            positive scalar integer representing the order of AR
 am:            positive scalar integer representing the order of MA
 p:             positive scalar integer representing the order of ARCH
 q:             positive scalar integer representing the order of GARCH
 max_forecasts: maximum number of forecasts (i.e. 1-trading months 22 days)
 alpha:         confidence level
 
 OUTPUTS:
 VaR:           a vector of VaR forecasts
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     11/2011
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, GARCH Model, Distribution, AR, MA, ARCH, GARCH, Maximum Number of Forecasts, Confidence Level') 
end

if size(data,2) > 1
   error('Data vector should be a column vector')
end

if (length(ar) > 1) | (length(ma) > 1) | ar < 0 | ma < 0
    error('AR and MA should be positive scalars')
end

if (length(p) > 1) | (length(q) > 1) | p < 0 | q < 0 | alpha < 0 | alpha > 1
    error('P,Q and alpha should be positive scalars')
end

% Calling garchkfor2 function to pass the parameters
[MF, VF, KF, MC, VC] = garchkfor2(data, resids, ht, kt, parameters, strcat(model),ar, ma, p, q, max_forecast);

% Estimating Inverce-CDF using the degrees of freedom which are described
% as a function of the forecasted conditional kurtosis
cdfqtile1 = tinv(alpha,(4*KF-6)./(KF-3));
cdfqtile2 = tinv(1-alpha,(4*KF-6)./(KF-3));

% Estimating VaR
VaR = [MC + cdfqtile1.*VC, MC + cdfqtile2.*VC];

end
