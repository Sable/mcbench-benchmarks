function X = tdma(A,B,C,D)
%TriDiagonal Matrix Algorithm (TDMA) or Thomas Algorithm
% A_i*X_(i-1) + B_i*X_i + C_i*X_(i+1) = D_i (where A_1 = 0, C_n = 0)
% A,B,C,D are input vectors. X is the solution, also a vector. 

% Copyright 2013 The MathWorks, Inc.

Cp = C;
Dp = D;
n = length(A);
X = zeros(n,1);
% Performs Gaussian elimination
Cp(1) = C(1)/B(1);
Dp(1) = D(1)/B(1); 
for i = 2:n
Cp(i) = C(i)/(B(i)-Cp(i-1)*A(i));
Dp(i) = (D(i)-Dp(i-1)*A(i))/(B(i)-Cp(i-1)*A(i));
end
% Backward substitution, since X(n) is known first.
X(n) = Dp(n);
for i = n-1:-1:1
X(i) = Dp(i)-Cp(i)*X(i+1);
end
