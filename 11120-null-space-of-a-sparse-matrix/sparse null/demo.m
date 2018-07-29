%--------------------------------------------------------------------------
%           SET PARAMETERS
%--------------------------------------------------------------------------
n           = 10000;                %matrix dimension
k           = 30;                   %null space dimension
K           = .2;                   %controls matrix sparsity
smax        = 10^6;                 %maximal singular value of the matrix
smin        = 10^-8;                %minimal singular value of the matrix
tol         = 10^-11;               %tolerance

%--------------------------------------------------------------------------
%           CREATE A MATRIX
%--------------------------------------------------------------------------
smax        = log(smax);
smin        = log(smin);
kk          = n-k;
a           = -(smax-smin)/(kk-1);
S           = smax:a:smin;
S           = diag(sparse([exp(S)';sparse(k,1)]));

U           = speye(n);
dU          = triu(sprandn(n,n,1/n*K),1);
U           = U+dU;
P           = randperm(n);
U           = U(P,:);
A           = U*S*U^-1;

%--------------------------------------------------------------------------
%           DISPLAY PARAMETERS
%--------------------------------------------------------------------------
disp(' ');
disp('The Matrix:');
disp(['  ' num2str(n) ' - dimansion']);
disp(['  ' num2str(k) ' - null space dimension']);
disp(['  ' num2str(nnz(A)) ' - number of nonzero elements']);
disp(' ');
disp(['  ' num2str(exp(smax)) ' - maximal singular value']);
disp(['  ' num2str(exp(smin)) ' - minimal singular value']);
disp(['  ' num2str(tol) ' - tolerance']);
disp(' ');

%--------------------------------------------------------------------------
%           FIND NULL SPACE
%--------------------------------------------------------------------------
tic;
SpLeft      = spspaces(A,1,10^-10);
t           = toc;

Q           = SpLeft{1};
J           = SpLeft{3};

kL          = length(J);
nL          = norm(Q(J,:)*A,1);

%--------------------------------------------------------------------------
%           DISPLAY RESULTS
%--------------------------------------------------------------------------
disp(' ');
disp('Results:');
disp(['  ' num2str(t) ' - elapsed time']);
disp(['  ' num2str(kL) ' - estimated null space dimension']);
disp(['  ' num2str(nL) ' - norm of residuals N*A, where N is a null space']);