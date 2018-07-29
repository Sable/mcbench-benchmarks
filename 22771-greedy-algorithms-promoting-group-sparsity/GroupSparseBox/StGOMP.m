function [s, residual] = StGOMP(A, y, group, steps, err)

% Stagewise Group Orthogonal Matching Pursuit - Combining Ideas from [1]
% and [2]

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% group = labels
% steps = sparsity of the underlying signal

% Output
% s = estimated sparse signal
% r = residual 

% Copyright (c) Angshul Majumdar 2009

% [1] Y. C. Eldar and H. Bolcskei, "Block Sparsity: Uncertainty  Relations 
% and Efficient Recovery," to appear in ICASSP 2009
% [2] D.L. Donoho, Y. Tsaig, I. Drori, J.-L. Starck, “Sparse solution of 
% underdetermined linear equations by stagewise orthogonal matching pursuit”
% preprint http://www-stat.stanford.edu/~idrori/StOMP.pdf

 if nargin < 5
     err = 1e-5;
 end
 if nargin < 4
     err = 1e-5;
     steps = 5;
 end

c = max(group);
s = zeros(size(A,2),1); t = 0.5;
r(:,1) = y; L = []; Psi = [];
i = 2;
for j = 1:c
    g{j} = find(group == j);
end

while (i < steps) && (norm(r(:,end))>err)
    l = sqrt(length(y)).*A'*r(:,i-1)./norm(r(:,i-1));
    thr = fdrthresh(l, t);
    l = find(abs(l)>thr);
    gr = unique(group(l));
      
    for k = 1:length(gr)
        L = [L' g{gr(k)}']';
    end
    Psi = A(:,L);
    x = Psi\y;
    r(:,i) = y - Psi*x;
    i = i+1;
end

s(L) = x;
residual = r(:,end);