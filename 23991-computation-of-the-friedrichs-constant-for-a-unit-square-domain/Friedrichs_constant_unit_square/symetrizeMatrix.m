function A_sym = symetrizeMatrix(A)
[i,j,k]=find(A);
W=sparse([i; j], [j; i], ones(size(k,1)*2,1));
A_help=sparse([i; j], [j; i], [k; k]);
[i,j,k]=find(A_help);
[i,j,kk]=find(W);
A_sym=sparse(i,j,(kk.^(-1)).*k); %Now Kantennr_sym is a symetric form of Kantennr