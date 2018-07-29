%% Basic operations
% Define two int64 arrays
a = int64(1:10)'
b = int64(-5:4)'

%% 
% Test addition
a+b
%%
% Every operation also works with scalar values
a+1

%% 
% Test subtraction
a-b

%%
% Test multiplication
a.*b

%% 
% Test division and absolute value
a./ (abs(b) + 1)

%%
% Powers
int64(2)^50

%% 
% Test modulo
mod(a,2)

%%
% Bitshift
bitshift(int64(1),40)

%% Matrix multiplication
% Matrix multiplication is also supported
A = int64(100*rand(5))
B = int64(100*rand(5,3))

C = A*B
Cdouble = double(A)*double(B)

%% Timing
% Generate large matrices
A = int64(100*rand(400));
B = int64(100*rand(400));
%%
% Time the multiplication using int64
tic
C = A*B;
toc
%%
% Now try using double instead
A = double(A);
B = double(B);
tic
C = A*B;
toc
%%
% We see that using doubles is faster for big matrices, because it uses LAPACK, which is 
% heavily optimized.