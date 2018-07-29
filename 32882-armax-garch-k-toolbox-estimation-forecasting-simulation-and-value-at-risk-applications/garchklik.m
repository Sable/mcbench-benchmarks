function [LLF,likelihoods,h,k,n,resid] = garchklik(parameters, data, garchtype, ar, ma, x, p, q, y, m, z, v, T)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Estimation of the LogLikelihood Function for GARCH-K Model
-----------------------------------------------------------------------
 USAGE:
 [LLF,likelihoods,h,resid] = garchlik(parameters, data, garchtype,
 errortype, p, q, m, T)

 INPUTS:
 parameters:	vector of parameters
 data:         (T x 1) vector of data
 garchtype:    (1, 2, 3,...) depending the specification
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
 k:           vector of conditional kurtosis
 resid:       vector of residuals
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     11/2011
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

% Estimate Model
[mu,h, k, n] = garchkcore(parameters,data, ar, ma, x, p, q, y, m, z, v, T, garchtype);

% Estimate Likelihood
likelihoods = +gammaln((n(t)+1)./2) - gammaln(n(t)./2) - 0.5*log(n(t)-2) - 0.5*(log(h(t))) - ((n(t)+1)./2).*(log(1 + ((data(t)-mu(t)).^2)./(h(t).*(n(t)-2))));

likelihoods = -likelihoods;
LLF=sum(likelihoods);

if isnan(LLF) | isinf(LLF)
    LLF=1e06;
end

resid=data(t)-mu(t);
h=h(t);
nu=n(t);
k=k(t);
end