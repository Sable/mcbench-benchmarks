function A = circulant(A,d)
% CIRCULANT - Circulant Matrix
%
%   C = CIRCULANT(A) or CIRCULANT(A,1) returns the circulant matrix C based
%   on the vector A. C is a square matrix in which each row (or column) is
%   a formed by circularly shifting the preceeding row (or column) forward
%   by one element. The first row (or column) is given by the row- (or 
%   column-)vector A. The last row (or column) will therefore be the input
%   in reversed order.
%
%   C = CIRCULANT(A,-1) applies a backward shift, returning a symmetric
%   matrix, so that C equals TRANSPOSE(C).
%
%   Examples:
%     circulant([2 3 5 7]) % forward shift
%       % ->   2     3     5     7
%       %      7     2     3     5
%       %      5     7     2     3
%       %      3     5     7     2
%
%     circulant([2 3 5 7], -1) % backward shift
%       % ->   2     3     5     7
%       %      3     5     7     2
%       %      5     7     2     3
%       %      7     2     3     5
%
%     circulant([2 3 5 7].') % column input
%       % ->   2     7     5     3
%       %      3     2     7     5
%       %      5     3     2     7
%       %      7     5     3     2
%
%     circulant([2 3 5 7].', -1) % column input, backward shift
%       %      2     3     5     7
%       %      3     5     7     2
%       %      5     7     2     3
%       %      7     2     3     5
%
%  The output has the same type as the input, and can e.g. be cell arrays:
%     circulant({'One','2','III'})
%       % ->      'One'    '2'      'III'
%       %         'III'    'One'    '2' 
%       %         '2'      'III'    'One' 
%
%   Notes:
%   - This version is completely based on indexing and does not use loops,
%     repmat, hankel, toeplitz or bsxfun. It should therefore run pretty
%     fast on most Matlab versions.
%   - See http://en.wikipedia.org/wiki/Circulant_matrix for more info on
%     circulant matrices.
%
%   See also TOEPLITZ, HANKEL
%            LATSQ, BALLATSQ (on the File Exchange)

% for Matlab R13 and up
% version 1.0 (feb 2009)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (feb 2009) - 
% 2.0 (feb 2009) - Important bug fix for row vectors with forward shift

% Acknowledgements:
% This file was inspired by two submissions on the File Exchange (#22814 &
% #22858). I modified some of the help from the submission by John D'Errico.

N = numel(A) ; 

if ndims(A) ~= 2 && length(A) ~= N,
    error('Input should be a vector') ;
end

if nargin==2,
    if ~(isequal(d,-1) || isequal(d,1))
        error(sprintf(['Second argument should either be 1 (forward\n  shift, ' ...
            'default) or -1 (backward shift).'])) ;
    end
else
    d = 1 ; 
end

% for an empty matrix or single element there is nothing to do.
if N > 1,       
    % Create a circulant index matrix using cumsum and rem:    
    idx = -d * ones(N) ;       % takes care of forward or backward shifts
    idx(:,1) = 1:N ;           % creating the shift ..
    idx = cumsum(idx,2) ;      % .. by applying cumsum
    idx = rem(idx+N-1, N)+1 ;  % all idx become positive by adding N first
    
    if d==1 & size(A,1)==1,    
        % needed for row vectors with forward shift (bug fixed in v2.0)
        idx = idx.' ;
    end
    
    A = A(idx) ;
end



