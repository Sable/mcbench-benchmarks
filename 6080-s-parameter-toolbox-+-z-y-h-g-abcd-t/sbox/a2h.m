function h = a2h(A);

% H = a2h(ABCD)
%
% ABCD to Hybrid-H transformation
% only for 2x2 matrices

d = A(1,1)*A(2,2) - A(1,2)*A(2,1);

while abs(A(2,2)) < 1e-8
    A(2,2) = A(2,2)*(1+rand*1e-8);
end;

h(1,1) = A(1,2)/A(2,2);
h(1,2) = d/A(2,2);
h(2,1) = -1/A(2,2);
h(2,2) = A(2,1)/A(2,2);
