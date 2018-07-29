%
%  REALIZATION OF BASIC MATRIX OPERATIONS BY USER-SUPPLIED 
%  FUNCTIONS 'au_*'
%
%
%  This demo program shows how the user-supplied functions 'au_*' work.
%  That means we consider (possibly) unsymmetric matrices and (possibly)
%  non-real shift parameters.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example we use a simple FDM-semidiscretized PDE problem 
% (an instationary convection-diffusion heat equation on the unit square 
% with homogeneous 1st kind boundary conditions).
% We reorder the columns and rows of the resulting stiffness matrix by
% a random permutation, to generate a "bad" nonzero pattern.

n0 = 20;   % n0 = number of grid points in either space direction; 
           % n = n0^2 is the problem dimension!
           % (Change n0 to generate problems of different size.)

A = fdm_2d_matrix(n0,'10*x','100*y','0');   % Note: A is unsymmetric.
[dummy,pm] = sort(randn(n0^2,1));   % generate a random permutation
A = A(pm,pm); 

disp('Problem dimensions:')

n = size(A,1)   % problem order

t = 3; j = sqrt(-1);            % generate complex matrix X0, which 
X0 = randn(n,t)+j*randn(n,t);   % contains much fewer columns than rows


% ----------------------------------------------------------------------- 
% Preprocessing
% ----------------------------------------------------------------------- 

[A0,dummy,dummy,prm,iprm] = au_pre(A,[],[]);  

                        % au_pre realizes a preprocessing:
                        % - The columns and rows of A are simultaneously
                        %   reordered to reduce the bandwidth. The result
                        %   is A0. prm and iprm are the corresponding
                        %   permutation and inverse permutation.  
                        % - Since we consider only the matrix A but not
                        %   a dynamical system, we use [] as 2nd and 3rd
                        %   input parameter. dummy = [] is returned.

figure(1), hold off, clf
spy(A)
title('Before preprocessing: nonzero pattern of A.')

figure(2), hold off, clf
spy(A0)
title('After preprocessing: nonzero pattern of A_0.')

disp('Verification (test_1, test_2, ... should be small):')


% ----------------------------------------------------------------------- 
% Multiplication of matrix A0 with X0
% ----------------------------------------------------------------------- 

au_m_i(A0);   % initialization and generation of data needed for matrix 
              % multiplications with A0 and A0'

Y0 = au_m('N',X0);   % compute Y0 = A0*X0
T0 = A0*X0;
test_1 = norm(Y0-T0,'fro')


% ----------------------------------------------------------------------- 
% Multiplication of (transposed) matrix A0' with X0
% ----------------------------------------------------------------------- 

Y0 = au_m('T',X0);   % compute Y0 = A0'*X0
T0 = A0'*X0;
test_2 = norm(Y0-T0,'fro')


% ----------------------------------------------------------------------- 
% Solution of system of linear equations with A0
% ----------------------------------------------------------------------- 

au_l_i;   % initialization for solving systems with A0 and A0'

Y0 = au_l('N',X0);   % solve A0*Y0 = X0
test_3 = norm(A0*Y0-X0,'fro')


% ----------------------------------------------------------------------- 
% Solution of (transposed) system of linear equations with A0'
% ----------------------------------------------------------------------- 

Y0 = au_l('T',X0);   % solve A0'*Y0 = X0
test_4 = norm(A0'*Y0-X0,'fro')


% ----------------------------------------------------------------------- 
% Solve shifted systems of linear equations, i.e. 
% solve (A0+p(i)*I)*Y0 = X0.
% ----------------------------------------------------------------------- 

disp('Shift parameters:')
p = [ -1; -2+3*j; -2-3*j ]

au_s_i(p)   % initialization for solution of shifted systems of linear 
            % equations with system matrix A0+p(i)*I and A0'+p(i)*I
            % (i = 1,...,3)

Y0 = au_s('N',X0,1);
test_5 = norm(A0*Y0+p(1)*Y0-X0,'fro')

Y0 = au_s('N',X0,2);
test_6 = norm(A0*Y0+p(2)*Y0-X0,'fro')

Y0 = au_s('N',X0,3);
test_7 = norm(A0*Y0+p(3)*Y0-X0,'fro')


% ----------------------------------------------------------------------- 
% Solve (transposed) shifted systems of linear equations, i.e. 
% solve (A0'+p(i)*I)*Y0 = X0.
% ----------------------------------------------------------------------- 

Y0 = au_s('T',X0,1);
test_8 = norm(A0'*Y0+p(1)*Y0-X0,'fro')

Y0 = au_s('T',X0,2);
test_9 = norm(A0'*Y0+p(2)*Y0-X0,'fro')

Y0 = au_s('T',X0,3);
test_10 = norm(A0'*Y0+p(3)*Y0-X0,'fro')


% ----------------------------------------------------------------------- 
% Postprocessing
% ----------------------------------------------------------------------- 
%
% There is no postprocessing.


% ----------------------------------------------------------------------- 
% Destroy global data structures (clear "hidden" global variables)
% ----------------------------------------------------------------------- 

au_m_d;   % clear global variables initialized by au_m_i
au_l_d;   % clear global variables initialized by au_l_i
au_s_d(p);   % clear global variables initialized by au_s_i





