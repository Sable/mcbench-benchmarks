function F = tcml(theta,u,v)
%TCML Maximum Likelihood Function for t copula.
%   F = TCML(ALPHA,U,V) returns value of Logarithm from Maximum
%   Likelihood Function multiplied by -1, for bivariate sample [U V]
%   and copula parameters THETA. THETA contains correlation coefficient
%   and number of degrees of freedom. Extension to n dimensions is
%   straightforward.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%      [1]  Cherubini, U. and Luciano, E. and Vecchiato, W. (2004) Copula Methods in Finance,
%           "John Wiley & Sons", New York.

alpha = theta(1);
nu = theta(2);

x = tinv(u,nu);
y = tinv(v,nu);

F =-sum(log( (1-alpha^2)^(-.5)*gamma(nu/2+1)*gamma(nu/2)/(gamma(nu/2+.5))^2*(1-(2*alpha*x.*y-x.^2-y.^2)/nu/(1-alpha^2) ).^(-nu/2-1)./(1+x.^2/nu).^(-nu/2-.5)./(1+y.^2/nu).^(-nu/2-.5)));