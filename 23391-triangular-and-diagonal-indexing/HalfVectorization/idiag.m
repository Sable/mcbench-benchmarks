function [I J] = idiag(sz, k)
% function [I J] = idiag(sz, k) % OR
% I = itril(sz, k)
%
% Return the subindices [I J] (or linear indices I if single output call)
% in the purpose of extracting the diagonal of the matrix of the size SZ.
% Input k is optional shifting. For k=0, extract from the main
% diagonal. For k>0 -> above the diagonal, k<0 -> below the diagonal
%
% Output is a column and sorted with respect to linear indice
%
% Example:
%
% A = [ 7     5     4
%       4     2     3
%       9     1     9
%       3     5     7 ]
%
% I = idiag(size(A))  % gives [1 6 11]'
% A(I)                % gives [7 2 9]' OR diag(A)
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 21/March/2009

if isscalar(sz)
    sz = [sz sz];
end
m=sz(1);
n=sz(2);

% Main diagonal by default
if nargin<2
    k=0;
end

% Pay attention to the clipping
I = (1-min(k,0):min(m,n-k)).';
J = I+k;

if nargout<2
    % convert to linear indices
    I = sub2ind([m n], I, J);
end

end % idiag

