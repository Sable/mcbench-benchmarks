function z = a2z(A);

% Z = a2z(ABCD)
%
% ABCD to Impedance transformation
% only for 2x2 matrices

d = A(1,1)*A(2,2) - A(1,2)*A(2,1);

while abs(A(2,1)) < 1e-8
    A(2,1) = A(2,1)*(1+rand*1e-8);
end;

z(1,1) = A(1,1)/A(2,1);
z(1,2) = d/A(2,1);
z(2,1) = 1/A(2,1);
z(2,2) = A(2,2)/A(2,1);
