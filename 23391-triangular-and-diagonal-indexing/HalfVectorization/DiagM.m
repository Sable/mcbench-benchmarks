function M = DiagM(n)
% function M = DiagM(n)
% M = TraceM(n, 'lo')  
% Return "Diagonal-matrix", when applied on vectorized matrix (of order n)
% It gives the diagonal:
%
% Ouput are sparse
%
% DiagM(size(A))*A(:) == diag(A); % <- all true
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 21/March/2009

if isscalar(n)
    n = [n n];
end
I = idiag(n,0);

% Result
M = sparse((1:length(I)).', I, 1, length(I), prod(n));

end
