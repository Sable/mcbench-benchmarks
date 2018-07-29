function sp = clean_sympoly(sp,tol) 
% clean_sympoly: clean up a scalar sympoly, coallesce terms & drop excess vars
% usage: sp = clean_sympoly(sp)
% usage: sp = clean_sympoly(sp,tol)
%
%  End users of the sympoly tools should not in
%  general find a need to use clean_sympoly.
%
% arguments:
%  sp  - a scalar sympoly
%
%  tol - (OPTIONAL) scalar, relative tolerance to
%       drop essentially zero terms from the sympoly
%
%       DEFAULT: 0
%

% collect any terms that may have coallesced
if length(sp.Coefficient)>1
  [sp.Exponent,sp.Coefficient] = consolidator( ...
    sp.Exponent,sp.Coefficient,'sum');
end

% drop any variables that have all zero exponents
k = all(sp.Exponent==0,1);
if all(k)
  sp.Exponent = 0;
  sp.Var = {''};
  sp.Coefficient = sum(sp.Coefficient);
elseif any(k)
  k=find(k);
  L = cellfun('isempty',sp.Var(k));
  k(L)=[];
  
  sp.Exponent(:,k) = [];
  sp.Var(k) = [];
end

% drop any terms with a zero coefficient, unless it was
% the only term.
if numel(sp.Coefficient) > 1
  if (nargin<2) || isempty(tol)
    %    tol = eps(100);
    tol = 0;
  end
  ctol = tol*max(abs(sp.Coefficient));
  
  k = (abs(sp.Coefficient) <= ctol);
  if any(k)
    sp.Exponent(k,:)=[];
    sp.Coefficient(k,:)=[];
  end
end

% check for a degenerate sympoly
if isempty(sp.Coefficient)
  % its zero
  sp.Var = {''};
  sp.Exponent = 0;
  sp.Coefficient = 0;
end


