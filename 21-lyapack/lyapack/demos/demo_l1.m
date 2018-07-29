%
%  SOLUTION OF LYAPUNOV EQUATION BY THE LRCF-ADI METHOD (AND GENERATION 
%  OF ADI PARAMETERS)
%
%  This demo program shows how the routines 'lp_para' (computation of
%  ADI shift parameters) and 'lp_lradi' (LRCF-ADI iteration for the
%  solution of the Lyapunov equation F*X+X*F'=-G*G') work.  Also, the 
%  use of user-supplied functions is demonstrated.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example, we use a simple FDM-semidiscretized PDE problem 
% (an instationary convection-diffusion heat equation on the unit square 
% with homogeneous 1st kind boundary conditions).

n0 = 20;   % n0 = number of grid points in either space direction; 
           % n = n0^2 is the problem dimension!
           % (Change n0 to generate problems of different size.)

F = fdm_2d_matrix(n0,'10*x','100*y','0');
G = fdm_2d_vector(n0,'.1<x<=.3');

disp('Problem dimensions:')

n = size(G,1)   % problem order
m = size(G,2)   % number of columns in factor of r.h.s. (mostly, the rank
                % of the r.h.s.)


% ----------------------------------------------------------------------- 
% Initialization/generation of data structures used in user-supplied 
% functions and computation of ADI shift parameters
% ----------------------------------------------------------------------- 
%
% Note that the routines 'au_m_i', 'au_l_i', and 'au_s_i' create global
% variables, which contain the data that is needed for the efficient
% realization of basic matrix operations with F (multiplications,
% solution of systems of linear equations, solution of shifted systems 
% of linear equations).

name = 'au';   % basis name of user-supplied functions applied to the
               % problem with nonsymmetric F. Note: in this class of
               % user-supplied functions, sparse LU factorizations are 
               % applied to solve (shifted) systems of linear equations.

f = flops;
[F0,G0,dummy,prm,iprm] = au_pre(F,G,[]);   % preprocessing (reordering for 
                                           % bandwidth reduction)     
                                           % Note the dummy parameter, 
                                           % which will be set to [] on
                                           % exit.
                                               
au_m_i(F0);   % initialization for matrix multiplications with F0

au_l_i;   % initialization for solving systems with F0 (This is needed in
          % the Arnoldi algorithm w.r.t. inv(F0). The Arnoldi algorithm
          % is part of the algorithm in 'lp_para'.)

disp('Parameters for heuristic algorithm which computes ADI parameters:')
l0 = 15   % desired number of distinct shift parameters                  
kp = 50   % number of steps of Arnoldi process w.r.t. F0
km = 25   % number of steps of Arnoldi process w.r.t. inv(F0)

b0 = ones(n,1);   % This is just one way to choose the Arnoldi start vector. 

p = lp_para(name,[],[],l0,kp,km,b0);   % computation of ADI shift parameters

disp('Actual number of ADI shift parameters:');
l = length(p)

disp('ADI shift parameters:');
p

au_s_i(p)   % initialization for shifted systems of linear equations with 
            % F0+p(i)*I  (i = 1,...,l)

disp('Flops required for a-priori computations:')
a_priori_flops = flops-f

% ----------------------------------------------------------------------- 
% Solution of Lyapunov equation F*X+X*F' = -G*G' (or, more precisely, 
% the transformed equation F0*X0+X0*F0' = -G0*G0') by LRCF-ADI iteration
% ----------------------------------------------------------------------- 
%
% The approximate solution is given by the low rank Cholesky factor Z0, 
% i.e., Z0*Z0' is approximately X0
%
% The stopping criteria are chosen, such that the iteration is stopped
% shortly after the residual curve stagnates. This requires the sometimes
% expensive computation of the residual norms. (If you want to avoid 
% this, you might choose max_it = 500 (large value), min_res = 0 
% ("avoided"), with_rs = 'N' ("avoided"), min_in = 1e-12 ("activated").)

disp('Parameters for stopping criteria in LRCF-ADI iteration:')
max_it = 500   % max. number of iteration steps (here, a very large 
               % value, which will probably not stop the iteration)
min_res = 0   % tolerance for normalized residual norm (criterion 
              % is "avoided")
with_rs = 'S'   % stopping criterion "stagnation of the normalized 
                % residual norms" activated 
min_in = 0   % threshold for smallness of values ||V_i||_F (criterion
             % is "avoided")

disp('Further input parameters of the routine ''lp_lradi'':');
tp = 'B'   % type of Lyapunov equation to be solved 
           % (here, F0*X0+X0*F0'=-G0*G0')
zk = 'Z'   % compute Z0 or generate Z0*Z0'*K0 (here, Z0)
rc = 'C'   % compute possibly complex Z0 or demand for real Z0 (here,
           % a complex matrix Z0 may be returned)
Kf = [], Bf = []   % feedback matrices (these parameters are only used 
                   % in the Newton iteration)  
info = 3    % information level (here, maximal amount of information is
            % provided during the LRCF-ADI iteration)

figure(1), hold off; clf;   % (lp_lradi will plot residual history.)

[Z0,flag,res,flp] = lp_lradi(tp,zk,rc,name,Bf,Kf,G0,p,max_it,min_res,...
                               with_rs,min_in,info);  

                    % Note that in lp_lradi the transformed r.h.s.
                    % matrix G0 must be used.

disp('Termination flag of the routine ''lp_lradi'':')
flag 
disp('Internally computed normalized residual norm (of final iterate):');
final_nrn = res(end)
disp('Number of flops required for the whole iteration');
disp('(without a-priori computation and computation of residual norm):');
lrcf_adi_flops = flp(end)


% ----------------------------------------------------------------------- 
% Postprocessing, destroy global data structures
% ----------------------------------------------------------------------- 
%
% NOTE: The matrices F and G have been reordered in the preprocessing 
% step (''au_pre'') resulting in F0 and G0. That means, the rows of the 
% matrix Z0 must be re-reordered in a postprocessing step to obtain the 
% solution to the original Lyapunov equation!

Z = au_pst(Z0,iprm);

au_m_d;   % clear global variables initialized by au_m_i
au_l_d;   % clear global variables initialized by au_l_i
au_s_d(p);   % clear global variables initialized by au_s_i

disp('Size of Z:');
size_Z = size(Z)
disp('Is Z real ( 0 = no, 1 = yes )?')
is_real = ~any(any(imag(Z)))


% ----------------------------------------------------------------------- 
% Verify the result
% ----------------------------------------------------------------------- 
%
% Note that this is only an "illustrative" way of verifying the accuracy
% by computing the (normalized) residual norm. A more practical (because
% less expensive) way is evaluating the residual norm by means of the 
% routine 'lp_nrm' (Must be applied before postprocessing!), if the 
% residual norms have not been generated during the iteration.

disp('The attained residual norm:')
res_norm = norm(F*Z*Z'+Z*Z'*F'+G*G','fro')
disp('The attained normalized residual norm:')
normal_res_norm = res_norm/norm(G*G','fro')



