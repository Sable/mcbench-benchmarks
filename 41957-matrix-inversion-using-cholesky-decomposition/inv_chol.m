function Y = inv_chol(L)
% Matrix Inversion using Cholesky Decomposition
%
% Finds the inverse of the matrix X, given its (lower triangular) Cholesky
% Decomposition; i.e. X = LL', according to the paper 'Matrix Inversion
% Using Cholesky Decomposition', Aravindh Krishnamoorthy, Deepak Menon,
% arXiv:1111.4144.
%

% Version 0.1, 2013-05-25, Aravindh Krishnamoorthy
% e-mail: aravindh.k@ieee.org

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = size(L, 1) ;
Y = zeros(N, N) ;
% Work with the upper triangular matrix
R = L' ;
% Construct the auxillary diagonal matrix S = 1/rii
S = inv(diag(diag(R))) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=N:-1:1
    for i=j:-1:1
        Y(i,j) = S(i,j) - R(i,i+1:end)*Y(i+1:end,j) ;
        Y(i,j) = Y(i,j)/R(i,i) ;
        % Write out the symmetric element
        Y(j,i) = conj(Y(i,j)) ;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N = 4 ;
% X = complex(randn(N, N), randn(N, N)) ;
% X = X'*X ;
% L = chol(X, 'lower') ;
% I = inv_chol(L) ;
% norm(I-inv(X))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
