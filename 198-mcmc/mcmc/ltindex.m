% LTINDEX - Lower Triangular Index
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%  [irow, icol] = ltindex(index, dim) ;
%
% If a lower triangular matrix is packed in to a vector (column wise),
% this calculates the matching row and column in the matrix for a 
% given index and dimension. (1,p) -> (1,1), (2,p) -> (2,1),
% (p+1,p) -> (2,2), etc.
%
% See also:  LTVEC
%

function [irow, icol] = ltindex(index, dim) ;

irow = index ;

icol = 1 ;
while irow>dim & icol<= dim,
  icol = icol+1 ;
  irow = irow - dim + (icol-1) ;
end

if icol>dim,
  disp(sprintf('Error: ltindex: index=%d is too big for dim=%d',index,dim));
  irow=NaN ;
  icol=NaN ;  
end


