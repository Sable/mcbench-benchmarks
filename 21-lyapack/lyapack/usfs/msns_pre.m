function [M,MU,N,B,C,prm,iprm] = msns_pre(M,N,B,C)
%
%  Preprocessing of the system
%      .
%    M x  =  N x + B u                  
%                                                             (1)
%      y  =  C x,
%
%  where both M and N are REAL, SYMMETRIC and SPARSE. Moreover, M must be 
%  positive definite and N must be negative definite.
%
%  The preprocessing consists of a double transformation of the state: 
%
%    x <-- MU * P * x .
%
%  The first transformation with the permutation matrix P for bandwidth 
%  reduction results in "overwriting" the system matrices as
%
%    M <-- P * M * P',  N <-- P * N * P',  B <-- P * B,  C <-- C * P'.
%
%  The bandwidth of the reordered matrices M and N is often much smaller 
%  than that of the original matrices. 
%
%  By the second transformation, the generalized system (1) is transformed
%  into a standard system
%      .
%      x  =  A x + B u                  
%                                                             (2)
%      y  =  C x.
%
%  To this end, the Cholesky factorization of M is computed: M = MU'*MU,
%  where MU is upper triangular. This results in:
%               
%    A := inv(MU')*N*inv(MU),  B <-- inv(MU')*B,  C <-- C*inv(MU).
%
%  The matrix A, which is dense in general, is not formed explicitely. 
%  It is implicitely given by N and MU.
%
%  Note that the systems (1) and (2) have an identical input-output
%  mapping.
%
%  Calling sequence:
%
%    [M,MU,N,B,C,prm,iprm] = msns_pre(M,N,B,C)
%
%  Input:
%
%    M, N      n-x-n system matrices; 
%    B         n-x-m system matrix;
%    C         q-x-n system matrix.
%
%  Output:
%
%    M         permuted matrix M;
%    MU        Cholesky factor of (permuted) matrix M;
%    N         permuted matrix N;
%    B, C      transformed system matrices;
%    prm       the permutation that has been used in the first 
%              transformation step;
%    iprm      the inverse permutation (needed to re-reorder certain data
%              in postprocessing).
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

if any(any(imag(M))) | any(any(imag(N))) | any(any(imag(B))) | ...
    any(any(imag(C)))
  disp('WARNING in ''msns_pre'': M, N, B, and C must be real matrices.');
  pause(10);
end 

if norm(M-M','fro')~=0
  error('M is not symmetric!');
end

if norm(N-N','fro')~=0
  error('N is not symmetric!');
end

[prm,iprm] = lp_prm(M,N);

M = M(prm,prm);
N = N(prm,prm);

[MU,t] = chol(M);

if t~=0
  error('M is not (numerically) positive definite!');
end

if length(B)
  B = MU'\B(prm,:);
end

if length(C)
  C = C(:,prm)/MU;
end
