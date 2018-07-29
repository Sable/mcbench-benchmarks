function [Z, flag, oa3, oa4] = ...
    lp_lradi(tp,zk,rc,name,Bf,Kf,G,p,ia9,ia10,ia11,ia12,ia13)
%           
%  LRCF-ADI for solving the stable Lyapunov equation: 
%
%    For tp = 'B':
%
%      F * X + X * F' = -G*G',
%
%    for tp = 'C':
%
%      F' * X + X * F = -G'*G,
%
%  where F = A-Bf*Kf'. 
% 
%  The routine works in two modes (depending on the choice of zk):
%
%    For zk = 'Z', this routine deliveres a low rank factor Z, 
%    such that Z*Z' approximates X;
%
%    for zk = 'K', it only generates the product K_out = Z*Z'*K_in 
%    without forming Z itself.
%
%  Calling sequences:
%
%    for zk = 'Z':
%
%      [Z, flag, res, flp] = lp_lradi( tp, zk, rc, name, Bf, Kf, G, p, ...
%      max_it, min_res, with_rs, min_in, info)  
%
%    for zk = 'K':
%
%      [K_out, flag, flp] = lp_lradi( tp, zk, rc, name, Bf, Kf, G, p, ...
%      K_in, max_it, min_in, info)  
%
%  Input:
%
%    tp        (= 'B' or 'C') determines the type of Lyapunov equation;
%    zk        (= 'Z' or 'K') determines whether Z or K_out should be
%              computed;
%    rc        (= 'R' or 'C') determines whether the low rank factor Z
%              must be real ('R') or if complex factors are allowed ('C');
%              If p contains complex parameters, then the low rank factor
%              Z is complex, too, although Z*Z' is real. A real low rank 
%              factor is determined from the complex data, if rc = 'R'. 
%              However, this requires some additional computation. 
%              If zk = 'K', rc is ignored;
%    name      basis name of the m-file which generates matrix 
%              operations with A, e.g., 'as';
%    Bf        "feedback" matrix Bf;
%              Set Bf = [] if not existing or zero!
%    Kf        "feedback" matrix Kf;
%              Set Kf = [] if not existing or zero!
%    G         matrix G (n-x-m if tp='B' or m-x-n if tp='C', 
%              where  m << n !);
%    p         l-vector with ADI shift parameters. Complex parameters must 
%              appear as conjugate complex pairs in consecutive order.
%              If more than length(p) iterations need to be done, the
%              parameters p(i) are reused in a cyclic manner; 
%    K_in      a n-x-r matrix (where r should be small: r << n !);
%    max_it    stopping criterion: maximal number of LRCP-ADI steps
%              Set to [] or +Inf (default) to avoid this criterion;
%    min_res   stopping criterion: minimal relative residual norm. The 
%              iteration is stopped when res(i+1) <= min_res (See Remarks). 
%              Set min_res = [] or 0 (default) to avoid this criterion. Note: 
%              If min_res<=0 and with_rs='N', the (often expensive) calculation
%              of the residual norm is avoided, but, of course, res is not
%              provided on exit.
%    with_rs   (= 'S' or 'N') if with_rs = 'S', the iteration is stopped, 
%              when the routine detects a stagnation of the residual norms, 
%              which is most likely the case, when roundoff errors rather 
%              than the approximation error start to dominante the residual 
%              norm. This implies that the residual norms are computed (which
%              can be expensive). This criterion works quite well in practice,
%              but is not absolutely sure. Use with_rs = 'S' only if you
%              want to compute the Lyapunov solution as accurate as possible
%              (for a given machine precision).
%              If with_rs = 'N', this criterion is not used.
%    min_in    stopping criterion: This value limits the "minimal increase" 
%              in the matrix Z by the "new" columns . The iteration is 
%              terminated as soon as
%
%                || Z_nc ||_F^2 < min_in * || Z_new ||_F^2
%
%              holds for a certain number of consecutive iteration steps. 
%              Here, Z_nc are the currently computed "new" colums, which 
%              appended to the old iterate Z_old deliver the new iterate
%              Z_new  = [ Z_old  Z_nc ]. Set min_in = 0 to avoid it.
%              Default value is eps, the machine precision. min_in = []
%              has the same effect. Note that this is an "adaptive" 
%              stopping criterion which does not require the 
%              (often expensive) computation of the residual norm.
%    info      (= 0, 1, 2, or 3) the "amount" of information given during the 
%              iteration. Default value is 3 (="maximal information").
%    
%  Output:
%
%    Z         Z*Z' is a low rank approximation of X;
%              (Note that Z can be complex if rc='C'!)
%    flag      the criterion which had stopped the iteration:
%               = 'I': max_it,
%               = 'R': min_res,
%               = 'S': with_rs,
%               = 'N': min_in,
%    res       the relative residual norms attained in the course of
%              the iterations (res(i+1) is the norm after the i-th step
%              of the iteration!). See note in min_res.
%    flp       flop count. flp(i+1) containes the number of flops needed
%              to perform the first i steps of the iteration. It does not 
%              include the cost for computing the residual norm (which is
%              sometimes more expensive than the actual iteration)!    
%
%  User-supplied functions called by this function:
%
%    '[name]_m', '[name]_s'    
%
%  Remarks:
%
%    1. Note on the choice of zk, in case only Z*Z'*K_in and not Z*Z' is
%    sought: zk = 'K' can save much memory in some situations. But the amount
%    of computation is mostly not less than in the first mode, which should be 
%    considered as the standard mode. zk = 'Z' has several advantages:
%    there are more stopping criteria available, the computation of the 
%    residual norm is possible. In contrast, there is no secure way to
%    verify that the computed matrix K_out indeed approximates the exact 
%    matrix X*K_in in the second mode. So, in general, you should use the 
%    first mode, even if you are only interested in X*K_in instead of X itself.
%
%    2. The eigenvalues of F must have negative real parts. 
%
%    3. The values in res correspond to the following "relative" norms
%
%      tp = 'B':
%        res(i+1) = ||F*Z_i*Z_i'+Z_i*Z_i'*F'+G*G'||_F/||G*G'||_F
%
%      tp = 'C':
%        res(i+1) = ||F'*Z_i*Z_i'+Z_i*Z_i'*F+G'*G||_F/||G'*G||_F
%
%    4. Note that all stopping criteria are checked only after a step
%    with a real parameter or a "double step" with a pair of conjugate
%    complex parameters. This ensures that Z*Z' is real, even if Z is
%    not.
%
%  References:
%
%    The algorithm is a slight modifivation of that proposed in:
%
%  [1] J.Li, F.Wang, and J.White.
%      An efficient Lyapunov equation based approach for generating
%      reduced-order models of interconnect.
%      Proceedings of the 36th IEEE/ACM Design Automation Conference,
%      New Orleans, LA, 1999. 
%
%    Another (though more expensive) low rank algorithm is proposed in:
%
%  [2] T. Penzl.
%      A cyclic low rank Smith method for large sparse Lyapunov equations.
%      To appear in SIAM Sci. Comp.
%
%    See also:
%
%  [3] P. Benner, J. Li, and T. Penzl
%      Numerical solution of large Lyapunov equations, Riccati equations,
%      and linear-quadratic optimal control problems.
%      In preparation.
%
%  [4] T. Penzl.
%      LYAPACK (Users' Guide - Version 1.0).
%      1999.
%
%
%   LYAPACK 1.0 (Thilo Penzl, October 1999)


% Internal remarks:
% =================

% Input data not completely checked!

% The procedure to generate real factors in case of complex parameters is
% different from that in [3]!

% The matrices SMi (i = 1:length(p)) for the "Sherman-Morrison trick" 
% (only used if Bf and Kf are nonzero) are computed a priori, which
% is good in view of computation if parameters p(i) are used cyclically,
% but may be sometimes bad in view of memory demand, in particular, when
% length(p) is large.
%

% The stopping criterion related to the input parameter with_rs
% corresponds to the stagnation of the residual curve caused by
% round-off errors. Its performance depends on the constants stcf and 
% min_rs. The iteration is stopped, as soon as 
%     
%   (ra-rb)*(i-stcf+1) / ((r(1)-ra)*stcf) < min_rs
%                 
% and r(1)-ra > 0 and i >= stcf hold for stcf consecutive iteration
% steps. Here res(i+1) is the residual norm after the i-th LRCF-ADI step, 
% r(i+1) = log(res(i+1)), ra = min(r(1:i-stcf+1)), rb = min(r(i-stcf+2:i+1)). 
%
% stcf is also the number of consecutive steps, for which the criterion
% w.r.t. min_in must be fulfilled.
%
stcf = 10;
min_rs = .1;

na = nargin;

if zk~='Z' & zk~='K', error('zk must be either ''Z'' or ''K''.'); end
if tp~='B' & tp~='C', error('tp must be either ''B'' or ''C''.'); end
if rc~='R' & rc~='C', error('rc must be either ''R'' or ''C''.'); end

compute_K = zk=='K';

if compute_K
  K = ia9;
  if na < 10, max_it = []; else, max_it = ia10; end
  if na < 11, min_in = []; else, min_in = ia11; end  
  if na < 12, info = []; else, info = ia12; end  
  with_norm = 0;
  with_min_rs = 0;
  K_in_is_real = ~norm(imag(K));
else
  if na < 9, max_it = []; else, max_it = ia9; end
  if na < 10, min_res = []; else, min_res = ia10; end
  if na < 11, with_rs = []; else, with_rs = ia11; end  
  if na < 12, min_in = []; else, min_in = ia12; end  
  if na < 13, info = []; else, info = ia13; end  
  if ~length(min_res), min_res = 0; end
  if ~length(with_rs), with_rs = 'S'; end  
  with_min_rs = with_rs=='S';
  with_norm = (min_res>0)|with_min_rs;
  make_real = rc=='R';
end
if ~length(max_it), max_it = +Inf; end
if ~length(min_in), min_in = eps; end
with_min_in = min_in>0;
if ~length(info), info = 3; end  

with_BK = length(Bf) > 0;

l = length(p);

if tp=='B'
  [n,m] = size(G);
else
  [m,n] = size(G);
end

fl0 = flops;
if with_BK,      
  Im = eye(size(Bf,2)); 
  if tp=='B'
                 % SMi = TM*inv(I-Kf'*TM), 
                 % where TM = inv(F+p(i)*I)*Bf
                 % (These are the columns of the LR terms for the
                 % rank corrections of the "inverse" 
                 % in the Sherman-Morrison formulae.)
    for i = 1:l
      eval(lp_e( 'TM = ',name,'_s(''N'',Bf,i);' ));
      eval(lp_e( 'SM',i,' = TM/(Im-Kf''*TM);' ));
    end
  else  % (tp=='C')
                 % SMi = TM*inv(I-Bf'*TM), 
                 % where TM = inv(F.'+p(i)*I)*Kf
                 % (These are the columns of the LR terms for the
                 % rank corrections of the "inverse" 
                 % in the Sherman-Morrison formulae.)
    for i = 1:l
      eval(lp_e( 'TM = ',name,'_s(''T'',Kf,i);' ));
      eval(lp_e( 'SM',i,' = TM/(Im-Bf''*TM);' ));
    end
  end
end
fl = flops-fl0;

% Initialize QR factorization for norm computation
if with_norm
  [res0,nrmQ,nrmR,nrmbs] = lp_nrmu(tp,name,Bf,Kf,G,[],[],[],[]);
  res = 1;
  res_log = log(res0);        % Vector containing log of residual norms;
end                           % corresponds to r(:) in prolog.

flp = fl;
flag = 'I';
if with_min_in
  nrmF_Z_2 = 0;                 % Current squared Frobenius norm of Z
  nrmF_rec = +Inf*ones(stcf,1); % Records the values of 
end                             % ||Z_nc||_F^2 / ||Z_new||_F^2 (see prolog)
                                % for the last stcf iteration steps.

i_p = 1;                   % Pointer to i-th entry in p(:)
is_compl = imag(p(1))~=0;  % is_compl = (current parameter is complex.)
is_first = 1;              % is_first = (current parameter is the first
                           %            of a pair, PROVIDED THAT is_compl.)


                   
for i = 1:max_it       % The iteration itself      

  fl0 = flops;

  if i==1

    if tp=='B'
                          % V = last columns of Cholesky factor Z
                          % Initialize:
                          % V := sqrt(-2*real(p(1)))*inv(F+p(1)*I)*G

      eval(lp_e( 'V = ',name,'_s(''N'',G,1);' ));
      if with_BK, eval(lp_e( 'V = V+SM',1,'*(Kf''*V);' )); end
      V = sqrt(-2*real(p(1)))*V;

    else %( tp = 'C' )
                          % Initialize:
                          % V := sqrt(-2*real(p(1)))*inv(F.'+p(1)*I)*G'

      eval(lp_e( 'V = ',name,'_s(''T'',G'',1);' ));
      if with_BK, eval(lp_e( 'V = V+SM',1,'*(Bf''*V);' )); end
      V = sqrt(-2*real(p(1)))*V;

    end

    if compute_K

      Z = V*(V'*K);       % Caution: the physical variable Z contains the
                          % "logical" variable K ("feedback iterate") in the
                          % case, when only K_out is sought (zk = 'K').  

    else

      Z = V;             % Note:  Z*Z' = current ADI iterate 

    end


  else       % (i > 1)


    p_old = p(i_p);
  
    i_p = i_p+1; if i_p>l, i_p = 1; end    % update current parameter index

    if is_compl & is_first
      is_first = 0;
      if i_p==1 
        error('Parameter sequence ends in the "middle" of a complex pair!')
      end
      if p(i_p)~=conj(p_old)
        error('Parameters p(i) must be either real or pairs of conjugate complex numbers.');
      end
    else
      is_compl = imag(p(i_p))~=0;  
      is_first = 1;
    end
  
    if tp=='B'

        % Evaluate 
        %   V := sqrt(real(p(i_p))/real(p_old))*...
        %        (V-(p(i_p)+conj(p_old))*inv(F+p(i_p)*I)*V) 
        
      eval(lp_e( 'TM = ',name,'_s(''N'',V,i_p);' ));
      if with_BK, eval(lp_e( 'TM = TM+SM',i_p,'*(Kf''*TM);' )); end
      TM = V-(p(i_p)+conj(p_old))*TM;
      V = sqrt(real(p(i_p))/real(p_old))*TM;

    else   % ( tp=='C' ) 

        % Evaluate 
        %   V := sqrt(real(p(i_p))/real(p_old))*...
        %        (V-(p(i_p)+conj(p_old))* inv(F.'+p(i_p)*I)*V) 
        
      eval(lp_e( 'TM = ',name,'_s(''T'',V,i_p);' ));
      if with_BK, eval(lp_e( 'TM = TM+SM',i_p,'*(Bf''*TM);' )); end
      TM = V-(p(i_p)+conj(p_old))*TM;
      V = sqrt(real(p(i_p))/real(p_old))*TM;

    end
    
    if compute_K                       % Form new iterate K in case
                                       % that only Z*Z'*K_in is sought.
      Z = Z+V*(V'*K);

    else                               % Form new iterate Z.

      if ~is_compl, V = real(V); end

      Z = [Z, V];              

                                       % Make last 2*m columns real.
      if make_real & is_compl & ~is_first      
        for j = (i-1)*m+1:i*m  
          [U1,S1,V1] = svd([real(Z(:,j-m)),real(Z(:,j)),imag(Z(:,j-m)),...
                    imag(Z(:,j))],0);
          [U2,S2,V2] = svd(V1(1:2,1:2)'*V1(1:2,1:2)...
                       +V1(3:4,1:2)'*V1(3:4,1:2));
          TMP = U1(:,1:2)*S1(1:2,1:2)*U2*diag(sqrt(diag(S2)));
          Z(:,j-m) = TMP(:,1);
          Z(:,j) = TMP(:,2);
        end
      end


    end

  end

  fl = fl+flops-fl0;
  flp = [ flp; fl ];
                         
  if with_norm                          % Compute residual norm
               
    [resnrm,nrmQ,nrmR,nrmbs] = lp_nrmu(tp,name,Bf,Kf,G,V,nrmQ,nrmR,nrmbs);
    res_log = [res_log; log(resnrm)];
    akt_res = resnrm/res0;
    res = [ res; akt_res ];

    if info >= 2
      disp(sprintf('LRCF-ADI step %d -- norm. residual = %e',i,akt_res));
    end  

    if info >= 3
      semilogy((0:length(res)-1)',res,'r-');
      ylabel('Normalized residual norm');
      xlabel('Iteration steps');
      title('LRCF-ADI iteration');
      pause(0.01);
    end
  
                              % After pair of complex parameters or
                              % a real parameter, check stopping criteria 
                              % based on residual norm.
    if  ~(is_compl & is_first)

      if akt_res <= min_res
        flag = 'R';
        break;
      end  
    
      if with_min_rs & i>=2*stcf
        ra = min(res_log(1:i-stcf+1));
        rb = min(res_log(i-stcf+2:i+1));
        if res_log(1)-ra > 0 & ...
          (ra-rb)*(i-stcf+1) / ((res_log(1)-ra)*stcf) < min_rs
          flag = 'S';
          break;
        end          
      end

    end

  end


                 % Check stopping criteria based on increase in ||Z_i||_F.
  if with_min_in              
    nrmF_V_2 = sum(sum(abs(V).*abs(V)));    % Note the "abs"; V is complex.
    nrmF_Z_2 = nrmF_Z_2 + nrmF_V_2;
    nrmF_rec(1:stcf-1) = nrmF_rec(2:stcf);
    nrmF_rec(stcf) = nrmF_V_2/nrmF_Z_2; 
    if ~(is_compl & is_first) & i>stcf & all(nrmF_rec < min_in)
      flag = 'N';
      break;
    end
  end

    
end



if compute_K
  if K_in_is_real
    Z = real(Z);
  end
  oa3 = flp;
  oa4 = [];
else
  if with_norm
    oa3 = res;
  else
    oa3 = [];
  end
  oa4 = flp;
end











