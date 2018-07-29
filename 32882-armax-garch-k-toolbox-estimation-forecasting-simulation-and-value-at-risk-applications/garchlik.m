function [LLF,likelihoods,h,resid] = garchlik(parameters, data, garchtype, errortype, ar, ma, x, p, q, y, m, z, v, T)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Estimation of the LogLikelihood Function for 
 various GARCH models with different distributions
-----------------------------------------------------------------------
 USAGE:
 [LLF,likelihoods,h,resid] = garchlik(parameters, data, garchtype,
 errortype, p, q, m, T)

 INPUTS:
 parameters:	vector of parameters
 data:         (T x 1) vector of data
 garchtype:    (1, 2, 3,...) depending the specification
 errortype:    (1, 2, 3,...) depending the distribution
 ar:        positive scalar integer representing the order of AR
 am:        positive scalar integer representing the order of MA
 x:         (T x N) vector of factors for the mean process
 p:         positive scalar integer representing the order of ARCH
 q:         positive scalar integer representing the order of GARCH
 y:         (T x N) vector of factors for the volatility process, must be positive!

 OUTPUT:
 LLF:         the value of the Log-likelihood Function
 likelihoods: vector of log-likelihoods
 h:           vector of conditional variance
 resid:       vector of residuals
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     09/2008
 Update 1: 06/2010: Added Student's t- and GED distributions
 Update 2: 10/2010: Added the following models and distributions:
                    NARCH, NGARCH, AGARCH, APGARCH, NAGARCH, 
                    Hansen Skew-t Distribution and Gram-Charlier Expansion
 Update 3: 08/2011: Added ARMA X family of models
-----------------------------------------------------------------------
%}

% Verifying that the vector of parameters is a column vector
[r,c] = size(parameters);
if c>r
    parameters = parameters';
    [r,c] = size(parameters);
end

t = (m+1):T;
likelihoods = [];

if errortype == 2 | errortype == 3
    nu = parameters(end);
elseif errortype == 5
    lamda = parameters(end-1);
    nu = parameters(end);
    c = gamma((nu+1)/2)/(sqrt(pi*(nu-2))*gamma(nu/2));
    a = 4*lamda*c*((nu-2)/(nu-1));
    b = 1 + 3*lamda^2 - a^2;
elseif errortype == 6
    sk = parameters(end-1);
    ku = parameters(end);
elseif errortype == 11 | errortype == 12
    g = parameters(end);
end

% Estimation of conditional mean and variance of various specifications 
% given a set of parameters
switch garchtype
    case 1 % GARCH
        [mu,h] = garchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 2 % GJR
        [mu,h] = gjrcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 3 % EGARCH
        [mu,h] = egarchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 4 % NARCH
        [mu,h] = narchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 5 % NGARCH
        [mu,h] = ngarchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 6 % AGARCH
        [mu,h] = agarchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 7 % APGARCH
        [mu,h] = apgarchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
    case 8 % NAGARCH
        [mu,h] = nagarchcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T);
end

