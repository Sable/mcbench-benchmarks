%% A 10x10 tridiagonal matrix, with 2 on the diagonal, -1 on the off diagonal.

A = blktridiag(2,-1,-1,10);

% The sparsity pattern is correct
spy(A)

% and the elements are as designated
full(A)

%% A lower block bidiagonal matrix with replicated blocks

% with 2x2 blocks of ones on the main diagonal, and
% 2x2 blocks of twos on the sub-diagonal

A = blktridiag(ones(2),2*ones(2),zeros(2),5);

spy(A)
full(A)

%% A block tridiagonal matrix with replicated blocks

Amd = reshape(1:9,3,3);
Asub = reshape(11:19,3,3);
Asup = reshape(21:29,3,3);
A = blktridiag(Amd,Asub,Asup,4);

spy(A)
full(A)

%% A tridiagonal matrix with random elements

Amd = rand(1,1,7);
Asub = rand(1,1,6);
Asup = rand(1,1,6);
A = blktridiag(Amd,Asub,Asup);

spy(A)
full(A)

%% A block tridiagonal matrix with distinct elements

Amd = reshape(1:27,[3 3 3]);
Asub = reshape(101:118,[3 3 2]);
Asup = reshape(201:218,[3 3 2]);
A = blktridiag(Amd,Asub,Asup);

spy(A)
full(A)

%% A block tridiagonal matrix with 2x3 fixed non-square blocks

Amd = rand(2,3);
Asub = 2*ones(2,3);
Asup = ones(2,3);
A = blktridiag(Amd,Asub,Asup,3);

spy(A)
full(A)

%% A block tridiagonal matrix with varying 3x2 non-square blocks
Amd = reshape(1:18,[3 2 3]);
Asub = reshape(101:112,[3 2 2]);
Asup = reshape(201:212,[3 2 2]);
A = blktridiag(Amd,Asub,Asup);

spy(A)
full(A)

