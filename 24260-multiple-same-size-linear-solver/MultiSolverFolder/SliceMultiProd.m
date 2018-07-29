function RHS = SliceMultiProd(M, X)
% function RHS = SliceMultiProd(M, X)
%
% PURPOSE: Multiple matrix product. This function performs the same
%          task as MULTIPROD but works on different shaping convention
%          for input/output matrices
%
% INPUT
%   M  : 3D array (m x n x p)
%   X  : 3D array (n x q x p)
% OUTPUT
%   RHS: 3D array (m x q x p)
%
% Compute p matrix products:
%   M(:,:,k) * X(:,:,k) = RHS(:,:,k) for all k=1,2,...,p
%
% NOTE -- Special call with X: common right matrix
%   Input argument X can be contracted as (n x q), and automatically
%   expanded by the function
%       M   is 3D array (m x n x p)
%       X   is 2D array (n x q)
%       RHS is 3D array (m x q x p)
%       M(:,:,k) * X = RHS(:,:,k) for all k=1,2,...,p
%
% See also: MultiProd, SliceMultiSolver
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History: original 11-August-2009

X = permute(X, [1 3 2]);
RHS = MultiProd(M, X);
if size(M,3)>1
    RHS = permute(RHS, [1 3 2]);
end

