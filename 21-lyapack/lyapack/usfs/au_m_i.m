function au_m_i(A)
%
%  Generates of the data used in 'au_m'. Data are stored in global
%  variables.
%
%  Calling sequence:
%
%    au_m_i(A)
%
%  Input:
%
%    A         matrix.
%
% 
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

if nargin~=1
  error('Wrong number of input arguments.');
end

global LP_A

LP_A = A;






