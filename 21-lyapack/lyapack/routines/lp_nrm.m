function nrm = lp_nrm( tp, name, Bf, Kf, G, Z )
%
%  Computes efficiently either of the following norms provided that 
%  Z has much more rows than columns: 
%
%  for tp = 'B':
%
%    nrm = || F*Z*Z' + Z*Z'*F' + G*G' ||_F,
%
%  for tp = 'C':
%
%    nrm = || F'*Z*Z' + Z*Z'*F + G'*G ||_F.
%
%  Here, F = A-Bf*Kf'. Z may be complex.
%
%  Calling sequence:
%
%    nrm = lp_nrm(tp,name,Bf,Kf,G,Z)
%
%  Input:
%
%    tp        (= 'B' or 'C') the type of the norm;
%    name      basis name of the m-file which generates matrix 
%              operations with A, e.g., 'as';
%    Bf        matrix Bf;
%              Set Bf = [] if not existing or zero!
%    Kf        matrix Kf;
%              Set Kf = [] if not existing or zero!
%    G         n-x-m or m-x-n matrix G (must be real);       
%    Z         n-x-r matrix Z (may be complex).
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
%    This routine is useful if the residual norm should be computed only
%    once (for example, after the iteration).
%
%    If a sequence of norms must be computed (in particular, in the
%    course of the LRCF-ADI iteration), then the routine 'lp_nrmu' 
%    is much more efficient than 'lp_nrm'.
%
%
%  LYAPACK 1.0 (Thilo Penzl, October 1999)

% Input data not completely checked!

if tp~='B' & tp~='C'
  error('Invalid value of tp!');
end

with_BK = length(Bf)>0;

r = size(Z,2);
eval(lp_e( 'n = ',name,'_m;' ));                    % Get system order.
if tp=='B'
  t = 2*r+size(G,2);
else
  t = 2*r+size(G,1);
end

if 2*t < n

  if r==0
    Z = zeros(n,0);
    TM = zeros(n,0);
  else
    if tp=='B'
      eval(lp_e( 'TM = ',name,'_m(''N'',Z);' ));
      if with_BK, TM = TM-Bf*(Kf'*Z); end
    else
      eval(lp_e( 'TM = ',name,'_m(''T'',Z);' ));
      if with_BK, TM = TM-Kf*(Bf'*Z); end
    end
  end

  if tp=='B'
    M = [ TM, Z,  G ];
  else
    M = [ TM, Z, G' ];
  end

  R = triu(qr(M,0));
  R = R(1:min(size(R)),:); 
  s = size(R,2);

  nrm = norm(R(:,1:r)*R(:,r+1:2*r)'+R(:,r+1:2*r)*R(:,1:r)'+...
           R(:,2*r+1:s)*R(:,2*r+1:s)','fro');

else

  ZZ = Z*Z';

  if tp=='B' 
    eval(lp_e( 'TM = ',name,'_m(''N'',ZZ);' ));
    if with_BK, TM = TM-Bf*(Kf'*ZZ); end
    nrm = norm(TM+TM'+G*G','fro');
  else
    eval(lp_e( 'TM = ',name,'_m(''T'',ZZ);' )); 
    if with_BK, TM = TM-Kf*(Bf'*ZZ); end
    nrm = norm(TM+TM'+G'*G,'fro');
  end
  
end





