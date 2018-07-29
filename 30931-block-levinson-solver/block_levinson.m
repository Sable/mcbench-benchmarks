function x = block_levinson(y, L)
%BLOCK_LEVINSON Block Levinson recursion for efficiently solving 
%symmetric block Toeplitz matrix equations.
%   BLOCK_LEVINSON(Y, L) solves the matrix equation T * x = y, where T 
%   is a symmetric matrix with block Toeplitz structure, and returns the 
%   solution vector x. The matrix T is never stored in full (because it 
%   is large and mostly redundant), so the input parameter L is actually 
%   the leftmost "block column" of T (the leftmost d columns where d is 
%   the block dimension).

%   Author: Keenan Pepper
%   Last modified: 2007-12-23

%   References:
%     [1] Akaike, Hirotugu (1973). "Block Toeplitz Matrix Inversion".
%     SIAM J. Appl. Math. 24 (2): 234-241

s = size(L);
d = s(2);                 % Block dimension
N = s(1) / d;             % Number of blocks

B = reshape(L, [d,N,d]);  % This is just to get the bottom block row B
B = permute(B, [1,3,2]);  % from the left block column L
B = flipdim(B, 3);
B = reshape(B, [d,N*d]);

f = L(1:d,:)^-1;          % "Forward" block vector
b = f;                    % "Backward" block vector
x = f * y(1:d);           % Solution vector

for n = 2:N
    ef = B(:,(N-n)*d+1:N*d) * [f;zeros(d)];
    eb = L(1:n*d,:)' * [zeros(d);b];
    ex = B(:,(N-n)*d+1:N*d) * [x;zeros(d,1)];
    A = [eye(d),eb;ef,eye(d)]^-1;
    fn = [[f;zeros(d)],[zeros(d);b]] * A(:,1:d);
    bn = [[f;zeros(d)],[zeros(d);b]] * A(:,d+1:end);
    f = fn;
    b = bn;
    x = [x;zeros(d,1)] + b * (y((n-1)*d+1:n*d) - ex);
end
