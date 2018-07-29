function sp=plus(sp1,sp2)
% sympoly/plus: Adds two sympoly objects, or adds a numeric var to a sympoly
% usage: sp = sp1 + sp2;
% 
% arguments:
%  sp,sp1,sp2 - sympoly objects or scalars

% are we adding scalar objects or arrays?
s1 = numel(sp1);
s2 = numel(sp2);

% make sure both sp1 and sp2 are sympoly objects
if ~isa(sp1,'sympoly')
  sp1 = sympoly(sp1);
end
if ~isa(sp2,'sympoly')
  sp2 = sympoly(sp2);
end

if (s1>1) && (s2 == 1)
  % s1 is an array or vector, s2 is a scalar
  sp = sp1;
  for i = 1:s1
    sp(i) = sp(i) + sp2;
  end
  
elseif (s1 == 1) && (s2 > 1)
  % s1 is an array or vector, s2 is a scalar
  sp = sp2;
  for i = 1:s2
    sp(i) = sp1 + sp(i);
  end
  
elseif (s1 > 1) && (s2 > 1)
  % s1 and s2 are both arrays or vectors
  
  % verify they are compatible in size
  if any(size(sp1)~=size(sp2))
    error 'Addition attempted on sympoly arrays of incompatible size'
  end
  
  % add elementwise
  sp = sp1;
  for i = 1:s1
    sp(i) = sp(i) + sp2(i);
  end
  
elseif (s1==0) || (s2==0)
  % one must have been empty
  error 'Cannot add an empty array to a sympoly.'
  
else
  % both must be scalars, and both were forced to be sympolys
  
  % make sure they have compatible variable sets
  [sp1,sp2] = equalize_vars(sp1,sp2);
  
  % the addition just requires appending the arrays, then a
  % call to consolidator
  sp = sp1;
  sp.Exponent = [sp.Exponent;sp2.Exponent];
  sp.Coefficient = [sp.Coefficient;sp2.Coefficient];
  
  % clean up the poly
  sp = clean_sympoly(sp);
  
end

