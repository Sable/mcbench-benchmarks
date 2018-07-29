function [Ar,Br,Cr,SB,SC,sigma] = lp_lrsrm(name,B,C,ZB,ZC,max_ord,tol)
% 
%  Model reduction method LRSRM (Low Rank Square Root Method) 
%  ([2, Algorithm 2], [4, Algorithm 3]) for the system
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
%  efficient if ZB and ZC have much less columns than rows. Compared to
%  the model reduction method DSPMR ('lp_dspmr') the approximation of
%  the reduced models by LRSRM tend to be better. On the other hand, DSPMR
%  is advantageous in view of preserving stability and passivity.
%
%  Calling sequence:
%
%    [Ar,Br,Cr,SB,SC,sigma] = lp_lrsrm(name,B,C,ZB,ZC,max_ord,tol)
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
%              max_ord does not restrict the reduced order.
%    tol       besides max_ord, tol determines the order of the reduced
%              system. sigma(:) is described below. Moreover, let
%              k0 be the maximal value k for which sigma(k)/sigma(1)>=tol 
%              holds. Then the reduced order is min([k0,max_ord]). The 
%              smaller the value is, the larger becomes the order of the 
%              reduced realization provided max_ord is sufficiently large. 
%              tol = eps is a very conservative choice (and default 
%              value), where eps is the machine precision. This can lead to
%              a quite large reduced order.
%
%  Output:
%
%    Ar,
%    Br,
%    Cr        (possibly complex) matrices of the reduced system;
%    SB,
%    SC        matrices used for the oblique projection;
%    sigma     a vector containing the descending ordered singular values
%              of ZC'*ZB (which can be considered as approximations
%              to the leading Hankel singular values of the system).
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
%    However, this cannot be guaranteed. See [3] for details.
%     
%
%  References:
%
%  [1] M.S. Tombs and I. Postlethwaite.
%      Truncated balanced realization of stable, non-minimal state-space 
%      systems.
%      Int. J. Control, 46:1319-1330, 1987.
%
%  [2] T. Penzl.
%      Algorithms for model reduction of large dynamical systems.
%      Submitted for publication. 1999.
%
%  [3] J. Li and T. Penzl.
%      Approximate balanced truncation of generalized state-space systems.
%      Submitted for publication. 1999.
%
%  [4] T. Penzl.
%      LYAPACK (Users' Guide - Version 1.0).
%      1999.
%
%   
%   LYAPACK 1.0 (Thilo Penzl, Oct 1999)

% Input data not completely checked!

na = nargin;

if na < 7, tol = eps; end
if ~length(tol), tol = eps; end

[U0,S0,V0] = svd(ZC'*ZB,0);
sigma = diag(S0);

                                 % Fix order of the reduced system.
k0 = sum(sigma>=tol*sigma(1));
k = min([max_ord k0]);

VB = ZB*V0(:,1:k);
VC = ZC*U0(:,1:k);

sigma_k = sigma(1:k);

SB = VB*diag(ones(k,1)./sqrt(sigma_k));
SC = VC*diag(ones(k,1)./sqrt(sigma_k));

                                     % Compute reduced system.               
eval(lp_e( 'Ar = SC''*',name,'_m(''N'',SB);' ));
Br = SC'*B;
Cr = C*SB;




