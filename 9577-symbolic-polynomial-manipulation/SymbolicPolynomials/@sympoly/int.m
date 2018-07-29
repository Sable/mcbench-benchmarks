function sp=int(sp,intvar)
% sympoly/int: integrates a sympoly
% usage: sp=int(sp);
% usage: sp=int(sp,intvar);
% 
% arguments: (input)
%      sp - scalar sympoly object
%
%  intvar - character variable to integrate with respect to
%
% arguments: (output)
%      sp - sympoly object containing the integral polynomial

% what are the variable names in this sympoly?
polyvars = setdiff(sp.Var,{''});

% verify that intvar is a variable in this polynomial
if (nargin<2)|isempty(intvar)
  % Default variable to integrate with respect to.
  % Only if there is only one variable in the sympoly
  if length(polyvars) == 1
    intvar=polyvars{1};
  else
    error 'Variable to integrate with respect to is unspecified.'
  end
end

% check for a character variable name
if ~ischar(intvar)
  error 'intvar must be a character string'
end
% this ensures that sp is a "function" of intvar
x = sympoly(intvar);
[sp,x] = equalize_vars(sp,x);
indx=strmatch(intvar,sp.Var,'exact');

% which variable is it?
k = sp.Exponent(:,indx);

% ln(x) is not in the sympoly space
if any(k==-1)
  error 'Sympoly cannot integrate 1/x.'
end

% integration is easy
sp.Exponent(:,indx) = sp.Exponent(:,indx) + 1;
sp.Coefficient = sp.Coefficient ./ (k+1);



