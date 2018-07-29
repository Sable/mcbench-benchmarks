function spd=diag(sp)
% sympoly/diag: diag for a sympoly vector or array, only 
% usage: spd=diag(sp);
% 
% arguments:
%  sp - matrix or vector sympoly object
%
%  spd - scalar sympoly object containing the determinant

s = size(sp);
if length(s) > 2
  error 'diag not implemented for n-d arrays'
elseif (s(1)==1) || (s(2) == 1)
  % sp is a vector, build a diagonal matrix from it
  n = length(sp);
  spd = sympoly(zeros(n,n));
  
  k = 1+(0:(n-1))*(n+1)
  spd(k) = sp(:);
  
else
  % its a 2d matrix, get the main diagonal
  k = 1 + (0:(s(2)-1))*(s(1)+1);
  spd = sp(k);
  
end


