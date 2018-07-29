function as_m_i(A)
%
%  Generates of the data used in 'as_m'. Data are stored in global
%  variables.
%
%  Calling sequence:
%
%    as_m_i(A)
%
%  Input:
%
%    A         real, symmetric matrix.
%
% 
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

if nargin~=1
  error('Wrong number of input arguments.');
end

if norm(A-A','fro')~=0
  error('A is not symmetric!');
end

global LP_A

LP_A = A;






