function M = EliminationM(n, varargin)
% function M = EliminationM(n)
% M = EliminationM(n, 'lo') % (default) OR
% M = EliminationM(n, 'up') % Matrix to extract upper part
% M = EliminationM(..., k) % 
% Return elimination matrix order n
%
% Input k is optional shifting. For k=0, extract from the main
% diagonal. For k>0 -> above the diagonal, k<0 -> below the diagonal
%
% Ouput are sparse
%
% EliminationM(size(A),'lo')*A(:) == A(itril(size(A))) % <- all true
% EliminationM(size(A),'up')*A(:) == A(itriu(size(A))) % <- all true
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 21/March/2009
%
% Ref : Magnus, Jan R.; Neudecker, Heinz (1980), "The elimination matrix:
% some lemmas and applications", Society for Industrial and Applied Mathematics.
% Journal on Algebraic and Discrete Methods 1 (4): 422–449,  
% doi:10.1137/0601049, ISSN 0196-5212.

option = 'lo';  % lower by default
k = 0; % Main diagonal by default

% Parse optional inputs
% We allow only two options {'lo', 'up'} and k
for narg=1:length(varargin)
    if ischar(varargin{narg}) % {'lo', 'up'}
        option = varargin{narg};
    elseif isnumeric(varargin{narg}) % k
        k = varargin{narg};
    end
end

if isscalar(n)
    n = [n n];
end

switch lower(option(1))
    case 'l' % u, lo, LO, LOWER ...
        I = itril(n,k);
    case 'u' % u, up, UP, UPPER ...
        I = itriu(n,k);
    otherwise
        error('option must be ''lo'' or ''up''');       
end

% Result
M = sparse((1:length(I)).', I, 1, length(I), prod(n));

end
