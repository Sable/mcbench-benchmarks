function [MF, VF, MC, VC] = garchfor2(data, resids, ht, parameters, model, distr, ar, ma, p, q, max_forecast)
%{
-----------------------------------------------------------------------
 PURPOSE: 
 Mean and Volatility Forecasting 
-----------------------------------------------------------------------
  USAGE:
  [MF, VF] = garchfor(data, model, distr, ar, ma, p, q, max_forecast,startingvalues, options)
 
 INPUTS:
 data:          a vector of series
 resids:        a vector of residuals as estimated by GARCH
 ht:            a vector of conditional variances as estimated by GARCH
 parameters:    a vector of parameters
 model:         'GARCH', 'GJR', 'EGARCH', 'NARCH', 'NGARCH, 'AGARCH', 'APGARCH',
                'NAGARCH'
 distr:         'GAUSSIAN', 'T', 'GED', 'CAUCHY', 'HANSEN' and 'GC'  
 ar:            positive scalar integer representing the order of AR
 am:            positive scalar integer representing the order of MA
 p:             positive scalar integer representing the order of ARCH
 q:             positive scalar integer representing the order of GARCH
 max_forecasts: maximum number of forecasts (i.e. 1-trading months 22 days)
 
 OUTPUTS:
 MF:            a vector of mean forecasts
 VF:            a vector of volatility forecasts
 MC:            a vector of cumulative mean forecasts
 VC:            a vector of cumulative volatility forecasts 
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     08/2011
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, GARCH Model, Distribution, AR, MA, ARCH, GARCH, Maximum Number of Forecasts') 
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

% Verifying that the vector of parameters is a column vector
[r,c]=size(parameters);
if r<c
    parameters=parameters';
end

% Forecasting the Mean
MF = parameters(1:1+z)'*[1; data(end-(1:ar)); resids(end-(0:ma-1))]; % 1-period ahead forecast
 for i = 2:max_forecast
     MF(i,1) = sum([parameters(1); ones(1,ar)*parameters(2:2+ar)*MF(i-1,1); ones(1,ma)*parameters(3+ar:2+ar+ma)*resids(end-(0:ma-1-i))]);
 end
 clear i

 % Forecasting Volatility
if isequal(strcat(model), 'GARCH')
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; resids(end-(0:(p-1))).^2;ht(end-(0:(q-1)))]; % 1-period ahead forecast
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z) + ones(1,p+q)*parameters(3+z:2+z+p+q)*VF(i-1,1);
    end
clear i
elseif  isequal(strcat(model), 'GJR')
    VF(1,1) = parameters(2+z:2+z+2*p+q)'*[1; resids(end-(0:(p-1))).^2;  ht(end-(0:(q-1))); (resids(end-(0:(p-1)))<0).*resids(end-(0:(p-1))).^2];
     for i = 2:max_forecast
         VF(i,1) = parameters(2+z) + ones(1,2*p+q)*parameters(3+z:2+z+2*p+q)*VF(i-1,1); 
     end
clear i
elseif isequal(strcat(model), 'EGARCH')
    VF(1,1) = exp(parameters(2+z:2+z+2*p+q)'*[1 ; (abs(resids(end-(0:(p-1)))/sqrt(ht(end-(0:(p-1)))))-sqrt(2/pi)); log(ht(end-(0:(q-1))));  resids(end-(0:(p-1)))/sqrt(ht(end-(0:(p-1))))]);  % 1-period ahead forecast
    for i = 2:max_forecast
        VF(i,1) = exp(parameters(2+z) + ones(1,2*p+q)*parameters(3+z:2+z+2*p+q)*log(VF(i-1,1)));
    end
clear i
elseif isequal(strcat(model), 'NARCH')
    delta = parameters(3+z+p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; abs(resids(end-(0:(p-1)))).^delta; ht(end-(0:(q-1)))]; % 1-period ahead forecast
    for i = 2:max_forecast
        VF(i,1) = parameters(2+z:2+z+p+q)'*[1; sqrt(VF(i-1,1)).^delta; VF(i-1,1)];
    end
clear i
elseif isequal(strcat(model), 'NGARCH')
    delta = parameters(3+p+q+z);
    VF(1,1) = (parameters(2+z:2+z+p+q)'*[1; abs(resids(end-(0:(p-1)))).^delta; ht(end-(0:(q-1))).^delta]).^(1/delta); % 1-period ahead forecast
    for i = 2:max_forecast
        VF(i,1) = (parameters(2+z) + (ones(1,1+p+q)*parameters(3+z:3+z+p+q)*VF(i-1,1)).^delta).^(1/delta);
    end
clear i
elseif isequal(strcat(model), 'AGARCH')
    asym=parameters(3+z+p+q:2+z+2*p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; (resids(end-(0:(p-1))) - asym).^2; ht(end-(0:(q-1)))]; % 1-period ahead forecast
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z:2+z+p+q)'*[1; (sqrt(VF(i-1,1)) - asym).^2; VF(i-1,1)];
    end
clear i

elseif isequal(strcat(model), 'APGARCH')
    delta = parameters(3+z+p+q);
    asym=parameters(4+z+p+q:3+z+2*p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; (abs(resids(end-(0:(p-1)))) - asym*resids(end-(0:(p-1)))).^delta; ht(end-(0:(q-1))).^delta].^(1/delta); % 1-period ahead forecast
    for i = 2:max_forecast
         VF(i,1) = parameters(2+z:2+z+p+q)'*[1; (sqrt(VF(i-1,1))  - asym*sqrt(VF(i-1,1))).^delta; (VF(i-1,1)).^delta].^(1/delta);
    end
clear i

elseif isequal(strcat(model), 'NAGARCH')
    asym=parameters(3+z+p+q:2+z+2*p+q);
    VF(1,1) = parameters(2+z:2+z+p+q)'*[1; (resids(end-(0:(p-1)))*sqrt(ht(end-(0:(p-1)))) - asym).^2; ht(end-(0:(q-1)))]; % 1-period ahead forecast
    for i = 2:max_forecast
       VF(i,1) = parameters(2+z:2+z+p+q)'*[1; (sqrt(VF(i-1,1)) - asym).^2; VF(i-1,1)]
    end
    clear i
else error('Invalid GARCH Model');
end

% Estimating cumulative measures
MC = cumsum(MF);
VC = sqrt(cumsum(VF)); 

end
