function [ A,T ] = directlda(X,y,k,method,m)
%DIRECTLDA
% Hua Yu and Jie Yang "A direct LDA algorithm for high-dimensional data -
% with application to face recognition"
% Read it. It's short.
%
% X : nt x n where nt examples of feature vectors of size n
% y : vector of size nt of class labels
% eg:
%  X = [2 3 4 2; 8 2 3 4; 3 9 2 3; 8 4 2 3; 9 9 2 8];
%  y = [3; 2; 4; 3; 2];
% k : the number of features we want finally
%
% method : either pcalda or directlda
% if method = directlda then we are maximizing |A'*Sb*A|/|A'*Sw*A| except
%   that the null space of Sw, which apparently has the most discriminating 
%   information, is not thrown away
% if method = pcalda then we are maximizing |A'*St*A|/|A'*Sw*A|
%
% m :
%  if method = directlda then m = the no. dims. we want from the Sb scatter matrix
%  if method = pcalda then m = the no. of dims. we want from the pca part
%  if method = pcalda and m = inf, then this is just regular lda
%
% A : the projection A which maximizes between class / within class scatter
% T : transformation that spheres the data, for classification/comparison

% Copyright (c) 2013, Vipin Vijayan.
    
if nargin < 3, k = inf; end;
if nargin < 4, method = 'directlda'; end
if nargin < 5, m = inf; end;

y = y(:);
assert(size(X,1)==size(y,1),'X,y corresp');

% nt examples, feature vectors of size n
[nt n] = size(X);

% group according to classes
uy = unique(y);
[ns,bins] = histc(y,uy);
J = length(ns);
% ng = size(ns,1);
% class means
mu = zeros(J,n);
for i = 1:J, mu(i,:) = mean(X(i==bins,:),1); end
mubar = mean(X,1);
% between class scatter. construct Phi_b, Sb = Pb*Pb'
if ~strcmp(method,'pcalda')
    % Pb = (repmat(sqrt(ns),1,n) .* (mu-repmat(mubar,J,1)))';
    Pb = bsxfun(@times,sqrt(ns),bsxfun(@minus,mu,mubar))'; % same as above
else
    Pb = (X - repmat(mean(X,1),nt,1))'; % PCA+LDA Stotal = Pb*Pb'
end
% within class scatter. construct Phi_w, Sw = Pw*Pw'
Pw = (X - mu(bins(1:nt),:))';
[Y,db] = pcasvd(Pb,m,0);
Z = Y*diag(1./sqrt(db)); % Z=Y*Db"^"(-1/2)
[U,dw] = pcasvd(Z'*Pw,k,1); % (Pw*Z)'
% calculate A
A =  (Z*U)'; % A = U'*Z'; Dw = A*Sw*A'; I = A*Sb*A'
% transformation to sphere the data
if nargout > 1,
    T = diag(1./sqrt(dw)) * A; % T=Dw"^"(-1/2) * A
end
end


