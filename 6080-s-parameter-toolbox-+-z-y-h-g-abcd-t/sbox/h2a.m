function A = h2a(h);

% ABCD = h2a(G)
%
% Hybrid H to ABCD transformation
% only for 2x2 matrices

d = h(1,1) * h(2,2) - h(1,2) * h(2,1);

while abs(h(2,1)) < 1e-8
    h(2,1) = h(2,1)*(1+rand*1e-8);
end;

A(1,1) = -d/h(2,1);
A(1,2) = -h(1,1)/h(2,1);
A(2,1) = -h(2,2)/h(2,1);
A(2,2) = -1/h(2,1);