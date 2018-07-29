function [polymean,polyvar] = polyerrorprop(SP,varnames,means,stds)
% polyerrorprop: compute symbolic mean and variance for a sympoly, given normal components
% usage: [polymean,polyvar] = polyerrorprop(SP,varnames,means,stds)
%
% arguments: (input)
%  SP -    general sympoly expression of one or more variables
%
%  varnames - the (string) name of a variable as found in SP.
%          If multiple variables are to be toleranced over, then
%          varnames must be a cell array of strings.
%
%  means - a vector of variable means, one for each name in varnames
%          means may be a vector of doubles, or it may be a vector of
%          sympoly objects.
% 
%  stds  - a vector of variable standard deviations, one for each name
%          in stds. stds may be a vector of doubles, or it may be a
%          vector of sympoly objects.
% 
% arguments: (output)
%   polymean - the expected value of SP as a sympoly itself, given
%          independent normally distributed variables as given by
%          the input arguments.
%
%   polyvar - the variance of the polynomial SP asa sympoly itself.
%
%
% Example:
% Given a unit Normal N(0,1) random variable, compute the
% mean and variance of p(x) = 3*x + 2*x^2 - x^3
% 
%  sympoly x
%  polyerrorprop(3*x + 2*x^2 - x^3,'x',0,1);
%
% polymean =
%  A scalar sympoly object
%    2
%
% polyvar = 
%  A scalar sympoly object
%    14
%
%
% Example:
% Given Normal random variables, x and y, where x is N(mux,sx^2)
% and y has parameters N(muy,sy^2), compute the mean and variance
% of x*y.
%
%  sympoly x y mux muy sx sy
%  [polymean,polyvar] = polyerrorprop(x*y,{'x' 'y'},[mux,muy],[sx,sy])
%
% polymean =
%  A scalar sympoly object
%    mux*muy
%
% polyvar =
% A scalar sympoly object
%    sx^2*sy^2 + muy^2*sx^2 + mux^2*sy^2
%
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 1/28/08

% verify that SP is a sympoly
if ~isa(SP,'sympoly')
  error('SP must be a scalar sympoly object.')
end

% was there only one variable provided?
if ischar(varnames)
  varnames = {varnames};
end
nvars = length(varnames);

means = means(:);
stds = stds(:);

if length(means)~=nvars
  error('means was incompatible in length with the variable list provided')
elseif length(stds)~=nvars
  error('stds was incompatible in length with the variable list provided')
end

% substitute into the polynomial for unit normal variables,
% computing the mean of SP.
polymean = SP;
for i = 1:nvars
  % substitute for
  % X_i = means(1) + stds(i)*u
  tempvarname = ['_',varnames{i},'_'];
  tempvar = sympoly(tempvarname);
  polymean = subs(polymean,varnames{i},means(i) + stds(i)*tempvar);
  
  % which variable was tempvar in polymean?
  k = find(ismember(polymean.Var,tempvarname));
  
  % now integrate over the temporary variable, using the information
  % that for a unit Normal variate, the kth central moment is zero
  % for the odd moments. For the even moments, the (2*k)th central
  % moment is 
  %
  % factorial(2*k)/(2^k*factorial(k))
  
  % so we can now delete all the terms in polymean with an odd exponent
  % for the tempvar.
  Exponents = polymean.Exponent;
  Coefficients = polymean.Coefficient;
  
  oddexp = mod(Exponents(:,k),2) == 1;
  if any(oddexp)
    Exponents(oddexp,:) = [];
    Coefficients(oddexp) = [];
    polymean.Exponent = Exponents;
    polymean.Coefficient = Coefficients;
    % did we just now kill off everything?
    if isempty(Coefficients)
      polymean.Coefficient = 0;
      polymean.Exponent = zeros(1,numel(polymean.Var));
    end
  end
  
  % do the even moments.
  evenexp = polymean.Exponent(:,k)/2;
  
  varmoment = factorial(2*evenexp)./(2.^evenexp.*factorial(evenexp));
  polymean.Coefficient = polymean.Coefficient.*varmoment;
  
  % now, kill off the tempvar in the sympoly
  Exponents = polymean.Exponent;
  Exponents(:,k) = 0;
  polymean.Exponent = Exponents;
  
  % and clean up the sympoly
  polymean = clean_sympoly(polymean);
end

% Now compute the variance polynomial
% V(f) = E((f(x) - E(f))^2)
polyvar = (SP - polymean);
polyvar = polyvar*polyvar;
% and now do the same process as above, integrating out the unit normals
for i = 1:nvars
  % substitute for
  % X_i = means(1) + stds(i)*u
  tempvarname = ['_',varnames{i},'_'];
  tempvar = sympoly(tempvarname);
  polyvar = subs(polyvar,varnames{i},means(i) + stds(i)*tempvar);
  
  % which variable was tempvar in polyvar?
  k = find(ismember(polyvar.Var,tempvarname));
  
  % now integrate over the temporary variable, using the information
  % that for a unit Normal variate, the kth central moment is zero
  % for the odd moments. For the even moments, the (2*k)th central
  % moment is 
  %
  % factorial(2*k)/(2^k*factorial(k))
  
  % so we can now delete all the terms in polyvar with an odd exponent
  % for the tempvar.
  Exponents = polyvar.Exponent;
  Coefficients = polyvar.Coefficient;
  
  oddexp = mod(Exponents(:,k),2) == 1;
  if any(oddexp)
    Exponents(oddexp,:) = [];
    Coefficients(oddexp) = [];
    polyvar.Exponent = Exponents;
    polyvar.Coefficient = Coefficients;
  end
  
  % do the even moments.
  evenexp = polyvar.Exponent(:,k)/2;
  
  varmoment = factorial(2*evenexp)./(2.^evenexp.*factorial(evenexp));
  polyvar.Coefficient = polyvar.Coefficient.*varmoment;
  
  % now, kill off the tempvar in the sympoly
  Exponents = polyvar.Exponent;
  Exponents(:,k) = 0;
  polyvar.Exponent = Exponents;
  
  % and clean up the sympoly
  polyvar = clean_sympoly(polyvar);
end

  
