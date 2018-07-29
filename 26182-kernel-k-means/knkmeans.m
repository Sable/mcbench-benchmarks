function [label, energy] = knkmeans(K,init)
% Perform kernel k-means clustering.
%   K: kernel matrix
%   init: k (1 x 1) or label (1 x n, 1<=label(i)<=k)
% Reference: [1] Kernel Methods for Pattern Analysis
% by John Shawe-Taylor, Nello Cristianini
% Written by Michael Chen (sth4nth@gmail.com).
n = size(K,1);
if length(init) == 1
    label = ceil(init*rand(1,n));
elseif size(init,1) == 1 && size(init,2) == n
    label = init;
else
    error('ERROR: init is not valid.');
end
last = 0;
while any(label ~= last)
    [u,~,label] = unique(label);   % remove empty clusters
    k = length(u);
    E = sparse(label,1:n,1,k,n,n);
    E = bsxfun(@times,E,1./sum(E,2));
    T = E*K;
    Z = repmat(diag(T*E'),1,n)-2*T;
    last = label;
    [val, label] = min(Z,[],1);
end
[~,~,label] = unique(label);   % remove empty clusters
energy = sum(val)+trace(K);