%
%  REALIZATION OF BASIC MATRIX OPERATIONS BY USER-SUPPLIED 
%  FUNCTIONS 'au_qmr_ilu_*'
%
%
%  This demo program shows how the user-supplied functions 'au_qmr_ilu_*' 
%  work. 


% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example, we use a simple FDM-semidiscretized PDE problem 
% (an instationary convection-diffusion heat equation on the unit square 
% with homogeneous 1st kind boundary conditions).
% We reorder the columns and rows of the resulting stiffness matrix by
% a random permutation to generate a "bad" nonzero pattern.

n0 = 30;   % n0 = number of grid points in either space direction; 
           % n = n0^2 is the problem dimension!
           % (Change n0 to generate problems of different size.)

A = fdm_2d_matrix(n0,'10*x','100*y','0');   % Note: A is unsymmetric.
[dummy,pm] = sort(randn(n0^2,1));   % generate a random permutation
A = A(pm,pm); 

disp('Problem dimensions:')

n = size(A,1)   % problem order

t = 3; j = sqrt(-1);            % generate complex matrix X, which 
X = randn(n,t)+j*randn(n,t);    % contains much fewer columns than rows


% ----------------------------------------------------------------------- 
% Preprocessing
% ----------------------------------------------------------------------- 
%
% There is no preprocessing.

figure(1), hold off, clf
spy(A)
title('Nonzero pattern of A.')

disp('Verification (test_1, test_2, ... should be small):')


% ----------------------------------------------------------------------- 
% Multiplication of matrix A with X
% ----------------------------------------------------------------------- 

mc = 'M',   % optimize for memory, i.e., preconditioners will be 
            % generated right before any QMR run  
max_it_qmr = 50,   % maximal number of QMR iteration steps
tol_qmr = 1e-15,   % normalized residual norm for stopping the QMR 
                   % iterations
tol_ilu = 1e-2,   % dropping tolerance for generating ILU preconditioners
info_qmr = 2,   % amount of displayed information on performance of 
                % ILU-QMR iteration        

disp('NOTE: The USFs will return a warning message, when they fail to')
disp('      fulfill the stopping criteria for the ILU-QMR iteration.')
disp('      Also, the attained accuracy is displayed, which allows the')
disp('      user to judge, whether the results are still acceptable or') 
disp('      not.')
pause(5) 

au_qmr_ilu_m_i(A,mc,max_it_qmr,tol_qmr,tol_ilu,info_qmr);
              % initialization and generation of data needed for matrix 
              % multiplications with A

Y = au_qmr_ilu_m('N',X);   % compute Y = A*X (here, of course, QMR is
                           % not involved)
T = A*X;
test_1 = norm(Y-T,'fro')


% ----------------------------------------------------------------------- 
% Multiplication of (transposed) matrix A' with X
% ----------------------------------------------------------------------- 

Y = au_qmr_ilu_m('T',X);   % compute Y = A'*X (here, of course, QMR is
                           % not involved)
T = A'*X;
test_2 = norm(Y-T,'fro')


% ----------------------------------------------------------------------- 
% Solution of system of linear equations with A
% ----------------------------------------------------------------------- 

au_l_i;   % initialization for solving systems with A and A'

Y = au_qmr_ilu_l('N',X);   % solve A*Y = X
test_3 = norm(A*Y-X,'fro')


% ----------------------------------------------------------------------- 
% Solution of (transposed) system of linear equations with A'
% ----------------------------------------------------------------------- 

Y = au_qmr_ilu_l('T',X);   % solve A'*Y = X
test_4 = norm(A'*Y-X,'fro')


% ----------------------------------------------------------------------- 
% Solve shifted systems of linear equations, i.e. 
% solve (A+p(i)*I)*Y = X.
% ----------------------------------------------------------------------- 

disp('Shift parameters:')
p = [ -1; -2+3*j; -2-3*j ]

au_qmr_ilu_s_i(p)   % initialization for solution of shifted systems of 
                    % linear equations with system matrix A+p(i)*I and 
                    % A'+p(i)*I (i = 1,...,3)

Y = au_qmr_ilu_s('N',X,1);
test_5 = norm(A*Y+p(1)*Y-X,'fro')

Y = au_qmr_ilu_s('N',X,2);
test_6 = norm(A*Y+p(2)*Y-X,'fro')

Y = au_qmr_ilu_s('N',X,3);
test_7 = norm(A*Y+p(3)*Y-X,'fro')


% ----------------------------------------------------------------------- 
% Solve (transposed) shifted systems of linear equations, i.e. 
% solve (A'+p(i)*I)*Y = X.
% ----------------------------------------------------------------------- 

Y = au_qmr_ilu_s('T',X,1);
test_8 = norm(A'*Y+p(1)*Y-X,'fro')

Y = au_qmr_ilu_s('T',X,2);
test_9 = norm(A'*Y+p(2)*Y-X,'fro')

Y = au_qmr_ilu_s('T',X,3);
test_10 = norm(A'*Y+p(3)*Y-X,'fro')


% ----------------------------------------------------------------------- 
% Postprocessing
% ----------------------------------------------------------------------- 
%
% There is no postprocessing.


% ----------------------------------------------------------------------- 
% Destroy global data structures (clear "hidden" global variables)
% ----------------------------------------------------------------------- 

au_qmr_ilu_m_d;   % clear global variables initialized by au_qmr_ilu_m_i
au_qmr_ilu_l_d;   % clear global variables initialized by au_qmr_ilu_l_i
au_qmr_ilu_s_d(p);   % clear global variables initialized by 
                     % au_qmr_ilu_s_i





