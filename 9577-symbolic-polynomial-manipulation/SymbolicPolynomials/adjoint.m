function M = adjoint(A)
% adjoint:  (conjugate) transpose of cofactor matrix of a square matrix
% usage: M = adjoint(A)
%
% arguments: (input)
%  A - Any square double or sympoly array
%
%  M - The adjoint of A
%
% See also inv
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.3
% Release date: 10/18/06

[n,m] = size(A);
if n~=m
  error 'A is not a square matrix.'
end

M = A;
for i = 1:n
  ii = setdiff(1:n,i);
  for j = 1:n
    jj = setdiff(1:n,j);
    M(j,i) = (-1)^(i+j)*det(A(ii,jj));
  end
end

% Just in case M is complex
M = conj(M);
