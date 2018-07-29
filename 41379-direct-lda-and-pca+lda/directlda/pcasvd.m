% this is sometimes faster than the transpose eigenvalue method with
% very large dimensions and small no. of examples
function [U,d] = pcasvd(X,n,smallest)
% X : nt x n, where nt examples of feature vecs of size n
% n returns n dimensions
% smallest is 1 when we want the evecs assoc with the smallest evals
% % U is evecs, d is diagonals
% Copyright (c) 2013, Vipin Vijayan.
if nargin < 3, smallest = 0; end;
[U,S] = svd(X,'econ');
s = diag(S);
if ~smallest,
    tol = max(size(X)) * max(s) * eps(class(X));
    n = min(n, sum(s > tol));
    U = U(:,1:n);
    s = s(1:n);
else
    n = min(n, size(U,2));
    U = U(:,end:-1:end-n+1);
    s = s(end:-1:end-n+1);
end
d = s.^2; % D = diag(s.^2);
end
