function F = gausscml(alpha,u,v)
%GAUSSCML Maximum Likelihood Function for Gauss copula.
%   F = GAUSSCML(ALPHA,U,V) returns value of Logarithm from Maximum
%   Likelihood Function multiplied by -1, for bivariate sample [U V]
%   and correlation parameter ALPHA. Extension to n dimensions is straightforward.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%      [1]  Cherubini, U. and Luciano, E. and Vecchiato, W. (2004) Copula Methods in Finance,
%           "John Wiley & Sons", New York.

x = norminv(u);
y = norminv(v);

F = -sum(log((1-alpha^2)^(-.5)*exp((x.^2+y.^2)/2+(2*alpha*x.*y-x.^2-y.^2)/2/(1-alpha^2) )));