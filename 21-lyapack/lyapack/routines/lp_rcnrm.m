function nrm = lp_rcnrm( name, B, C0, R, Z )
%
%  Computes efficiently the Riccati norm when the approximate solution
%  is given as low rank Cholesky factor product Z*Z' :
%
%    nrm = || C0'*C0 + A'*Z*Z' + Z*Z'*A - Z*Z'*B*inv(R)*B'*Z*Z' ||_F,
%
%  Calling sequence:
%
%    nrm = lp_rcnrm( name, B, C0, R, Z )
%
%  Input:
%
%    name      basis name of the m-file which generates matrix 
%              operations with the n-x-n matrix A, e.g., 'as';
%    B         matrix B (real n-x-m matrix, m << n);
%    C0        matrix C0 (real q-x-n matrix, q << n) 
%    R         matrix R (real SPD m-x-m matrix);
%    Z         n-x-r matrix Z (may be complex). Set Z = [] if it is zero;
%
%  Output:
%
%    nrm       the Frobenius norm nrm.
%
%  User-supplied functions called by this function:
%
%    '[name]_m'    
%
%  Remark:
%
%    Note that Q0 (or Q) of the Riccati equation are already 
%    "contained" in C0.
%
%
%  LYAPACK 1.0 (Thilo Penzl, June 1999)

% Input data not completely checked!

[q,n] = size(C0);

r = size(Z,2);

if 6*r+3*q < n          % ... just a guess, maybe there is a better
                        % "switching point".
  if length(Z)
    eval(lp_e( 'M = [ C0'', ',name,'_m(''T'',Z), Z ];' ));
  else
    M = C0';
  end
  RM = triu(qr(M,0)); 
  RM = RM(1:min(size(RM)),:); 
  M = RM(:,1:q)*RM(:,1:q)';
  if length(Z)
    TM = Z'*B;
    TM = TM*(R\(TM'));
    M = M+RM(:,q+1:q+r)*RM(:,q+r+1:q+2*r)'+ ...
        RM(:,q+r+1:q+2*r)*RM(:,q+1:q+r)'- ...
        RM(:,q+r+1:q+2*r)*TM*RM(:,q+r+1:q+2*r)';
  end
  nrm = norm( M ,'fro');
  clear TM RM

else

  TM = Z*Z';
  TM1 = TM*B;
  eval(lp_e( 'TM = ',name,'_m(''T'',TM);' ));
  nrm = norm(TM+TM'+C0'*C0-TM1*(R\(TM1')),'fro');   

end
