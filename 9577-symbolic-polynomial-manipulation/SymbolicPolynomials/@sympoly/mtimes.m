function sp=mtimes(sp1,sp2)
% sympoly/mtimes: Matrix multiplication of sympoly objects or scalars
% usage: sp=sp1*sp2;
% 
% arguments:
%  sp,sp1,sp2   - sympoly objects or numeric scalars or a numeric array

% are they of compatible sizes?
s1 = size(sp1);
s2 = size(sp2);
if (length(s1)>2) || (length(s2)>2)
  error 'Matrix multiplication is only defined for vectors and simple arrays.'
end

if (s1(2) == s2(1)) || (numel(sp1)==1) || (numel(sp2)==1)
  % they are compatible
  
  if (numel(sp1) == 1) && (numel(sp2) == 1)
    % both are scalars. Just use .*
    sp = sp1.*sp2;
    
  elseif (numel(sp1) == 1) && (numel(sp2) > 1)
    % sp1 is a scalar, but not sp2
    sp = sympoly(sp2);
    for i = 1:numel(sp2)
      sp(i) = sp1.*sp2(i);
    end

  elseif (numel(sp1) > 1) && (numel(sp2) == 1)
    % sp2 is a scalar, but not sp1
    sp = sympoly(sp1);
    for i = 1:numel(sp1)
      sp(i) = sp1(i).*sp2;
    end
    
  elseif (numel(sp1) > 1) && (numel(sp2) > 1)
    % both are arrays.
    sp = sympoly(zeros(s1(1),s2(2)));

    for i = 1:s1(1)
      for j = 1:s2(2)
        for k = 1:s1(2)
          sp(i,j) = sp(i,j) + sp1(i,k).*sp2(k,j);
        end
      end
    end
    
  end
  
else
  error 'sp1 and sp2 are of incompatible sizes for .* operation.'
  
end





