function [prm,iprm] = lp_prm(A,E)
%
%  Reordering of SPARSE standard/generalized systems
%
%  This routine permutes the states of the system 
%    .
%    x  =  A x + B u
%    y  =  C x
%
%  or the generalized system
%      .
%    M x  =  N x + Btilde u
%      y  =  Ctilde x
%
%  such that the reordered matrix A or the reordered matrices M and N 
%  have a small bandwith. This preprocessing step is often essential 
%  for the good performance of LYAPACK routines.
%
%  Calling sequence:
%
%    [prm,iprm] = lp_prm(A)
%    [prm,iprm] = lp_prm(M,N)
%
%  Input:
%
%    A, M, N   n-x-n matrices A, M, or N (must be sparse);
%
%  Output:
%
%    prm       a vector containing a permutation of the numbers 1,...,n
%              such that the matrices A(prm,prm) or M(prm,prm) and
%              N(prm,prm) have a small bandwidth;
%    iprm      a vector containing the inverse permutation to prm.
%
%  Remarks:
%
%    The reverse Cuthill-McKee algorithm (MATLAB function 'symrcm') is
%    used to compute the permutation.
%
%    This routine is useful when implementing preprocessing routines
%    '[name]_pre'.
%
%    It might be necessary to re-reorder the data computed by certain
%    Lyapack routines (postprocessing).
% 
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

if ~issparse(A), error('A must be sparse'); end

n = size(A,1);

if nargin==1, E = []; end
if length(E)>=1
  if ~issparse(E), error('E must be sparse'); end
else
  E = sparse(n,n);
end

prm = symrcm(spones(A)+spones(E));  

iprm = zeros(size(prm)); 

for i = 1:n 
  iprm(prm(i)) = i; 
end 



