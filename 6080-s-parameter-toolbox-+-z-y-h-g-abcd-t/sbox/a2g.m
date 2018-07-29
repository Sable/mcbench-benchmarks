function g = a2g(A);

% G = a2g(ABCD)
%
% ABCD to Hybrid-G transformation
% only for 2x2 matrices

d = A(1,1)*A(2,2) - A(1,2)*A(2,1);

while abs(A(1,1)) < 1e-8
    A(1,1) = A(1,1)*(1+rand*1e-8);
end;

g(1,1) = A(2,1)/A(1,1);
g(1,2) = -d/A(1,1);
g(2,1) = 1/A(1,1);
g(2,2) = A(1,2)/A(1,1);
