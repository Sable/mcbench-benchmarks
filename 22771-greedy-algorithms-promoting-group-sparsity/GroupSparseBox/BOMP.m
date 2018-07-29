function [s, residual] = BOMP(A, y, group, sparsity, err)

% Block Orthogonal Matching Pursuit - selection of group based on highest
% correlation of each group [1]

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% group = labels
% sparsity = Number of sparse groups

% Output
% s = estimated sparse signal
% r = residual 

% [1] Y. C. Eldar and H. Bolcskei, "Block Sparsity: Uncertainty  Relations 
% and Efficient Recovery," to appear in ICASSP 2009

if nargin < 5
     err = 1e-5;
end

c = max(group);
s = zeros(size(A,2),1);
r(:,1) = y; L = []; Psi = [];
for j = 1:c
    g{j} = find(group == j);
end
i = 2;

while (i < sparsity) && (norm(r(:,end))>err)
    l = A'*r(:,i-1);
    [B, IX] = sort(abs(l),'descend');
    I = g{group(IX(1))};
    L = [L' I']';
    Psi = A(:,L);
    x = Psi\y;
    yApprox = Psi*x;
    r(:,i) = y - yApprox;
    i = i + 1;
end

s(L) = x;
residual = r(:,end);