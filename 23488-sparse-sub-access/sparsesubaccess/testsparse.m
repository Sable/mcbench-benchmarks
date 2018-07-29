% Script to calibrate and test sparse access package

% Install the package if necessary
Tref=spcalib();
if Tref.factory
    spidx_install();
end

% Test sparse matrix
n=1e5;
nz=1e6;
i=ceil(n*rand(1,nz));
j=ceil(n*rand(1,nz));
s=rand(size(i));
S=sparse(i,j,s,n,n);

% Test set existing values
tic
S = setsparse(S, i, j, 1-s);
toc

% Test get values
nz=1e6;
i=ceil(n*rand(1,nz));
j=ceil(n*rand(1,nz));
tic
v = getsparse(S, i, j);
toc

% Test set large set values random indices
tic
S = setsparse(S, i, j, 1-v);
toc

% test basic assign values
S = sparse([1 n],[1 n],[1 2],n,n)
S = setsparse(S, [1 2 n-1], [1 3 n-2], [3 4 5], @asgn)

% Test using function handle
S = setsparse([1 n-1], [1 n-2], [2 3], S, @rdivide)

% Test using function handle
S = setsparse(S, [1 n-1], [1 n-2], [1 1],@minus)

% Test complex, logical
getsparse(logical(S), [1 2 2 n-1], [1 2 3 n-2])
[I J s]=find(S);
S = setsparse(S, I, J, s+1i);
getsparse(S, [1 2 2 n-1], [1 2 3 n-2])