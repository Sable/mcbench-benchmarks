function Gs = lp_trfia(freq,A,B,C,D,E)
%
%  Computes the transfer function for systems
%      .
%    E*x  =  A*x + B*u
%      y  =  C*x + D*u
%
%  on the imaginary axis (more precisely, on the points 
%  sqrt(-1)*freq(i), where i = 1,...,length(freq) ). This routine can only 
%  be applied to systems, where the matrices are given explicitely.
%
%  Calling sequence:
%
%    Gs = lp_trfia(freq,A,B,C,D,E)
%
%  Input:
%
%    freq      (row) vector containing frequency points; 
%    A         system matrix A (n-x-n matrix);
%    B         system matrix B (n-x-m matrix);
%    C         system matrix C (q-x-n matrix);
%    D         system matrix D (q-x-m matrix);
%              Set D = [] if D is not existing or the zero matrix!
%    E         system matrix E. Set E = [] if E is not existing or the 
%              (sparse) identity matrix!
%
%  Output:
%
%    Gs        transfer function sampling matrix, which is a
%              q*m-x-length(freq) matrix);
%              Gs(:,i) contains the stacked columns of the matrix
%              D + C*(sqrt(-1)*freq(i)*E-A)^(-1)*B.
%
%  Remarks:    
%
%    The vector freq can easily be computed by the function 'lp_lpfrq'.
%
%    The permutation of the matrices A and/or E before calling this
%    routine is not necessary.
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

na = nargin;

if length(A)==0,
  Gs = [];
  return;
end

if na<6, E = []; end
with_E = length(E)>0;
with_D = length(D)>0;

[n,m] = size(B);
q = size(C,1);
nop = length(freq);

if ~with_D
  D = zeros(q,m);
end

Gs = zeros(m*q,nop);

j = sqrt(-1);

for i = 1:nop
  if with_E
    G0 = D + C*(((j*freq(i))*E-A)\B);
  else
    G0 = D + C*(((j*freq(i))*speye(n)-A)\B);
  end
  for k = 1:m
    Gs((k-1)*q+1:k*q,i) = G0(:,k);
  end
end

