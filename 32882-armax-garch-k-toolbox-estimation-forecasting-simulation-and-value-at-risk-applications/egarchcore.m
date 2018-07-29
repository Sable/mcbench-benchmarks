function [mu h]=egarchcore(parameters, data, ar, ma, x, p, q, y, m, z, v, T)
%-----------------------------------------------------------------------
% PURPOSE:
% Estimation of conditional mean and variance of the E-GARCH formulation
%-----------------------------------------------------------------------
% USAGE:
% [mu,h] = garchcore(parameters, data, p, q, m, T)
%
% INPUTS:
% parameters:	vector of parameters
% data:         (T x 1) vector of data
% ar:        positive scalar integer representing the order of AR
% am:        positive scalar integer representing the order of MA
% x:         (T x N) vector of factors for the mean process
% p:         positive scalar integer representing the order of ARCH
% q:         positive scalar integer representing the order of GARCH
% y:         (T x N) vector of factors for the volatility process, must be positive!
%
% OUTPUTS:
% mu:           conditional mean
% h:            conditional variance
%-----------------------------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date:     09/2008
% Update 1: 08/2011: ARMA-X Support
%-----------------------------------------------------------------------

% Verifying that the vector of parameters is a column vector
[r,c] = size(parameters);
if c>r
    parameters = parameters';
    [r,c] = size(parameters);
end

% Initial parameters
mu = [];
h = [];
mu(1:m,1) = parameters(1);
h(1:m,1) = std(data);

% Dimension of factors
if isscalar(x)
    xy=zeros(size(data,1),1);    
else
    xy=x;
end

if isscalar(y)
    yy=zeros(size(data,1),1);    
else
    yy=y;
end

% Estimation of Conditional Mean and Variance
for t = (m+1):T; 
    mu(t,1) = parameters(1:1+z)'*[1; data(t-(1:ar)); data(t-(1:ma))-mu(t-(1:ma),1); xy(t,:)'*ones((isscalar(x) < 1))];
    h(t,1) = exp(parameters(2+z:2+z+2*p+q+v)'*[1 ; (abs(data(t-(1:p)) - mu(t-(1:p)))/sqrt(h(t-(1:p)))-sqrt(2/pi)); log(h(t-(1:q))); yy(t,:)'*ones((isscalar(y) < 1));(data(t-(1:p))- mu(t-(1:p)))/sqrt(h(t-(1:p)))]);
end

end