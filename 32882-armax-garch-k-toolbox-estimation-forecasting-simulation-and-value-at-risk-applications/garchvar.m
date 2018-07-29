function VaR = garchvar(data, model, distr, ar, ma, p, q, max_forecast, alpha)
%{
-----------------------------------------------------------------------
 PURPOSE: 
 Value-at-Risk Estimation for both long and short positions (Model Estimation)
-----------------------------------------------------------------------
 USAGE:
 VaR = garchvar(data, model, distr, ar, ma, p, q, max_forecast, alpha)
 
 INPUTS:
 data:          (T x 1) vector of data
 model:         'GARCH', 'GJR', 'EGARCH', 'NARCH', 'NGARCH, 'AGARCH', 'APGARCH',
                'NAGARCH'
 distr:         'GAUSSIAN', 'T', 'GED', 'CAUCHY', 'HANSEN' and 'GC'  
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
 Date:     09/2011
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

% Estimate the model
[parameters, stderrors, LLF, ht, resids] = garch(data, strcat(model), strcat(distr), ar, ma, 0, p, q, 0);

% Calling garchfor2 function to pass the parameters
[MF, VF, MC, VC] = garchfor2(data, resids, ht, parameters, strcat(model), strcat(distr), ar, ma, p, q, max_forecast);

% Estimating Inverce-CDF
if isequal(distr, 'GAUSSIAN')
    cdfqtile1 = norminv(alpha);
    cdfqtile2 = norminv(1-alpha);
elseif isequal(distr, 'T')
    cdfqtile1 = tinv(alpha,parameters(end));
    cdfqtile2 = tinv(1-alpha,parameters(end));
elseif  isequal(distr, 'GED')
    cdfqtile1 = ged_inv(alpha,parameters(end));
    cdfqtile2 = ged_inv(1-alpha,parameters(end));
elseif  isequal(distr, 'CAUCHY')
    sp = fsolve('cauchy_log',[1 1],[],data); 
    cdfqtile1 = cauchy_inv(alpha, sp(1), sp(2));
    cdfqtile2 = cauchy_inv(1-alpha, sp(1), sp(2));
elseif isequal(distr, 'HANSEN')  
    lamda=parameters(end-1);
    nu=parameters(end);
    cdfqtile1 = skewt_inv(alpha, lamda, nu);
    cdfqtile2 = skewt_inv(1-alpha, lamda, nu);
elseif isequal(distr, 'GC')
    sk=parameters(end-1);
    ku=parameters(end);
    cdfqtile1 = gram_charlier_inv(alpha,0,1,sk,ku);
    cdfqtile2 = gram_charlier_inv(1-alpha,0,1,sk,ku);
end

% Estimating VaR
VaR = [MC + cdfqtile1.*VC, MC + cdfqtile2.*VC];

end
