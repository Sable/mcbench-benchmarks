function [oa1, flag_r, oa3, oa4, oa5, oa6, oa7, oa8] = ...
         lp_lrnm( zk, ia2, ia3, ia4, ia5, ia6, ia7, ia8, ia9, ia10, ...
         ia11, ia12, ia13, ia14, ia15, ia16, ia17, ia18, ia19, ia20, ...
         ia21, ia22 )
%
%  Low rank Cholesky factor Newton method (explicit version LRCF-NM and  
%  implicit version LRCF-NM-I) for the solution of the continuous-time
%  algebraic Riccati equation (CARE)
%
%    0 = C'*Q*C + A'*X + X*A - X*B*inv(R)*B'*X =: R(X)
%
%  or the corresponding linear-quadratic optimal control problem (LQOCP)
%
%          oo
%    1/2 * int y'*Q*y + u'*R*u dt
%          t=0     
%
%  subject to
%    .
%    x = A*x + B*u,  x(0) = x_0
%
%    y = C*x .
%
%  Here, Q = Q0*Q0' and R = R0*R0'.
%
%  The output is either the matrix Z, for which the low rank Cholesky 
%  factor product Z*Z' provides an approximation to the stabilizing
%  solution X of the CARE, or the matrix K_out that approximates the
%  feedback K, for which u = -K'*x describes the solution of the LQOCP.
%
%  Whether the CARE or the LQOCP is solved depends on the choice of the 
%  input parameter zk: For zk = 'Z', Z is computed by LRCF-NM; for 
%  zk = 'K', K_out is computed by LRCF-NM-I.
%
%  Calling sequences:
%
%     zk = 'Z':
%       [Z, flag_r, res_r, flp_r, flag_l, its_l, res_l, flp_l] = ...
%       lp_lrnm( zk, rc, name, B, C, Q0, R0, K_in, max_it_r, ... 
%       min_res_r, with_rs_r, min_ck_r, with_ks_r, info_r, kp, km, ... 
%       l0, max_it_l, min_res_l, with_rs_l, min_in_l, info_l ) 
%
%     zk = 'K'
%       [K_out, flag_r, flp_r, flag_l, its_l, flp_l] = ...
%       lp_lrnm( zk, name, B, C, Q0, R0, K_in, max_it_r, min_ck_r, ...
%       with_ks_r, info_r, kp, km, l0, max_it_l, min_in_l, info_l ) 
%
%  Input:
%
%    zk        (= 'Z' or 'K') determines whether Z or K_out should be
%              computed;
%    rc        (= 'R' or 'C') determines whether the low rank factor Z
%              must be real ('R') or if complex factors are allowed ('C');
%              Sometimes rc = 'R' results in some additional computation. 
%              If zk = 'K', rc is ignored;
%    name      basis name of the m-file which generates matrix 
%              operations with A, e.g., 'as';
%    B         matrix B (n-x-m matrix, where  m << n !);
%    C         matrix C (q-x-n matrix, where  q << n !);
%    Q0        Cholesky factor of Q. Q0 should have full rank and q rows;
%    R0        Cholesky factor of R. R0 must be a nonsingular m-x-m
%              matrix;
%    K_in      stabilizing initial feedback (n-x-m matrix); if K_in = 0,
%              set K_in = [];
%    max_it_r  stopping criterion for (outer) Newton iteration: maximal 
%              number of iteration steps. Set to +Inf to avoid this 
%              criterion;
%    min_res_r stopping criterion for (outer) Newton iteration: The 
%              iteration is stopped when 
%
%                 ||R(Z*Z')||_F < min_res_r * ||C'*Q0*Q0'*C||_F.
%
%              Set min_res_r = 0 to avoid this criterion. Note: If 
%              min_res_r<=0 and with_rs_r='N', the (often expensive) 
%              calculation of the norm of the residual R(Z*Z') is avoided, 
%              but, of course, res_r is not provided on exit.
%    with_rs_r (= 'S' or 'N') stopping criterion for (outer) Newton iteration:
%              if with_rs_r = 'S', the iteration is stopped, when the 
%              routine detects a stagnation of the CARE residual norms, 
%              which is most likely the case, when roundoff errors rather 
%              than the approximation error start to dominante the residual 
%              norm. This implies that the residual norms are computed (which
%              can be expensive). This criterion works quite well in practice,
%              but is not absolutely sure. Use with_rs_r = 'S' if you
%              want to compute the CARE solution as accurate as possible
%              (for a given machine precision). If with_rs_r = 'N', this 
%              criterion is not used;
%    min_ck_r  stopping criterion for (outer) Newton iteration: The Newton
%              iteration is stopped at iteration step i, when
%         
%                ||K_i - K_(i-1)||_F < min_ck_r * ||K_i||_F,
%
%              i.e., when "relative changes in the feedback matrix"
%              K_i become sufficiently small. This, is an inexpensive, 
%              heuristical, and not absolutely safe stopping criterion. If 
%              min_ck_r <= 0, this criterion is not used;
%    with_ks_r (= 'L' or 'N') stopping criterion for (outer) Newton iteration:
%              if with_ks_r = 'L', the iteration is stopped, when the 
%              routine detects a stagnation of the relative changes in the 
%              feedback matrix K, i.e., when the quantities
%
%                ||K_i - K_(i-1)||_F / ||K_i||_F,
%
%              stagnate (most likely because of roundoff errors). This,
%              is an inexpensive, heuristical, and not absolutely safe
%              stopping criterion.  If with_ks_r = 'N', this criterion is 
%              not used;
%    info_r    (= 0, 1, 2, or 3) the desired "amount" of information on the 
%              outer Newton iteration. Default value is 3 ( = "maximal 
%              information");
%    kp,
%    km,
%    l0        these parameter control the algorithm which computes ADI
%              shift parameters. See also 'lp_para' and 'lp_lradi';
%
%    max_it_l, 
%    min_res_l, 
%    with_rs_l, 
%    min_in_l, 
%    info_l    These parameters steer the inner LRCF-ADI iterations. For their
%              descriptions, see 'lp_lradi' (max_it_l corresponds to max_it
%              there, etc).
%
%  Output:
%
%    Z         Z*Z' is a low rank approximation of X;
%              (Note that Z can be complex if rc = 'C'!)
%    K_out     an approximation to the stabilizing feedback K, that describes
%              the solution of the LQOCP;
%    flag_r    the criterion which had stopped the (outer) Newton iteration:
%               = 'I': max_it_r,
%               = 'R': min_res_r,
%               = 'S': with_rs_r,
%               = 'K': min_ck_r,
%               = 'L': with_ks_r;
%    res_r     the normalized CARE residual norms attained in the course of
%              the iterations (res_r(i+1) is the norm after the i-th 
%              iteration step;
%    flp_r     flop count. flp_r(i+1) containes the number of flops needed
%              to perform the first i steps of the (outer) Newton iteration. 
%              It does not include the cost for computing the residual norm 
%              (which is sometimes more expensive than the actual iteration)!
%    flag_l    a vector with length equal to number of Newton steps. It
%              contains the flags, that show which criteria have stopped
%              the (inner) LRCF-ADI iterations. See also 'lp_lradi'; 
%    its_l     a vector with length equal to number of Newton steps. It
%              contains the number of iteration steps taken in the (inner)
%              LRCF-ADI iterations;
%    res_l     a matrix with column number equal to number of Newton steps. 
%              Its i-th column contains the residual history for the
%              LRCF-ADI iteration in the i-th Newton step. See output
%              argument res in 'lp_lradi'. Entries exactly equal to zero
%              must be considered as "void". If the stopping criteria w.r.t.
%              the LRCF-ADI iteration are chosen such that no Lyapunov
%              residuals are computed, [] is returned;
%    flp_l     a matrix with column number equal to number of Newton steps. 
%              Its i-th column contains the flops history for the
%              LRCF-ADI iteration in the i-th Newton step. See output
%              argument flp in 'lp_lradi'. Entries exactly equal to zero
%              must be considered as "void";
%
%  User-supplied functions called by this function:
%
%    '[name]_m', '[name]_l', '[name]_s_i', '[name]_s', '[name]_s_d'    
%
%  Remark:
%
%    Note on the choice of zk: In the case when only Z*Z'*K_in and not Z*Z' is
%    sought, zk = 'K' can save much memory in some situations. But the amount
%    of computation is mostly not less than in the first mode, which should be 
%    considered as the standard mode. zk = 'Z' mode has several advantages:
%    there are more stopping criteria available, the computation of the 
%    residual norm is possible. In contrast, there is no secure way to
%    verify that the computed matrix K_out indeed approximates the exact 
%    matrix K in the second mode. In general, one should also use the first 
%    mode when the LQOCP is to be solved.
%
%  Reference:
%
%  [1] P. Benner, J. Li, and T. Penzl
%      Numerical solution of large Lyapunov equations, Riccati equations,
%      and linear-quadratic optimal control problems.
%      Submitted for publication.
%
%  [2] T. Penzl.
%      LYAPACK (Users' Guide - Version 1.0).
%      1999.
%
%
%   LYAPACK 1.0 (Thilo Penzl, October 1999)

% Input data not completely checked!

na = nargin;

% Constant that is used to detect "stagnation" in the residual norm
% of the Riccati equation as well as in the matrix K.
min_rs_r = 0.1;

if na==0, error('Wrong number of input arguments.'); end

if zk~='Z' & zk~='K', error('zk must be either ''Z'' or ''K''.'); end
compute_K = zk=='K';

if compute_K, 
  if na~=17, error('Wrong number of input arguments.'); end
  name = ia2; 
  B = ia3;
  C = ia4; 
  Q0 = ia5; 
  R0 = ia6; 
  Kf = ia7; 
  max_it_r = ia8;
  min_ck_r = ia9; 
  with_ks_r = ia10;
  info_r = ia11;
  kp = ia12;
  km = ia13; 
  l0 = ia14; 
  max_it_l = ia15;
  min_in_l = ia16; 
  info_l = ia17;
  with_norm = 0;
  K_in_is_real = ~any(any(imag(Kf)));
else
  if na~=22, error('Wrong number of input arguments.'); end
  rc = ia2; 
  if rc~='R' & rc~='C', error('rc must be either ''R'' or ''C''.'); end
  name = ia3; 
  B = ia4; 
  C = ia5; 
  Q0 = ia6; 
  R0 = ia7; 
  Kf = ia8;
  max_it_r = ia9; 
  min_res_r = ia10; 
  with_rs_r = ia11;
  if with_rs_r~='N' & with_rs_r~='S', error('with_rs_r must be either ''S'' or ''N''.'); end
  min_ck_r = ia12;
  with_ks_r = ia13;
  info_r = ia14;
  kp = ia15;
  km = ia16;
  l0 = ia17;
  max_it_l = ia18;
  min_res_l = ia19;
  with_rs_l = ia20;
  min_in_l = ia21;
  info_l = ia22;
  with_norm = min_res_r>0 | with_rs_r;
  make_real = rc=='R';
end
if with_ks_r~='N' & with_ks_r~='L', error('with_ks_r must be either ''L'' or ''N''.'); end

with_k_crit = min_ck_r>0 | with_ks_r=='L';   
                         % (true if stopping criteria based on K are used)

C0 = Q0'*C;
R = R0*R0';
BRi = B/R;                   

eval(lp_e( 'n = ',name,'_m;' ));                    % Get system order.
m = size(B,2);

flag_r = 'I';
flp_r = 0;
fl = 0;
flag_l = [];
its_l = [];
flp_l = [];

if with_norm
  res_r_0 = lp_rcnrm( name, B, C0, R, [] );  
  res_r = 1;
end
res_l = [];

b0 = randn(n,1);         % Arnoldi start vector for lp_para.

for i = 1:max_it_r

  fl0 = flops;
  if length(Kf)
    TM =  [C0; R0'*Kf']; 
    Bf = B;
  else
    TM =  C0;
    Bf = [];
  end    

  p = lp_para(name,Bf,Kf,l0,kp,km,b0);

  eval(lp_e( name,'_s_i(p);' ));

  fl = fl+flops-fl0;

  if with_k_crit,
    if length(Kf)
      Kf_old = Kf;
    else 
      Kf_old = zeros(n,m); 
    end
  end

  if info_l >= 3 & ~compute_K
    if  (with_rs_l=='S' | min_res_l>0), figure(2); end
  end
  m = size(TM,1);
  if compute_K                           
    [Kf,flag0,flp0] = lp_lradi('C','K','C',name,Bf,Kf,TM,p,BRi,max_it_l,...
      min_in_l, info_l);  
  else
    [Z,flag0,res0,flp0] = lp_lradi('C','Z','C',name,Bf,Kf,TM,p,max_it_l,... 
      min_res_l,with_rs_l,min_in_l,info_l);  
  end
  its_l = [its_l; length(flp0)-1];

  if info_l>=2,
    disp(' ');
    disp('Results for LRCF-ADI iteration in current Newton step:')
    disp(['Termination flag:  ',flag0]);
    disp(sprintf('Number of LRCF-ADI iterations: %d',size(flp0,1)-1))
  end
  fl = fl+flp0(length(flp0));

  flag_l = [ flag_l; flag0 ];
  flp_l(1:length(flp0),size(flp_l,2)+1) = flp0;
  flp_r = [ flp_r; fl ];

  if info_r >= 2
    disp(' ');
    disp('------------------------------------------------------------')
    disp(sprintf('Newton (LRCF-NM or LRCF-NM-I) step: %d',i));
  end  

  if with_norm

    res_l(1:length(res0),size(res_l,2)+1) = res0;

    resnrm = lp_rcnrm( name, B, C0, R, Z );
    akt_res = resnrm/res_r_0;
    res_r = [ res_r; akt_res ];

    if info_r >= 2
      disp(sprintf('norm. Riccati residual =    %e',akt_res));
      disp(' ');
    end  

    if info_r >= 3
      figure(1)
      semilogy((0:length(res_r)-1)',res_r,'r-');
      ylabel('Normalized residual norm');                   
      xlabel('Iteration steps');
      title('LRCF-Newton iteration');
      pause(0.01);
    end
%                                % Stopping criteria w.r.t. residual norm 
    if akt_res <= min_res_r
      flag_r = 'R';
      break;
    end  

    if i>2 & with_rs_r=='S'
      if log(res_r(i))-log(res_r(i+1)) < min_rs_r*(log(res_r(2))-...
        log(res_r(i+1)))/(i-1) & 0 < res_r(2)-res_r(i+1),
        flag_r = 'S';
        break;
      end
    end 

  end

  % Feedback for the next Newton step

  if ~compute_K 
    if i==max_it_r, break; end       % (need not compute Kf any more) 
    fl0 = flops;
    Kf = Z*(Z'*BRi);              
    fl = fl+flops-fl0;
  end 

  if with_k_crit                   % Stopping criterion w.r.t. Kf
    t1 = norm(Kf-Kf_old,'fro');
    t2 = norm(Kf,'fro');
    if i>=2, rc_K_old = rc_K; end
    rc_K = t1/t2;
    if info_r>=2 & i>=2
      disp(sprintf('rel. change in feedback matrix = %e',rc_K));
    end  
    if t1<min_ck_r*t2              % Smallness of changes in K
      flag_r = 'K';
      break;
    end    
    if i>=2 & with_ks_r=='L'       % Stagnation of changes in K or
                                   % rel. changes in K VERY small
      if (rc_K<1 & abs(log(rc_K)-log(rc_K_old))<-min_rs_r*log(rc_K)/i)...
        | rc_K<eps
        flag_r = 'L';
        break;
      end
    end 
  end
 
end


if compute_K
  if norm(imag(Kf),'fro') > 1e-10*norm(real(Kf),'fro') 
    disp('WARNING in ''lp_lrnm'': K_out is not real!');
  else
    Kf = real(Kf);
  end
  oa1 = Kf;
  oa3 = flp_r;
  oa4 = flag_l;
  oa5 = its_l;
  oa6 = flp_l;
  oa7 = [];
  oa8 = [];
else
  if make_real                   % Make the Cholesky factor of the
                                 % last Newton iterate real by the
                                 % technique, which is used in lp_lradi. 

    i_max = round(size(Z,2)/m);  % Number of LRCF-ADI steps
                                 % in last Newton step   
    i_p = 1;                     % Pointer to i-th entry in p(:)
    is_compl = imag(p(1))~=0;    % is_compl = (current parameter is complex.)
    is_first = 1;                % is_first = (current parameter is the first
                                 % of a pair, PROVIDED THAT is_compl.)
    l = length(p);
    fl = flops;
    for i = 2:i_max
      p_old = p(i_p);
      i_p = i_p+1; if i_p>l, i_p = 1; end   % update current parameter index
      if is_compl & is_first
        is_first = 0;
      else
        is_compl = imag(p(i_p))~=0;  
        is_first = 1;
      end                                 
      if is_compl & ~is_first    % Make group of 2*m columns real.  
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
    flp_r(end) = flp_r(end)+flops-fl; 
  end
  oa1 = Z;
  if with_norm
    oa3 = res_r;
  else
    oa3 = [];
  end
  oa4 = flp_r;
  oa5 = flag_l;
  oa6 = its_l;
  oa7 = res_l;
  oa8 = flp_l;
end

