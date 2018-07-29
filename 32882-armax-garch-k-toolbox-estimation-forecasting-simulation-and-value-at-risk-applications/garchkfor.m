function [MF, VF, KF, MC, VC] = garchkfor(data, model,ar, ma, p, q, max_forecast)
%{
-----------------------------------------------------------------------
 PURPOSE: 
 Mean, Volatility and Kurtosis Forecasting 
-----------------------------------------------------------------------
 USAGE:
 [MF, VF, KF, MC, VC] = garchfor2(data, resids, ht, kt, parameters, model,ar, ma, p, q, max_forecast)
 
 INPUTS:
 data:          a vector of series
 model:         'GARCH', 'GJR', 'AGARCH', 'NAGARCH'
 ar:            positive scalar integer representing the order of AR
 am:            positive scalar integer representing the order of MA
 p:             positive scalar integer representing the order of ARCH
 q:             positive scalar integer representing the order of GARCH
 max_forecasts: maximum number of forecasts (i.e. 1-trading months 22 days)
 
 OUTPUTS:
 MF:            a vector of mean forecasts
 VF:            a vector of volatility forecasts
 KF:            a vector of kurtosis forecasts
 MC:            a vector of cumulative mean forecasts
 VC:            a vector of cumulative volatility forecasts 
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     08/2011
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, Residuals, Variance, Kurtosis, GARCH Model, AR, MA, ARCH, GARCH, Maximum Number of Forecasts') 
end

if size(data,2) > 1
   error('Data vector should be a column vector')
end

if (length(ar) > 1) | (length(ma) > 1) | ar < 0 | ma < 0
    error('AR and MA should be positive scalars')
end

if (length(p) > 1) | (length(q) > 1) | p < 0 | q < 0
    error('P and Q should be positive scalars')
end

z=ar+ma;
MF=[];
VF=[];
KF=[];

[parameters, stderrors, LLF, ht, kt, nu, resids, summary] = garchk(data, strcat(model), ar,ma,0,p,q,0);

% Forecasting the Mean
MF = parameters(1:1+z)'*[1; data(end-(1:ar)); resids(end-(0:ma-1))]; % 1-period ahead forecast
 for i = 2:max_forecast
     MF(i,1) = sum([parameters(1); ones(1,ar)*parameters(2:2+ar)*MF(i-1,1); ones(1,ma)*parameters(3+ar:2+ar+ma)*resids(end-(0:ma-1-i))]);
 end
 clear i

 % Forecasting Volatility and Kurtosis
 % Please note that for a given set of parameters it is possible to forecast 
 % a smaller than 3 kurtosis, and therefore we floor the forecast at 3.
if isequal(strcat(model), 'GARCH')
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; resids(end-(0:(p-1))).^2;ht(end-(0:(q-1)))]; % 1-period ahead forecast
    KF(1,1) = parameters(3+z+p+q:3+z+2*p+2*q)'*[1; (resids(end-(0:(p-1))).^4)./(ht(end-(0:(p-1))).^2); kt(end-(0:(q-1)))]; % 1-period ahead forecast
    if KF(1,1) < 3
        KF(1,1) = 3
    end    
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z) + ones(1,p+q)*parameters(3+z:2+z+p+q)*VF(i-1,1);
       KF(i,1) = parameters(3+z+p+q) + ones(1,p+q)*parameters(4+z+p+q:3+z+2*p+2*q)*KF(i-1,1);
    end
clear i
elseif  isequal(strcat(model), 'GJR')
    VF(1,1) = parameters(2+z:2+z+2*p+q)'*[1; resids(end-(0:(p-1))).^2;  ht(end-(0:(q-1))); (resids(end-(0:(p-1)))<0).*resids(end-(0:(p-1))).^2];
    KF(1,1) = parameters(3+z+p+q:3+z+2*p+2*q)'*[1; (resids(end-(0:(p-1))).^4)./(ht(end-(0:(p-1))).^2); kt(end-(0:(q-1)))]; % 1-period ahead forecast
    if KF(1,1) < 3
        KF(1,1) = 3
    end    
    for i = 2:max_forecast
         VF(i,1) = parameters(2+z) + ones(1,2*p+q)*parameters(3+z:2+z+2*p+q)*VF(i-1,1); 
         KF(i,1) = parameters(3+z+p+q) + ones(1,p+q)*parameters(4+z+p+q:3+z+2*p+2*q)*KF(i-1,1);
    end
clear i
elseif isequal(strcat(model), 'AGARCH')
    asym=parameters(3+z+p+q:2+z+2*p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; (resids(end-(0:(p-1))) - asym).^2; ht(end-(0:(q-1)))]; % 1-period ahead forecast
    KF(1,1) = parameters(4+z+p+q:4+z+2*p+2*q)'*[1; (resids(end-(0:(p-1))).^4)./(ht(end-(0:(p-1))).^2); kt(end-(0:(q-1)))]; % 1-period ahead forecast
    if KF(1,1) < 3
        KF(1,1) = 3
    end    
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z:2+z+p+q)'*[1; (sqrt(VF(i-1,1)) - asym).^2; VF(i-1,1)];
       KF(i,1) = parameters(4+z+p+q) + ones(1,p+q)*parameters(5+z+p+q:4+z+2*p+2*q)*KF(i-1,1);
    end
clear i
elseif isequal(strcat(model), 'NAGARCH')
    asym=parameters(3+z+p+q:2+z+2*p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; (resids(end-(0:(p-1)))*sqrt(ht(end-(0:(p-1)))) - asym).^2; ht(end-(0:(p-1)))]; % 1-period ahead forecast
    KF(1,1) = parameters(4+z+p+q:4+z+2*p+2*q)'*[1; (resids(end-(0:(p-1))).^4)./(ht(end-(0:(p-1))).^2); kt(end-(0:(q-1)))]; % 1-period ahead forecast
    if KF(1,1) < 3
        KF(1,1) = 3
    end    
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z:2+z+p+q)'*[1; (sqrt(VF(i-1,1)) - asym).^2; VF(i-1,1)]
       KF(i,1) = parameters(4+z+p+q) + ones(1,p+q)*parameters(5+z+p+q:4+z+2*p+2*q)*KF(i-1,1);
    end
    clear i
else error('Invalid GARCH Model');
end

% Estimating cumulative measures
MC = cumsum(MF);
VC = sqrt(cumsum(VF)); 

end
