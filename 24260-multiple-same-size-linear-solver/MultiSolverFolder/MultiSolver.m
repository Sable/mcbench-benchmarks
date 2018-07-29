function X = MultiSolver(M, RHS)
% function X = MultiSolver(M, RHS)
%
% PURPOSE: Multiple linear (least-square) solver (usually small) for
%          systems having the same size
%
% INPUT
%   M  : 3D array (m x n x p)
%   RHS: 3D array (m x p x q)
% OUTPUT
%   X  : 3D array (n x p x q) if p>1,
%      : 2D array (n x q) if p==1 (squeezed, and equal to standard
%        backslash M\RHS)
%
% Solve p systems of linear equations:
%   M(:,:,k) * squeeze(X(:,k,:)) = squeeze(RHS(:,k,:)) for all k=1,2,...,p
%
% NOTE 1 -- This function is likely used with q == 1: single RHS for each
%           system). In this case
%       M  : 3D array (m x n x p)
%       RHS: 2D array (m x p)
%       X  : 2D array (n x p)
%       M(:,:,k) * X(:,k) = RHS(:,k) for all k=1,2,...,p
%
% NOTE 2 -- Special call with squeezed RHS: common RHS for all systems.
%   Input argument RHS can be squeezed as (m x q), or leave as 3D with
%   singleton in the second dimension: (m x 1 x q).
%       M   is 3D array (m x n x p)
%       RHS is 2D array (m x q) or (m x 1 x q)
%       X   is 2D array (n x p x q)
%       M(:,:,k) * squeeze(X(:,k,:)) = squeeze(RHS) for all k=1,2,...,p
%
% NOTE  3 -- Underdetermined system (more unknowns than equation)
%   The solution is basic solution obtained with sparse mldivide
%   which is not the same as basic solution when calling for full matrix.
%
% See also: SliceMultiSolver, MultiProd
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History: original 26-May-2009
%          11-Auguts-2009, add help
% Acknowlegement: Tim Davis for the tip of using sparse to speedup
%                 from FOR loop method

if ndims(M)>3 || ndims(RHS)>3
    error('MultiSolver: M or RHS cannot have more than 3 dimensions');
end

[m n p] = size(M);

if size(RHS,1)~=m
    error('MultiSolver: M and RHS dimensions are not compatible');
end

if (size(RHS,2)~=p)
    if ndims(RHS)==2 % (m x q)
        RHS = reshape(RHS, m, 1, []);
    elseif size(RHS,2)~=1
        error('MultiSolver: M and RHS dimensions are not compatible');
    end
    % common RHS, expanded for all systems
    RHS = repmat(RHS, [1 p 1]); % (m x p x q)
end

RHS = reshape(RHS, m*p, []); % (m*p) x q
q = size(RHS,2);

% Build sparse matrix and solve
I = repmat(reshape(1:m*p,m,1,p),[1 n 1]); % m x n x p
J = repmat(reshape(1:n*p,1,n,p),[m 1 1]); % m x n x p
A = sparse(I(:),J(:),M(:));
X = reshape(A \ RHS, [n p q]);

% Squeeze for single system
if p==1
    X = reshape(X, [n q]);
end

end % MultiSolver

