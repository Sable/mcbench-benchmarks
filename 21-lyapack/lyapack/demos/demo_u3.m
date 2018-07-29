%
%  REALIZATION OF BASIC MATRIX OPERATIONS BY USER-SUPPLIED 
%  FUNCTIONS 'munu_*'
%
%
%  This demo program shows how the user-supplied functions 'munu_*' work.
%  In this particular case, we consider a generalized dynamical system
%  with symmetric matrices M and N, but we will use non-real shift
%  parameters. For this reason, 'munu_*' is used instead of 'msns_*'.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example, we use an FEM-semidiscretized problem, which leads to
% a generalized system where M (the mass matrix) and N (the negative
% stiffness matrix) are sparse, symmetric, and definite. 

load rail821   % load the matrices M N

disp('Problem dimensions:')

n = size(M,1)   % problem order

t = 3; j = sqrt(-1);            % generate complex matrix X0, which 
X0 = randn(n,t)+j*randn(n,t);   % contains much fewer columns than rows


% ----------------------------------------------------------------------- 
% Preprocessing
% ----------------------------------------------------------------------- 

[M0,ML,MU,N0,dummy,dummy,prm,iprm] = munu_pre(M,N,[],[]);

                        % munu_pre realizes a preprocessing:
                        % - The columns and rows of M and N are 
                        %   simultaneously reordered to reduce the 
                        %   bandwidth. The result is M0 and N0. prm and 
                        %   iprm are the corresponding permutation and 
                        %   inverse permutation.  
                        % - A Cholesky factorization of M is computed,
                        %   so that the implicit system matrix A0 is
                        %   A0 = inv(ML)*N0*inv(MU).  
                        % - Since we consider only the matrix A0 but not
                        %   a dynamical system, we use [] as 2nd and 3rd
                        %   input parameter. dummy = [] is returned.

figure(1), hold off, clf
spy(M)
title('Before preprocessing: nonzero pattern of M. That of N is the same.')

figure(2), hold off, clf
spy(M0)
title('After preprocessing: nonzero pattern of M_0. That of N_0 is the same.')

disp('Verification (test_1, test_2, ... should be small):')


% ----------------------------------------------------------------------- 
% Multiplication of matrix A0 with X0
% ----------------------------------------------------------------------- 

munu_m_i(M0,ML,MU,N0)   % initialization and generation of data needed 
                        % for matrix multiplications with A0

Y0 = munu_m('N',X0);   % compute Y0 = A0*X0
T0 = ML\(N0*(MU\X0));
test_1 = norm(Y0-T0,'fro')


% ----------------------------------------------------------------------- 
% Solution of system of linear equations with A0
% ----------------------------------------------------------------------- 

munu_l_i;   % initialization for solving systems with A0

Y0 = munu_l('N',X0);   % solve A0*Y0 = X0
test_2 = norm(ML\(N0*(MU\Y0))-X0,'fro')


% ----------------------------------------------------------------------- 
% Solve shifted systems of linear equations, i.e. 
% solve (A0+p(i)*I)*Y0 = X0.
% ----------------------------------------------------------------------- 

disp('Shift parameters:')
p = [ -1; -2+3*j; -2-3*j ]

munu_s_i(p)   % initialization for solution of shifted systems of linear 
              % equations with system matrix A0+p(i)*I  (i = 1,...,3)

Y0 = munu_s('N',X0,1);
test_3 = norm(ML\(N0*(MU\Y0))+p(1)*Y0-X0,'fro')

Y0 = munu_s('N',X0,2);
test_4 = norm(ML\(N0*(MU\Y0))+p(2)*Y0-X0,'fro')

Y0 = munu_s('N',X0,3);
test_5 = norm(ML\(N0*(MU\Y0))+p(3)*Y0-X0,'fro')


% ----------------------------------------------------------------------- 
% Postprocessing
% ----------------------------------------------------------------------- 
%
% There is no postprocessing.


% ----------------------------------------------------------------------- 
% Destroy global data structures (clear "hidden" global variables)
% ----------------------------------------------------------------------- 

munu_m_d;   % clear global variables initialized by munu_m_i
munu_l_d;   % clear global variables initialized by munu_l_i
munu_s_d(p);   % clear global variables initialized by munu_s_i





