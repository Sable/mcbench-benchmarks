function X = SliceMultiSolver(M, RHS)
% function X = SliceMultiSolver(M, RHS)
%
% PURPOSE: Multiple linear (least-square) solver (usually small) for
%          systems having the same size. This function performs the same
%          task as MULTISOLVER but works on different shaping convention
%          for input/output matrices
%
% INPUT
%   M  : 3D array (m x n x p)
%   RHS: 3D array (m x q x p)
% OUTPUT
%   X  : 3D array (n x q x p)
%
% Solve p systems of linear equations:
%   M(:,:,k) * X(:,:,k) = RHS(:,:,k) for all k=1,2,...,p
%
% NOTE 1 -- Special call with squeezed RHS: common RHS for all systems.
%   Input argument RHS can be squeezed as (m x q),
%       M   is 3D array (m x n x p)
%       RHS is 2D array (m x q)
%       X   is 2D array (n x q x p)
%       M(:,:,k) * X(:,:,k) = RHS for all k=1,2,...,p
%
% NOTE 2 -- Underdetermined system (more unknowns than equation)
%   The solution is basic solution obtained with sparse mldivide
%   which is not the same as basic solution when calling for full matrix.
%
% See also: MultiSolver, MultiProd
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History: original 11-August-2009

RHS = permute(RHS, [1 3 2]);
X = MultiSolver(M, RHS);
if size(M,3)>1
    X = permute(X, [1 3 2]);
end

