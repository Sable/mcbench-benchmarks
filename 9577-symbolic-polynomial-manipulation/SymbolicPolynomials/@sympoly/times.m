function sp=times(sp1,sp2)
% sympoly/times: Elementwise multiplication of sympoly objects or scalars
% usage: sp=sp1.*sp2;
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
      sp(i) = sp1 .* sp2(i);
    end

  elseif (numel(sp1) > 1) && (numel(sp2) == 1)
    % sp2 is a scalar, but not sp1
    sp = sympoly(sp1);
    for i = 1:numel(sp1)
      sp(i) = sp1(i) .* sp2;
    end
    
  elseif (numel(sp1) > 1) && (numel(sp2) > 1)
    % both are arrays
    sp = sympoly(sp1);
    for i = 1:numel(sp1)
      sp(i) = sp1(i) .* sp2(i);
    end
    
  else
    % both are scalars.
    
    % is one a numeric scalar?
    if isnumeric(sp1)
      % sp1 is numeric, so the multiply is easy
      if sp1 ~= 0
        sp=sp2;
        sp.Coefficient = sp1.*sp.Coefficient;
      else
        % its a zero
        sp = sympoly(0);
      end
      return
      
    elseif isnumeric(sp2)
      % sp2 is numeric, so the multiply is easy
      if sp2 ~= 0
        sp=sp1;
        sp.Coefficient = sp2.*sp.Coefficient;
      else
        % its a zero
        sp = sympoly(0);
      end
      return
      
    end
    
    % make sure they have compatible variable lists
    [sp1,sp2]=equalize_vars(sp1,sp2);
    
    n1 = length(sp1.Coefficient);
    n2 = length(sp2.Coefficient);
    nv = length(sp1.Var);
    
    sp = sp1;
    sp.Exponent = zeros(n1*n2,nv);
    sp.Coefficient = zeros(n1*n2,1);
    L = (1:n2)';
    for i = 1:n1
      sp.Exponent(L,:) = sp2.Exponent + ...
         repmat(sp1.Exponent(i,:),n2,1);
      
      sp.Coefficient(L,1) = sp2.Coefficient*sp1.Coefficient(i,1);

      L=L+n2;
    end
      
    % clean up the poly
    sp = clean_sympoly(sp);
    
  end
  
else
  error 'sp1 and sp2 are of incompatible sizes for .* operation.'
  
end





