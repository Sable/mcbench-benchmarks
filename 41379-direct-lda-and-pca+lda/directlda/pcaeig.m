% most of the time. they both this and pcasvd takes about the same time
% when smallest = 0, this should be faster but it's not always
% when it's 1, due to null(U1'), it prob slows it down but not always
function [U,d] = pcaeig(X,n,smallest)
% X : nt x n, where nt examples of feature vecs of size n
% n returns n dimensions
% smallest = 1 when we want the n evecs assoc with the smallest
% evals
% U is evecs, d is diagonals
% Copyright (c) 2013, Vipin Vijayan.
if size(X,1) < size(X,2)
    [U,D] = eig(X*X');
    d = diag(D);
    [~,ix] = sort(d,'descend');
    U = U(:,ix);
    d = d(ix);
else
    [V,D1] = eig(X'*X);
    d1 = diag(D1);
    [~,ix] = sort(d1,'descend');
    V = V(:,ix);
    d1 = d1(ix);
    U1 = X*V; % go from evecs of X'*X to evecs of X*X'
    for ni = 1:size(U1,2), U1(:,ni) = U1(:,ni)./norm(U1(:,ni)); end
    if ~smallest
        U = U1;
        d = d1;
    else
        U2 = null(U1'); % this runs svd on U1'
        U = [U1 U2];
        d = [d1 ; zeros(size(U2,2),1)];
    end
end
if ~smallest,
    tol = eps(class(X));
    n = min(n, sum(d > tol));
    U = U(:,1:n);
    d = d(1:n);
else
    n = min(n,size(U,2));
    U = U(:,end:-1:end-n+1);
    d = max(0,d);
    d = d(end:-1:end-n+1);
end
% D = diag(d);
end


% very slow with large dimensions
function [U,d] = pcaeigslow(X,n,smallest)
[U,D] = eig(X*X');
d = diag(D);
[~,ix] = sort(d,'descend');
U = U(:,ix);
d = d(ix);
if ~smallest,
    tol = eps(class(X));
    n = min(n, sum(diag(D) > tol));
    U = U(:,1:n);
    d = d(1:n);
else
    n = min(n,size(U,2));
    U = U(:,end:-1:end-n+1);
    d = abs(diag(D));
    d = d(end:-1:end-n+1);
end
% D = diag(d);
end

