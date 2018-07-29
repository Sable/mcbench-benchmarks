function poly=sympoly2poly(sp)
% sympoly/sympoly2poly: single variable sympoly to matlab poly form
% usage: poly=sympoly2poly(sp);
% 
% arguments:
%  sp   - sympoly object
%  poly - vector of polynomial coefficients, highest order first

% list of the variable names in this sympoly?
polyvars = setdiff(sp.Var,{''});

% check that p is a function of only one variable
if length(polyvars)>1
  error 'Roots only works on a single variable sympoly'
end

% just call the regular roots function
coef = sp.Coefficient;
xind = strmatch(polyvars{1},sp.Var,'exact');
expon = sp.Exponent(:,xind);

if all(expon>=0) && all(expon==fix(expon))
  poly = zeros(1,max(expon)+1);
  poly(max(expon)-expon+1) = coef(:)';
else
  error 'Term exponents must be non-negative integers'
end

