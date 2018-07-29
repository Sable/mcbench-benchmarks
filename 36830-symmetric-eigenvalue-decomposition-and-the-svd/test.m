%TEST   Simple test of qdwheig (symmetric eigenvalue decomposition) and qdwhsvd (singular value decomposition) codes.

n = 500; % matrix size

fprintf('=====Symmetric eigendecomposition=====\n')
fprintf('Residuals and orthogonality measure should be of the order of 10^(-15).\n')
A=randn(n);A=A'+A;
[V,D] = qdwheig(A);
fprintf('QDWHEIG   :       residual = %9.2e, orthogonality = %9.2e\n', ...
          norm(A-V*D*V','fro')/norm(A,'fro'), norm(V'*V-eye(n),'fro')/sqrt(n))
[V,D] = eig(A);
fprintf('MATLAB eig:       residual = %9.2e, orthogonality = %9.2e\n\n', ...
norm(A-V*D*V','fro')/norm(A,'fro'), norm(V'*V-eye(n),'fro')/sqrt(n))

fprintf('=====Singular value decomposition=====\n')
fprintf('Residuals and orthogonality measure should be of the order of 10^(-15).\n')
A=randn(n);
[U,S,V] = qdwhsvd(A);
fprintf('QDWHSVD   :       residual = %9.2e, orthogonality = %9.2e\n', ...
          norm(A-U*S*V','fro')/norm(A,'fro'), max(norm(U'*U-eye(n),'fro')/sqrt(n),norm(V'*V-eye(n),'fro')/sqrt(n)))
[U,S,V] = svd(A);
fprintf('MATLAB svd:       residual = %9.2e, orthogonality = %9.2e\n', ...
          norm(A-U*S*V','fro')/norm(A,'fro'), max(norm(U'*U-eye(n),'fro')/sqrt(n),norm(V'*V-eye(n),'fro')/sqrt(n)))

