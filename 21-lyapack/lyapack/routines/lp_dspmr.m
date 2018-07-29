function [Ar,Br,Cr,S] = lp_dspmr(name,B,C,ZB,ZC,max_ord,tol)
% 
%  Model reduction method DSPMR (Dominant Subspace Projection Model
%  Reduction) ([1, Algorithm 6], [2, Algorithm 4]) for the system
%    .
%    x  =  A*x + B*u
%    y  =  C*x.
%
%  The reduced system is 
%    .
%    xr  =  Ar*xr + Br*u
%    y   =  Cr*xr.
%
%  The implementation is based on approximate low rank Cholesky 
%  factors ZB / ZC of the controllability / observability Gramians. These 
%  factors should be computed by 'lp_lradi'. This implementation is quite 
%  efficient if ZB and ZC have much less columns than rows. However, note 
%  that LRSRM ('lp_lrsrm') is an alternative to this method. LRSRM often 
%  delivers better results in view of approximation; see [1]. DSPMR 
%  tends to deliver better results w.r.t. preserving stability or 
%  passivity. 
%
%  Calling sequence:
%
%    [Ar,Br,Cr,S] = lp_dspmr(name,B,C,ZB,ZC,max_ord,tol)
%
%  Input:
%
%    name      basis name of the m-file which generates matrix 
%              operations with A, e.g., 'as';
%    B         system matrix B (n-x-m matrix, where  m << n);
%    C         system matrix C (q-x-n matrix, where  q << n);
%    ZB        the (approximate) low rank Cholesky factor of XB, which 
%              solves
%
%                A*XB + XB*A'  =  -B*B'   (XB ~ ZB*ZB'); 
%
%    ZC        the (approximate) low rank Cholesky factor of XC, which 
%              solves
%
%                A'*XC + XC*A  =  -C'*C   (XC ~ ZC*ZC');
%
%    max_ord   the maximal order the reduced system should have. If you
%              do not want to specify max_ord, set max_ord = []. Then,
%              max_ord does not restrict the reduced order;
%    tol       besides max_ord, tol determines the order of the reduced
%              system. Let k0 the maximal value for which 
%              sigma(k0)/sigma(1) >= sqrt(tol) holds in Step 2 of 
%              Algorithm 4 in [2]. Then the reduced order is 
%              min([k0,max_ord]), provided that there are enough linearly
%              independent columns in ZB and ZC. Loosely speaking, tol is
%              the analog to that tol in routine 'lp_lrsrm'. The 
%              smaller the value is, the larger becomes the order of the 
%              reduced realization provided max_ord is sufficiently large. 
%              tol = eps is a conservative choice (and default value),
%              where eps is the machine precision. (However, even smaller
%              values can make sense). This can lead to  a quite large 
%              reduced order.
%
%  Output:
%
%    Ar,
%    Br,
%    Cr        matrices of the reduced system;
%    S         projection matrix.
%
%  User-supplied functions called by this function:
%
%    '[name]_m'
%
%  Remark:
%
%    The reduced system matrices Ar, Br, and Cr are real if the low rank
%    Cholesky factors are real. If ZB or ZC are not real, but ZB*ZB' and
%    ZC*ZC' are real matrices, then the resulting reduced system needs 
%    not be real, but it can be transformed into a real system by an
%    equivalence transformation using a unitary transformation matrix. 
%    This problem is caused by the non-uniqueness of the singular vectors 
%    in singular value decompositions. Experience shows that the imaginary
%    parts in the reduced system are in the magnitude of rounding errors. 
%    However, this cannot be guaranteed. 
%
%  References:
%
%  [1] T. Penzl.
%      Algorithms for model reduction of large dynamical systems.
%      Submitted for publication. 1999.
%
%  [2] T. Penzl.
%      LYAPACK (Users' Guide - Version 1.0).
%      1999.
%
%   
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

ni = nargin;

eps2 = eps^2;
if ni < 7, tol = eps2; end
if ~length(tol), tol = eps2; end

rB = size(ZB,2);
rC = size(ZC,2);
r = rB+rC;

if ni < 6
  max_ord = r;
else
  if ~length(max_ord)
    max_ord = r;
  end
end
max_ord = min([max_ord,r]);

eval(lp_e( 'n = ',name,'_m;' ));                    % Get system order.

nmB = norm(ZB,'fro');  
nmC = norm(ZC,'fro');        

Z = [ (1/nmB)*ZB, (1/nmC)*ZC ];      % Note that weights are used for Z!
[S,E,V] = svd(Z,0);
e = diag(E);
ord = min([ max_ord, sum(e>=sqrt(tol)*e(1)) ]);    % Determine reduced order.

                                     % Compute reduced system.
S =  S(:,1:ord);
Br = S'*B;
eval(lp_e( 'Ar = S''*',name,'_m(''N'',S);' ));  
Cr = C*S;
