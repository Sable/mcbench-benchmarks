function sp=rdivide(sp1,sp2)
% sympoly/rdivide: Elementwise divide of sympoly objects or scalars
% usage: sp=sp1./sp2;
% 
% arguments:
%  sp,sp1,sp2   - sympoly objects or numeric scalars or a numeric array

% are they of compatible sizes?
s1 = size(sp1);
s2 = size(sp2);
if all(s1 == s2) || (numel(sp1)==1) || (numel(sp2)==1)
  % they are compatible
  
  if (numel(sp1) == 1) && (numel(sp2) > 1)
    % sp1 is a scalar, but not sp2
    sp = sympoly(sp2);
    for i = 1:numel(sp2)
      sp(i) = sp1 ./ sp2(i);
    end

  elseif (numel(sp1) > 1) && (numel(sp2) == 1)
    % sp2 is a scalar, but not sp1
    sp = sympoly(sp1);
    for i = 1:numel(sp1)
      sp(i) = sp1(i) ./ sp2;
    end
    
  elseif (numel(sp1) > 1) && (numel(sp2) > 1)
    % both are arrays
    sp = sympoly(sp1);
    for i = 1:numel(sp1)
      sp(i) = sp1(i) ./ sp2(i);
    end
    
  else
    % both are scalars (at this point.)
    
    % is the numerator or denominator a numeric scalar?
    if isnumeric(sp1)
      % sp1 is numeric, convert to a sympoly
      sp1 = sympoly(sp1);
      
    elseif isnumeric(sp2)
      % sp2 is numeric, so the divide is easy
      sp=sp1;
      sp.Coefficient = sp.Coefficient./sp2;
      return
      
    end
    
    % make sure they have compatible variable lists
    [sp1,sp2]=equalize_vars(sp1,sp2);
    
    % if sp2 has only a single additive term, then
    % its a simple operation to do.
    if length(sp2.Coefficient)==1
      sp = sp1;
      sp.Coefficient = sp.Coefficient./sp2.Coefficient;
      n1 = length(sp.Coefficient);
      sp.Exponent = sp.Exponent - repmat(sp2.Exponent,n1,1);
      
      % clean up before we return
      sp = clean_sympoly(sp);
      
      return
    end
    
    % if we have dropped down this far, then it will
    % take a synthetic division to solve, if possible.
    [q,r,rflag] = syndivide(sp1,sp2);
    
    % is the remainder zero?
    if ~rflag
      sp = q;
    else
      error 'Sympoly division failed to yield a zero remainder. Use syndivide instead.'
    end
    
  end
  
else
  error 'sp1 and sp2 are of incompatible sizes for .* operation.'
  
end





