function [s, residual] = ReGOMP(A, y, group, sparsity, err)

% Regularized Group Orthogonal Matching Pursuit - Combining ideas from [1]
% and [2]

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% group = labels
% sparsity = Number of sparse groups

% Output
% s = estimated sparse signal
% residual = residual 

% Copyright (c) Angshul Majumdar 2009

% [1] Y. C. Eldar and H. Bolcskei, "Block Sparsity: Uncertainty  Relations 
% and Efficient Recovery," to appear in ICASSP 2009
% [2] D. Needell and R. Vershynin, “Uniform uncertainty principle and 
% signal recovery via regularized orthogonal matching pursuit,”
% http://arxiv.org/PS_cache/arxiv/pdf/0707/0707.4203v4.pdf

if nargin < 5
     err = 1e-5;
end
 
n = sparsity;
c = max(group);
s = zeros(size(A,2),1);
r(:,1) = y; L = []; Psi = [];
i = 2;
for j = 1:c
    g{j} = find(group == j);
end

while (i < c) && (norm(r(:,end))>err)
    l = abs(A'*r(:,i-1));
    for j = 1:c
        lg(j) = mean(abs(l(g{j})));
    end
    [B, IX] = sort(lg, 'descend');
    J = IX(1:n);
    Jvals = B(1:n);
    
    w=1;
    best = -1;
    J0 = zeros(1);
    while w <= n
       first = Jvals(w);
       firstw = w;
       energy = 0;
       while ( w <= n ) && ( Jvals(w) >= 1/2 * first )
           energy = energy + Jvals(w)^2;
           w = w+1;
       end
       if energy > best
           best = energy;
           J0 = J(firstw:w-1);
       end
    end

    for k = 1:length(J0)
        L = [L' g{J0(k)}']';
    end

    Psi = A(:,L);
    x = Psi\y;
    r(:,i) = y - Psi*x;
    i = i+1;
end

s(L) = x;
residual = r(:,end);