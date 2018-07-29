function [p mlv]=cmlstat(family,x)
%CMLSTAT Estimates copula parameter(s), given sample X.
%   [P MLV] = CMLSTAT(FAMILY,X) returns estimated copula parameters and
%   value of Logarithm of Maximum Likelihood Function for copula
%   determined by FAMILY and bivariate sample X. Extension to n dimensions
%   is straightforward. Estimation is performed using Canonical Maximum
%   Likelihood Method and property that max(x) = -min(-x). Marginal
%   distributions are transformed into uniform margins using empirical
%   distribution functions. 
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%      [1]  Cherubini, U. and Luciano, E. and Vecchiato, W. (2004) Copula Methods in Finance,
%           "John Wiley & Sons", New York.

C = corr(x(:,1),x(:,2),'type','kendall');

[f y]=ecdf(x(:,1));
for i=2:length(y)
    x(find(x(:,1)==y(i)),1)=f(i); %produce empirical distribution function
end

[f y]=ecdf(x(:,2));
for i=2:length(y)
    x(find(x(:,2)==y(i)),2)=f(i); %produce empirical distribution function
end
x=x-eps; %to avoid x==1

switch family
    case 'clayton'
        theta = copulaparam('clayton',C);
        [p mlv] = fminsearch('claytoncml',theta,[],x(:,1),x(:,2));
    case 'frank'
        theta = copulaparam('frank',C);
        [p mlv] = fminsearch('frankcml',theta,[],x(:,1),x(:,2));
    case 'gumbel'
        theta = copulaparam('gumbel',C);
        [p mlv] = fminsearch('gumbelcml',theta,[],x(:,1),x(:,2));
    case 'gauss'
        theta = copulaparam('gauss',C);
        [p mlv] = fminsearch('gausscml',theta,[],x(:,1),x(:,2));
    case 't'
        theta = copulaparam('t',C);
        [p mlv] = fminsearch('tcml',[theta 10],[],x(:,1),x(:,2));
    otherwise
        error('Unrecognized copula family: ''%s''',family);
end
mlv = -mlv;  % max(x) = -min(-x)