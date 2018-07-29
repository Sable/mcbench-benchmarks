function F = gumbelcml(alpha,u,v)
%FRANKCML Maximum Likelihood Function for Gumbel copula.
%   F = FRANKCML(ALPHA,U,V) returns value of Logarithm from Maximum
%   Likelihood Function multiplied by -1, for bivariate sample [U V]
%   and copula parameter ALPHA. Extension to n dimensions is straightforward.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%      [1]  Cherubini, U. and Luciano, E. and Vecchiato, W. (2004) Copula Methods in Finance,
%           "John Wiley & Sons", New York.
%

F = -sum(log( exp(-((-log(u)).^alpha + (-log(v)).^alpha).^(1./alpha)).*(-log(u)).^(alpha-1).*(-log(v)).^(alpha-1)./u./v.*((-log(u)).^alpha+(-log(v)).^alpha).^(1./alpha-2).*( ((-log(u)).^alpha+(-log(v)).^alpha).^(1./alpha) + alpha - 1 ) ));