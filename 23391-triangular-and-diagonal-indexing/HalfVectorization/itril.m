function [I J] = itril(sz, k)
% function [I J] = itril(sz, k) % OR
% I = itril(sz, k)
%
% Return the subindices [I J] (or linear indices I if single output call)
% in the purpose of extracting an lower triangular part of the matrix of
% the size SZ. Input k is optional shifting. For k=0, extract from the main
% diagonal. For k>0 -> above the diagonal, k<0 -> below the diagonal
% 
% This returnd same as [...] = find(tril(ones(sz),k))
% - Output is a column and sorted with respect to linear indice
% - No intermediate matrix is generated, that could be useful for large
%   size problem
% - Mathematically, A(itril(size(A)) is called (lower) "half-vectorization"
%   of A 
%
% Example:
%
% A = [ 7     5     4
%       4     2     3
%       9     1     9
%       3     5     7 ]
%
% I = itril(size(A))  % gives [1 2 3 4 6 7 8 11 12]'
% A(I)                % gives [7 4 9 3 2 1 5  9  7]' OR A(tril(A)>0)
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

nc = min(n,m+k); % number of columns of the triangular part
lo = max((1:nc).'-k,1); % lower row indice for each column
hi = m + zeros(nc,1); % upper row indice for each column

if isempty(lo)
    I = zeros(0,1);
    J = zeros(0,1);
else
    c=cumsum([0; hi-lo]+1); % cumsum of the length
    I = accumarray(c(1:end-1), (lo-[0; hi(1:end-1)]-1), ...
                   [c(end)-1 1]);
    I = cumsum(I+1); % row indice
    J = cumsum(accumarray(c,1));
    J = J(1:end-1); % column indice
end

if nargout<2
    % convert to linear indices
    I = sub2ind([m n], I, J);
end

end % itril

