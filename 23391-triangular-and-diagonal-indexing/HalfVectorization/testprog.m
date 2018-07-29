% A test script for the Half-vectorization package

% Random matrix
A=ceil(20*rand(5,7))

% Numerotation of diagonals
disp('Numerotation of diagonals');
B=zeros(size(A));
[I J]=itril(size(A),Inf);
B(itril(size(A),Inf))=J-I;
disp(B);

% Get the lower part, shift down by 2
disp('Get the lower part, shift down by 2...');

% Using Matlab
T = tril(ones(size(A)),-2);
HalfV = A(T==1);
disp('Using Matlab TRIL');
disp(HalfV);

% Using c
I = itril(size(A),-2);
HalfV = A(I);
disp('Using indices returned by itril');
disp(HalfV);

% Using Elimination Matrix
HaftV = EliminationM(size(A),-2)*A(:);
disp('Using elimination matrix');
disp(HalfV);

% Replace the diagonal
disp('Replace the diagonal');
Idiag = idiag(size(A));
A(Idiag) = -A(Idiag);
disp(A);

% TOEPLITZ
c = ceil(20*rand(5,1))
r = ceil(20*rand(7,1))
T = mytoeplitz(c, r)
