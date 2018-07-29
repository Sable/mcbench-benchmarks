function RHS = MultiProd(M, X)
% function RHS = MultiProd(M, X)
%
% PURPOSE: Multiple matrix product for systems having the same size
%
% INPUT
%   M  : 3D array (m x n x p)
%   X  : 3D array (n x p x q)
% OUTPUT
%   RHS: 3D array (m x p x q) if p>1,
%      : 2D array (m x q) if p==1 (squeezed, and equal to standard
%        matrix product M*X)
%
% Perform p matrix products:
%   M(:,:,k) * squeeze(X(:,k,:)) = squeeze(RHS(:,k,:)) for all k=1,2,...,p
%
% NOTE 1 -- Multi matrix-vector product is used with q == 1. In this case
%       M  : 3D array (m x n x p)
%       X  : 2D array (n x p)
%       RHS: 2D array (m x p)
%       M(:,:,k) * X(:,k) = RHS(:,k) for all k=1,2,...,p
%
% NOTE 2 -- Special call with squeezed X: common X for all systems.
%   Input argument X can be squeezed as (n x q), or leave as 3D with
%   singleton in the second dimension: (n x 1 x q).
%       M   is 3D array (m x n x p)
%       X   is 2D array (n x q) or (n x 1 x q)
%       RHS is 3D array (m x p x q)
%       M(:,:,k) * squeeze(X) = squeeze(RHS(:,k,:)) for all k=1,2,...,p
%
% See also: MultiSolver, SliceMultiProd
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History: original 16-July-2009
%          26-May-2010: change H1-line
% Acknowlegement: Tim Davis for the tip of using sparse to speedup
%                 from FOR loop method

if ndims(M)>3 || ndims(X)>3
    error('MultiProd: M or X cannot have more than 3 dimensions');
end

[m n p] = size(M);

if size(X,1)~=n
    error('MultiProd: M and X dimensions are not compatible');
end

if (size(X,2)~=p)
    if ndims(X)==2 % (n x q)
        X = reshape(X, n, 1, []);
    elseif size(X,2)~=1
        error('MultiProd: M and X dimensions are not compatible');
    end
    % common RHS, expanded for all systems
    X = repmat(X, [1 p 1]); % (n x p x q)
end

X = reshape(X, n*p, []); % (n*p) x q
q = size(X,2);

% Build sparse matrix and solve
I = repmat(reshape(1:m*p,m,1,p),[1 n 1]); % m x n x p
J = repmat(reshape(1:n*p,1,n,p),[m 1 1]); % m x n x p
A = sparse(I(:),J(:),M(:));
RHS = reshape(A * X, [m p q]);

% Squeeze for single system
if p==1
    RHS = reshape(RHS, [m q]);
end

end % MultiProd