% Estimation of the Log-Likelihood Function for the various distributions
switch errortype
    case 1 % GAUSSIAN
        %LLF  =  0.5*(sum(log(h(t))) + sum(((data(t)-mu(t)).^2)./h(t)) + (T-m)*log(2*pi)); 
        likelihoods = -0.5*((log(h(t))) + (((data(t)-mu(t)).^2)./h(t)) + log(2*pi));
    case 2 % STUDENT's t-Distribution
        % First Approach is a two step approach,(see Christoffersen, 2003, for more details)
        %ratio1 = (gamma((nu+1)*.5))/gamma((nu)*.5);
        %likelihoods = log(ratio1) - 0.5*log(pi*(nu-2)) - 0.5*((log(h(t)))) - 0.5*(nu+1)*(log((1+((data(t)-mu(t)).^(2))./((h(t)).*(nu-2)))));

        % Second Approach is a direct one step estimation approach
        %LLF = -(T-m)*gammaln(0.5*(nu+1)) + (T-m)*gammaln(nu/2) + (T-m)/2*log(pi*(nu-2)) + 0.5*sum(log(h(t))) + ((nu+1)/2)*sum(log(1+((data(t)-mu(t)).^2)./(h(t)*(nu-2))));
        likelihoods = +gammaln(0.5*(nu+1)) - gammaln(nu/2) - 0.5*log(pi*(nu-2)) - 0.5*(log(h(t))) - ((nu+1)/2)*(log(1 + ((data(t)-mu(t)).^2)./(h(t).*(nu-2))));
    case 3 % GED
        beta = (2^(-2/nu) * gamma(1/nu)/gamma(3/nu))^(0.5);
	    likelihoods = (log(nu)/(beta*(2^(1+1/nu))*gamma(1/nu))) - 0.5*(log(h(t)))- 0.5*((abs((data(t)-mu(t))./(sqrt(h(t))*beta))).^nu);
    case 4 % Cauchy Lorentz
        likelihoods = - log(pi) + log(sqrt(h(t))) - log(h(t) + (data(t)-mu(t)).^2);
    case 5 % Hansen's Skew t-Distribution
        indicator1 = ((data(t)-mu(t))./sqrt(h(t))<-a./b);
        indicator2 = ((data(t)-mu(t))./sqrt(h(t))>=-a./b);
        likelihoods1 = log(b) + log(c) - ((nu+1)./2).*log(1+1./(nu-2).*((b.*indicator1.*((data(t)-mu(t))./sqrt(h(t)))+a)./(1-lamda)).^2);
        likelihoods2 = log(b) + log(c) - ((nu+1)./2).*log(1+1./(nu-2).*((b.*indicator2.*((data(t)-mu(t))./sqrt(h(t)))+a)./(1+lamda)).^2); 
        likelihoods = - 0.5*log(h(t)) + indicator1.*likelihoods1 + indicator2.*likelihoods2;
    case 6 % Gram-Charlier
        % Gram-Charlier Expansion Series
        % f = log((1 + (sk.*((data(t)-mu(t))./sqrt(h(t))).^3 - 3*(data(t)-mu(t))./sqrt(h(t)))./6 + (ku.*(((data(t)-mu(t)./sqrt(h(t))).^4-6*((data(t)-mu(t))./sqrt(h(t))).^2+3))./24)));
        % likelihoods = -0.5*((log(h(t))) +(((data(t)-mu(t)).^2)./h(t)) + log(2*pi)) + f;  
        % However for some skewness and kurtosis parameters the GC pdf becomes negative, 
        % therefore another approach is to estimate the following specification proposed by:
        % Leon, Rubio and Serna (2004) Autoregressive Conditional Variance, Skewness and Kurtosis and
        % Brio, and Níguez, and Perote (2007) Multivariate Gram-Charlier Densities
        f = log((1 + (sk./6)*(((data(t)-mu(t))./sqrt(h(t))).^3 - 3*((data(t)-mu(t))./sqrt(h(t)))) + ((ku).*(((data(t)-mu(t)./sqrt(h(t))).^4-6*((data(t)-mu(t))./sqrt(h(t))).^2+3))./24)).^2);
        g = log(1+ (sk^2)/6 + ((ku)^2)/24);
        likelihoods = -0.5*((log(h(t))) + (((data(t)-mu(t)).^2)./h(t)) + log(2*pi)) + f - g;   
    case 7 % Logistic
        likelihoods = (data(t) - mu(t))./sqrt(h(t)) - 0.5*log(h(t)) - 2*log(1+exp((data(t) - mu(t))./sqrt(h(t))));
    case 8 % Laplace
        likelihoods1 = (-log(2*sqrt(h(t))) - (mu(t) - data(t))./sqrt(h(t))).*(data(t)<mu(t));
        likelihoods2 = (-log(2*sqrt(h(t))) - (-mu(t) + data(t))./sqrt(h(t))).*(data(t)>=mu(t));
        likelihoods = likelihoods1 + likelihoods2;
    case 9 % Rayleigh
        likelihoods = (log((data(t)-mu(t))./h(t)) - ((data(t)-mu(t)).^2)./(2.*h(t))).*((data(t)-mu(t))>=0);
    case 10 % Gumbel
        likelihoods = (data(t)-mu(t))./sqrt(h(t)) + exp(-(data(t)-mu(t))./sqrt(h(t)));       
    case 11 % Voigt 
        likelihoods = -0.5*((log(h(t))) + (((data(t)-mu(t)).^2)./h(t)) + log(2*pi)) + log(g) - log((data(t)-mu(t)).^2 + g^2); 
    case 12 % Centered Cauchy
        likelihoods = log(2*pi) + log(g) - log((data(t)-mu(t)).^2 + g^2);
    case 13 % Extreme value distribution Type 1
        likelihoods =  -0.5*log(h(t)) + (data(t) - mu(t))./sqrt(h(t)) - exp(((data(t) - mu(t)))./sqrt(h(t)));
    case 14 % Generalized Exponential Distribution
        likelihoods =   -0.5*log(h(t)) - abs(data(t) - mu(t))./sqrt(h(t));       
        
end

likelihoods = -likelihoods;
LLF=sum(likelihoods);

if isnan(LLF) | isinf(LLF)
    LLF=1e06;
end

resid=data(t)-mu(t);
h=h(t); 
end