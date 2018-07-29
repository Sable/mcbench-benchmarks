function [ nrm, nrmQ, nrmR, nrmbs ] = ...
         lp_nrmu( tp, name, Bf, Kf, G, V, nrmQ, nrmR, nrmbs )
%
%  Using updated QR factorizations, this routine computes efficiently 
%  a sequence of norms which correspond to either of the following types:
% 
%  for tp = 'B':
%
%    nrm = || F*Z_i*Z_i' + Z_i*Z_i'*F' + G*G' ||_F,
%
%  for tp = 'C':
%
%    nrm = || F'*Z_i*Z_i' + Z_i*Z_i'*F + G'*G ||_F.
%
%  Here, F = A-Bf*Kf'.
%
%  The matrices Z_i must have much more rows than columns and they
%  have to obey the recursion
%
%    Z_i = [ Z_{i-1}  V ].
%
%  Calling sequence:
%
%    [ nrm, nrmQ, nrmR, nrmbs ] = ...
%    lp_nrmu( tp, name, Bf, Kf, G, V, nrmQ, nrmR, nrmbs )
%
%  Input:
%
%    tp        (= 'B' or 'C') the type of the norm;
%    name      basis name of the m-file which generates matrix 
%              operations with A, e.g., 'as';
%    Bf        real matrix Bf;
%              Set Bf = [] if not existing or zero!
%    Kf        real matrix Kf;
%              Set Kf = [] if not existing or zero!
%    G         n-x-m or m-x-n matrix G (must be real);       
%    V         n-x-r matrix V (may be complex);
%    nrmQ, 
%    nrmR, 
%    nrmbk     variables for internal use (they contain the data of
%              the updated QR factorization).
%
%  Output:
%
%    nrm       the current value of the Frobenius norm nrm_i.
%    nrmQ, 
%    nrmR, 
%    nrmbk     variables for internal use (they must be output 
%              parameters).
%
%  User-supplied functions called by this function:
%
%    '[name]_m'    
%
%  Remarks:
%
%    Using this routine for computing the norms within an iteration
%    can save a lot of computation compared to repeatedly calling
%    'lp_nrm'.
%
%    This routine must be used as follows:
%
%    1. Before the iteration starts, it must be invoked with the
%       parameters V = nrmQ = nrmR = nrmbl = []. This initializes the
%       variables nrmQ, nrmR, nrmbl.
%
%    2. The routine must be called in each step of the iteration:
%
%    Example:
%
%      ... 
%      [nrm,nrmQ,nrmR,nrmbs] = lp_nrmu('B','au',[],[],G,[],[],[],[]);
%      ...
%      Z = zeros(n,0);  
%      ...
%      for i = 1:100              
%        ...
%        V = ...;
%        ...
%        Z = [ Z V ];    % iteration:  Z_i = [ Z_i-1 V ]
%        ...
%        [nrm,nrmQ,nrmR,nrmbs] = lp_nrmu('B','au',[],[],G,V,nrmQ,nrmR,nrmbs);
%        ...
%      end
%      ...
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

if tp~='B' & tp~='C'
  error('Invalid value of tp!');
end

with_BK = length(Bf)>0;

eval(lp_e( 'n = ',name,'_m;' ));                    % Get system order.

if size(V,2) == 0     

          % The routine is called for the first time (before the iteration
          % 'outside' is started (i.e. V = zeros(n,0) or []!)) in order to
          % initialize the QR factorization nrmQ*nrmR correctly.             

  if length(nrmQ) | length(nrmR) | length(nrmbs), 
    error('Before this routine is called for the first time, set nrmQ = nrmR = nrmbs = []!');
  end
  
  if tp=='B'
    nrmbs = size(G,2);
    [nrmQ,nrmR] = qr(G,0);
  else
    nrmbs = size(G,1);
    [nrmQ,nrmR] = qr(G',0);
  end
  nrm = norm(nrmR*nrmR','fro');
  
else                                     

          % The routine is called during the iteration 'outside'.
          % The QR factorization is updated and the norm is computed.

  if ~(length(nrmQ) & length(nrmR) & length(nrmbs)), 
    error('No proper input data nrmQ, nrmR, or nrmbs!'); 
  end
  
  % Update of the QR factorization.
  nrmbs = [ nrmbs, size(V,2) ];
  lw = size(nrmQ,2);
  lz = size(V,2);

  if tp=='B'
    eval(lp_e( 'TM = ',name,'_m(''N'',V);' ));
    if with_BK, TM = TM-Bf*(Kf'*V); end
    Z = [ TM, V ];
  else
    eval(lp_e( 'TM = ',name,'_m(''T'',V);' ));
    if with_BK, TM = TM-Kf*(Bf'*V); end
    Z = [ TM, V ];
  end

  for j = 1:2*lz
    a = zeros(lw,1);
    t = Z(:,j);
    for k = 1:lw
      u = nrmQ(:,k);
      alpha = u'*t;
      t = t-alpha*u;
      a(k) = alpha;
    end  
    beta = norm(t);
    nrmQ = [nrmQ t/beta];
    nrmR = [ nrmR a; zeros(1,lw) beta ];
    lw = lw+1;
  end

  % Computation of  nrmR * [permutation matrix] * nrmR'
  RT = nrmR;  
  ie2 = nrmbs(1);
  for j = 2:length(nrmbs)
    ia1 = ie2+1;
    ie1 = ie2+nrmbs(j);
    ia2 = ie1+1;
    ie2 = ie1+nrmbs(j);    
    TMP = RT(:,ia1:ie1);  
    RT(:,ia1:ie1) = RT(:,ia2:ie2); 
    RT(:,ia2:ie2) = TMP;
  end  
  
  nrm = norm(nrmR*RT','fro');

end  


