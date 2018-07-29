%
%  SOLUTION OF RICCATI EQUATION BY LRCF-NM AND SOLUTION OF LINEAR-
%  QUADRATIC OPTIMAL CONTROL PROBLEM BY LRCF-NM-I
%
%  This demo program shows how both modes (i.e., the one for LRCF-NM and
%  the one for LRCF-NM-I) work. Also, the use of user-supplied functions 
%  is demonstrated in this context.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example, we use a simple FDM-semidiscretized PDE problem 
% (an instationary heat equation on the unit square with homogeneous 1st 
% kind boundary conditions).
%
% Note that the negative stiffness matrix A is symmetric.

n0 = 20;   % n0 = number of grid points in either space direction; 
           % n = n0^2 is the problem dimension!
           % (Change n0 to generate problems of different size.)

A = fdm_2d_matrix(n0,'0','0','0');
B = fdm_2d_vector(n0,'.1<x<=.3');
C = (fdm_2d_vector(n0,'.7<x<=.9'))';

Q0 = 10   % Q = Q0*Q0' = 100
R0 = 1   % R = R0*R0' = 1

K_in = [];   % Initial feedback K is zero (Note that A is stable).  

disp('Problem dimensions:')

n = size(A,1)   % problem order (number of states)
m = size(B,2)   % number of inputs
q = size(C,1)   % number of outputs


% ----------------------------------------------------------------------- 
% Initialization/generation of data structures used in user-supplied 
% functions
% ----------------------------------------------------------------------- 
%
% Note that we use routines 'au_*' rather than the routines 'as_*', 
% although A is symmetric. This is because ADI shift parameters w.r.t. 
% the nonsymmetric closed loop matrix A-B*K' (generated in the routine
% lp_lrnm) might be not real. The routines 'as_*' are resticted to 
% problems, where the shift parameters are real.

name = 'au';

[A0,B0,C0,prm,iprm] = au_pre(A,B,C);   % preprocessing (reordering for 
                                       % bandwidth reduction)     
 
% Note that K_in is zero. Otherwise it needs not be transformed as well.

au_m_i(A0);   % initialization for matrix multiplications with A0

au_l_i;   % initialization for solving systems with A0 (This is needed in
          % the Arnoldi algorithm w.r.t. inv(A0). The Arnoldi algorithm
          % is part of the algorithm in 'lp_para', which in turn will
          % be invoked in each Newton step in the routine 'lp_lrnm'.)

% Note that 'au_s_i' will be invoked repeatedly in 'lp_lrnm'. 

disp('Parameters for heuristic algorithm which computes ADI parameters:')
l0 = 15   % desired number of distinct shift parameters                  
kp = 50   % number of steps of Arnoldi process w.r.t. A0-B0*K0'
km = 25   % number of steps of Arnoldi process w.r.t. inv(A0-B0*K0')


% ----------------------------------------------------------------------- 
% Compute LRCF Z0 by LRCF-NM
% ----------------------------------------------------------------------- 
%
% The approximate solution is given by the low rank Cholesky factor Z0, 
% i.e., Z0*Z0' is approximately X0, where X0 is the solution of the 
% transformed CARE
%
%   C0'*Q0*Q0'*C0+A0'*X0+X0*A0-X0*B0*inv(R0*R0')*B0'*X0 = 0.
%
% The stopping criteria for both the (outer) Newton iteration and the
% (inner) LRCF-ADI iteration are chosen, such that the iterations are 
% stopped shortly after the residual curves stagnate. This requires 
% the sometimes expensive computation of the CALE and CARE residual 
% norms.

disp('Parameters for stopping the (outer) Newton iteration:')
max_it_r = 20   % max. number of iteration steps (here, a very large 
                % value, which will probably not stop the iteration)
min_res_r = 0   % tolerance for normalized residual norm (criterion 
                % is "avoided")
with_rs_r = 'S'   % stopping criterion "stagnation of the normalized 
                  % residual norms" activated 
min_ck_r = 0   % stopping criterion "smallness of the RCF" ("avoided") 
               % (RCF = relative change of the feedback matrix)
with_ks_r = 'N'   % stopping criterion "stagnation of the RCF" 
                  % (criterion is "avoided")

disp('Parameters for stopping the (inner) LRCF-ADI iterations:')
max_it_l = 500   % max. number of iteration steps (here, a very large 
                 % value, which will probably not stop the iteration)
min_res_l = 0   % tolerance for normalized residual norm (criterion 
                % is "avoided")
with_rs_l = 'S'   % stopping criterion "stagnation of the normalized 
                  % residual norms" activated 
min_in_l = 0   % threshold for smallness of values ||V_i||_F 
               % (criterion is "avoided")

disp('Further input parameters of the routine ''lp_lrnm'':');
zk = 'Z'   % compute Z0 by LRCF-NM or generate directly 
           % K_out = Z0*Z0'*K_in (here, Z0 is computed)
rc = 'C'   % compute possibly complex Z0 or demand for real Z0 (here,
           % a complex matrix Z0 may be returned)
info_r = 3;   % information level for the Newton iteration (here, 
              % maximal amount of information is provided)
info_l = 3;   % information level for LRCF-ADI iterations (here, 
              % maximal amount of information is provided)

randn('state',0);   % (This measure is taken to make the test results
                    % repeatable. Note that a random vector is involved
                    % into the computation of ADI parameters inside
                    % 'lp_lrnm'.)

