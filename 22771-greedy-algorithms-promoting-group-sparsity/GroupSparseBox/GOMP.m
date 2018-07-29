function [s, residual] = GOMP(A, y, group, err)

% Group orthogonal Matching Pursuit - selection of group based on highest
% average correlation of each group

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% group = labels

% Output
% s = estimated sparse signal
% residual = residual 

% Copyright (c) Angshul Majumdar 2009

if nargin < 5
     err = 1e-5;
end

c = max(group);
s = zeros(size(A,2),1); t = 2.5;
r(:,1) = y; L = []; Psi = [];
i = 2;
for j = 1:c
    g{j} = find(group == j);
end

while (i < c) && (norm(r(:,end))>err)
    l = A'*r(:,i-1);
    for j = 1:c
        lg(j) = mean(abs(l(g{j})));
    end
    [B, IX] = sort(lg, 'descend');
    L = [L' g{IX(1)}']';
    Psi = A(:,L);
    x = Psi\y;
    r(:,i) = y - Psi*x;
    i = i+1;
end

s(L) = x;
residual = r(:,end);