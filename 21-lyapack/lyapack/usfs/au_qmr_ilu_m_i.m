function au_qmr_ilu_m_i(A,mc,max_it_qmr,tol_qmr,tol_ilu,info_qmr)
%
%  Generates the data used in 'au_qmr_ilu_m'. Data are stored in global 
%  variables.
%  
%  Moreover, it defines the parameters mc, max_it_qmr, tol_qmr, 
%  tol_ilu, and info_qmr, which are needed later in 'au_qmr_ilu_l_i' and 
%  'au_qmr_ilu_s_i'.
%
%  Calling sequence:
%
%    au_qmr_ilu_m_i(A,mc,max_it_qmr,tol_qmr,tol_ilu,info_qmr)
%
%  Input:
%
%    A          real matrix;
%    mc         (= 'M' or 'C') Optimize for memory ('M') or computation ('C')
%               when shifted systems are solved by 'au_qmr_ilu_l/s' later. 
%               Optional (default value: 'M');
%    max_it_qmr maximal number of QMR steps allowed in 'au_qmr_ilu_l/s'.
%               Corresponds to parameter 'MAXIT' in MATLAB function 'qmr'.
%               Optional (default value: min([n-1,100]));
%    tol_qmr    stopping tolerance (w.r.t. normalized residual) for QMR 
%               iteration in 'au_qmr_ilu_l/s'. Corresponds to parameter 'TOL' 
%               in MATLAB function 'qmr'. Optional (default value: 1e-14);
%    tol_ilu    dropping tolerance for ILU preconditioner. Corresponds to
%               parameter 'DROPTOL' in MATLAB function 'luinc'. Optional 
%               (default value: 1e-2);
%    info_qmr   (= 0, 1, ...) If 1, warnings are printed when parameter FLAG
%               of MATLAB function 'qmr' is not equal to zero in QMR 
%               iteration in 'au_qmr_ilu_l/s'. If 0, no warnings are
%               printed. Optional (default value: 1).    
%
%  Remark:
%
%    If mc = 'M', the incomplete LU factors for A+p(i)*I are computed
%    any time 'au_qmr_ilu_s' is called, but they are not stored as global
%    variables to save memory. That means they are in general computed
%    several times, which results in additional computational cost. If
%    'mc = C', the incomplete LU factors are computed once by calling
%    'au_qmr_ilu_s_i' and stored as global variables, which results is
%    an increased memory demand. 
%
% 
%  LYAPACK 1.0 (Thilo Penzl, August 1999)

na = nargin;

if na<1 | na>6
  error('Wrong number of input arguments.');
end

if nargin < 2, mc = []; end
if nargin < 3, max_it_qmr = []; end
if nargin < 4, tol_qmr = []; end
if nargin < 5, tol_ilu = []; end
if nargin < 6, info_qmr = []; end

if ~length(mc), mc = 'M'; end
if ~length(max_it_qmr), max_it_qmr = min([size(A,1)-1,100]); end
if ~length(tol_qmr), tol_qmr = 1e-14; end
if ~length(tol_ilu), tol_ilu = 1e-2; end
if ~length(info_qmr), info_qmr = 1; end

global LP_A LP_MC LP_MAX_IT_QMR LP_TOL_QMR LP_TOL_ILU LP_INFO_QMR

LP_A = A;
LP_MC = mc;
LP_MAX_IT_QMR = max_it_qmr;
LP_TOL_QMR = tol_qmr;
LP_TOL_ILU = tol_ilu;
LP_INFO_QMR = info_qmr;





