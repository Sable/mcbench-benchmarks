function F = frankcml(alpha,u,v)
%FRANKCML Maximum Likelihood Function for Frank copula.
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

F = -sum(log(-alpha*exp(-alpha*(u+v)).*(exp(-alpha)-1)./(exp(-alpha)-1+(exp(-alpha*u)-1).*(exp(-alpha*v)-1)).^2 ));