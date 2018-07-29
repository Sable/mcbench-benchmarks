function c = transposeLTI(a)
%function c = transposeLTI(a)
%  The transpose of an LTI a
%  Where the pulsrespons at time
%  t is denoted
%  a(:,:,t)
%
%  The transpose is given by:
%
%  c(:,:,t) = a(:,:,-t)'
%  The indexes of c are shifted
%  until it starts at t=1.
%
% See also FILTERV.


c = flipdim(permute(a,[2 1 3]),3);
