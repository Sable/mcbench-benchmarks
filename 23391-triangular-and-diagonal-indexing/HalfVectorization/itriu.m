function [I J] = itriu(sz, k)
% function [I J] = itriu(sz) % OR
% I = itriu(sz) OR
% 
% Return the subindices [I J] (or linear indices I if single output call)
% in the purpose of extracting an upper triangular part of the matrix of
% the size SZ. Input k is optional shifting. For k=0, extract from the main
% diagonal. For k>0 -> above the diagonal, k<0 -> below the diagonal
%
% This returnd same as [...] = find(triu(ones(sz),k))
% - Output is a column and sorted with respect to linear indice
% - No intermediate matrix is generated, that could be useful for large
%   size problem
% - Mathematically, A(itriu(size(A)) is called (upper) "half-vectorization"
%   of A 
%
% Example:
%
% A = [ 7     5     4
%       4     2     3
%       9     1     9
%       3     5     7 ]
%
% I = itriu(size(A))  % gives [1 5 6 9 10 11]'
% A(I)                % gives [7 5 2 4  3  9]' OR A(triu(A)>0)
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

nc = n-max(k,0); % number of columns of the triangular part
lo = ones(nc,1); % lower row indice for each column
hi = min((1:nc).'-min(k,0),m); % upper row indice for each column

if isempty(lo)
    I = zeros(0,1);
    J = zeros(0,1);
else
    c=cumsum([0; hi-lo]+1); % cumsum of the length
    I = accumarray(c(1:end-1), (lo-[0; hi(1:end-1)]-1), ...
                   [c(end)-1 1]);
    I = cumsum(I+1); % row indice
    J = accumarray(c,1);
    J(1) = 1 + max(k,0); % The row indices starts from this value
    J = cumsum(J(1:end-1)); % column indice
end

if nargout<2
    % convert to linear indices
    I = sub2ind([m n], I, J);
end

end % itriu

