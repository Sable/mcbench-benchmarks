% VECLT - change a vector into a lower-triangular matrix
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [M] = ltvec(V) 
%
% V = vector argument
%
% M = square, symmetric matrix
% 
%   If M is a p x p matrix, then V consists of 
%   [ M(:,1) ; M(2:p,2) ; M(3:p,3) ; etc. ]
%
% See also: LTVEC, LTINDEX, MCMCLT

function [m] = ltvec(v) 

[ll,oo] = size(v) ;

p = floor(sqrt(2*ll)) ;

ix = 0 ;
il = p ;
m = NaN * zeros(p) ;

for ic = 1:p,
  m ( (ic:p) , ic ) = v ( (ix+1:ix+il) ) ;
  m ( ic, ((ic+1):p)) = m(((ic+1):p),ic)' ;
  ix = ix + il ;
  il = il - 1 ;
end



