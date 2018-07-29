function dpdx=diff(sp,n,dvar)
% sympoly/diff: differentiates a symbolic polynomial
% usage: dpdx=diff(sp);
% usage: dpdx=diff(sp,dvar);
% usage: dpdx=diff(sp,n,dvar);
% 
% arguments: (input)
%   sp - sympoly object
%
%    n - (OPTIONAL) - integer - order of differentiation
%        Default: n = 1
%
%  dvar - character - variable name to differentiate with respect to
%
% arguments: (output)
%   dpdx - sympoly object containing the derivative polynomial

% a scalar sympoly?
np = numel(sp);
if np > 1
  dpdx = sp;
  for i=1:np
    switch nargin
    case 1
      dpdx(i)=diff(sp(i));
    case 2
      dpdx(i)=diff(sp(i),n);
    case 3
      dpdx(i)=diff(sp(i),n,dvar);
    end
  end
  return
end

% what are the variable names in this sympoly?
polyvars = setdiff(sp.Var,{''});

% differentiate with respect to which variable?
% also, set the order of differentiation
if (nargin==1)
  if length(polyvars) == 1
    dvar = polyvars{1};
    n = 1;
  else
    error 'Please supply a variable to differentiate with respect to'
  end
elseif (nargin==2) && isnumeric(n)
  if length(polyvars) == 1
    dvar = polyvars{1};
  else
    error 'Please supply a variable to differentiate with respect to'
  end
elseif (nargin==2) && ischar(n)
  % they supplied a variable name, assume the default for n = 1
  dvar = n;
  n = 1;
end

% if the order of differentiation is not 1, then just loop
if (n ~= floor(n)) || (n<1)
  error 'Differentiation order must be a positive integer.'
elseif n>1
  % recursive calls to diff for higher orders
  dpdx = sp;
  for i = 1:n
    dpdx = diff(dpdx,1,dvar);
  end
  
  return
end

% if we drop through to here, the differentiation order is 1, 
% and we know what we are differentiating with respect to,
% lastly, we kow that sp is a scalar sympoly.

% check for a variable name
if ~ischar(dvar)
  error 'dvar must be a character string'
end

% is sp a function of the designated variable?
indx=strmatch(dvar,sp.Var,'exact');
if isempty(indx)
  % sp is not a function of that variable, so the derivative
  % will be zero.
  dpdx = sympoly(0);
  return
end

% actual differentiation at this point is simple.
dpdx = sp;
k = sp.Exponent(:,indx);

dpdx.Exponent(k==0,:) = [];
dpdx.Coefficient(k==0) = [];
k(k==0) = [];

if isempty(k)
  % the derivative was zero
  dpdx = sympoly(0);
else
  % there are some terms that remain
  dpdx.Exponent(:,indx) = k-1;
  dpdx.Coefficient = dpdx.Coefficient.*k;
end

% clean up the poly
dpdx = clean_sympoly(dpdx);