[Z0, flag_r, res_r, flp_r, flag_l, its_l, res_l, flp_l] = lp_lrnm(...
zk, rc, name, B0, C0, Q0, R0, K_in, max_it_r, min_res_r, with_rs_r,...
min_ck_r, with_ks_r, info_r, kp, km, l0, max_it_l, min_res_l,...
with_rs_l, min_in_l, info_l ); 


disp('Results for (outer) Newton iteration in LRCF-NM:')

disp('Termination flag:')
flag_r 

disp('Internally computed normalized residual norm (of final iterate):');
final_nrn_r = res_r(end)


disp('Results for (inner) LRCF-ADI iterations in LRCF-NM:')

disp('Termination flags:')
flag_l

disp('Number of LRCF-ADI iteration steps:')
its_l

disp('Internally computed normalized residual norms (of final iterates):');
final_nrn_l = [];
for i = 1:length(its_l) 
  final_nrn_l = [final_nrn_l; res_l(its_l(i)+1,i)];
end
final_nrn_l


% ----------------------------------------------------------------------- 
% Compute (approximately) optimal feedback K0 by LRCF-NM-I
% ----------------------------------------------------------------------- 
%
% Here, the matrix K0 that solves the (transformed) linear-quadratic
% optimal control problem is computed by LRCF-NM-I.
%
% The stopping criteria for both the (outer) Newton iteration and the
% (inner) LRCF-ADI iteration are chosen by inexpensive heuristic 
% criteria.

disp('Parameters for stopping the (outer) Newton iteration:')
max_it_r = 20   % max. number of iteration steps (here, a very large 
                % value, which will probably not stop the iteration)
min_res_r = 0   % tolerance for normalized residual norm (criterion 
                % is "avoided")
with_rs_r = 'N'   % stopping criterion "stagnation of the normalized 
                  % residual norms" (criterion is "avoided")  
min_ck_r = 1e-12   % stopping criterion "smallness of the RCF" 
                   % ("activated")   
with_ks_r = 'L'   % stopping criterion "stagnation of the RCF" 
                  % ("activated")

disp('Parameters for stopping the (inner) LRCF-ADI iterations:')
max_it_l = 500   % max. number of iteration steps (here, a very large 
                 % value, which will probably not stop the iteration)
min_res_l = 0   % tolerance for normalized residual norm (criterion 
                % is "avoided")
with_rs_l = 'N'   % stopping criterion "stagnation of the normalized 
                  % residual norms" (criterion is "avoided") 
min_in_l = 1e-12   % threshold for smallness of values in ||V_i||_F 
                   % (criterion is "activated")

disp('Further input parameters of the routine ''lp_lradi'':');
zk = 'K'
rc = 'C'
info_r = 3
info_l = 3

randn('state',0);

[K0, flag_r, flp_r, flag_l, its_l, flp_l] = ...
lp_lrnm( zk, name, B0, C0, Q0, R0, K_in, max_it_r, min_ck_r, ...
with_ks_r, info_r, kp, km, l0, max_it_l, min_in_l, info_l ); 


disp('Results for (outer) Newton iteration in LRCF-NM-I:')

disp('Termination flag:')
flag_r 


disp('Results for (inner) LRCF-ADI iterations in LRCF-NM-I:')

disp('Termination flags:')
flag_l

disp('Number of LRCF-ADI iteration steps:')
its_l


% ----------------------------------------------------------------------- 
% Postprocessing, destroy global data structures
% ----------------------------------------------------------------------- 
%
% Note that both the LRCF Z0 and the state feedback K0 must be 
% postprocessed in order to attain the results for the original problems.

Z = au_pst(Z0,iprm);
K = au_pst(K0,iprm);

% Note that 'au_s_d' has already been invoked in 'lp_lrnm'. 

au_l_d;   % clear global variables initialized by au_l_i
au_m_d;   % clear global variables initialized by au_m_i

disp('Size of Z:');
size_Z = size(Z)
disp('Is Z real ( 0 = no, 1 = yes )?')
Z_is_real = ~any(any(imag(Z)))
disp('Is K real ( 0 = no, 1 = yes )?')
K_is_real = ~any(any(imag(K)))


% ----------------------------------------------------------------------- 
% Verify the result
% ----------------------------------------------------------------------- 
%
% Note that this is only an "illustrative" way of verifying the accuracy
% by computing the (normalized) residual norm of the CARE. A more 
% practical (because less expensive) way is evaluating the residual norm 
% by means of the routine 'lp_rcnrm' (Must be applied before 
% postprocessing!), if the residual norms have not been generated during 
% the iteration.
%
% In general the result for LRCF-NM-I cannot be verified. However, we 
% will compare the delivered feedback K with the feedback matrix computed
% by use of the LRCF Z.

disp('The attained CARE residual norm:')
res_norm = norm(C'*Q0*Q0'*C+A'*Z*Z'+Z*Z'*A-Z*Z'*B*((R0*R0')\B')*Z*Z',...
'fro')
disp('The attained normalized CARE residual norm:')
normal_res_norm = res_norm/norm(C'*Q0*Q0'*C,'fro')

disp('The normalized deviation of the feedback matrices computed by')
disp('LRCF-NM and LRCF-NM-I (small value --> high accuracy):');
KE = Z*Z'*(B/(R0*R0'));
norm_dev = norm(K-KE,'fro')/max([norm(K,'fro'),norm(KE,'fro')])


