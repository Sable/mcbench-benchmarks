% LTVEC - Change a Lower-Triangular Matrix into a Vector
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [V] = ltvec(M) 
%
% M = square matrix, only the diagonal and lower triangle is used.
% 
% V = vector to be returned
%
%   If M is a p x p matrix, then V consists of 
%   [ M(:,1) ; M(2:p,2) ; M(3:p,3), etc. ]
%
% See also: LTINDEX

function [v] = ltvec(m) 

[p,nc] = size(m) ;

if p==0,
  v = [] ;
else 
  for ic = 1:p,
    if ic==1,
      v = m(:,1) ;
    else
      v = [ v ; m(ic:p,ic) ] ;
    end 
  end
end
