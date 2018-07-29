
function [M,IND] = combnsub(V,N, IX)
% COMBNSUB - subset of all combinations of elements
%   M = COMBNSUB(V,N,IX) returns a subset of all combinations of N elements
%   of the elements in vector V. M has the size numel(IX)-by-N.
%
%   The output is the same as the sequence M=COMBN(V,N), M=M(IX,:) but this
%   function avoids generating all possible combinations first. The total
%   number of possible combinations increases exponentially
%   (=numel(V)^N). COMBNSUB is particulary useful when you only need one,
%   or a small subset of these combinations at a given time. 
%
%   Example:
%     V = 1:5, N = 3, IX = [2 124 21 99]
%     M = combnsub(V, N, IX) % returns the 4-by-3 matrix:
%     %  1  1  2
%     %  5  5  4
%     %  1  5  1
%     %  4  5  4
%     % which are the 2nd, 124th, 21st and 99th combinations
%     % Check with COMBN
%     M2 = combn(V,N) ; isequal(M2(IX,:),M)
%     % M2 is a 125-by-3 matrix
%
%   [M,I] = COMBN(V,N,IX) also returns the index matrix I so that M = V(I).
%
%   V can be an array of numbers, cells or strings. All elements in V are
%   regarded as unique. Values of IX that exceed the total number of
%   possible combinations (numel(V)^N) are saturated to that value.
%
%   For empty vectors V, or for N = 0, an empty matrix will be returned.
%
%   See also PERMS, NCHOOSEK
%        and COMBN, ALLCOMB, PERMPOS, PERMPOSNEXT on the File Exchange

% tested in Matlab R13, R14, 2010b
% version 1.0 (apr 2013)
% (c) Jos van der Geest
% email: jos@jasen.nl
%
% History:
% 1.0 (april 2013) - created after question asked by Mohsen
% 1.1 (june 2013) - minor simplication per suggestion of Jan Simon
%         - in v1.0, when V was a column vector, and numel(IX) was 1, the
%         output was also a column vector. Now the output is always a row
%         vector, by making the input V as a row factor

error(nargchk(3,3,nargin)) ;

if isempty(V) || N == 0
    M = [] ;
    IND = [] ;
    return
elseif fix(N) ~= N || N < 1 || numel(N) ~= 1 
    error('combnsub:negativeN','Second argument should be a positive integer') ;
elseif numel(IX) < 1 || any(IX<1) || any(IX ~= fix(IX))
    error('combnsub:invalidIX','Third argument should contain positive integers.') ;
end

V = reshape(V,1,[]) ; % v1.1 make input a row vector
nV = numel(V) ; 
Npos = nV^N ;
if any(IX > Npos)
    warning('combnsub:IndexOverflow', ...
        'Values of IX exceeding the total number of combinations are saturated.')
    IX = min(IX, Npos) ;
end

% The engine is based on version 3.2 of COMBN  with the correction
% suggested by Roger Stafford . This approaches uses a single matrix
% multiplication 
B = nV.^(1-N:0) ;
IND = ((IX(:)-.5) * B) ; % matrix multiplication
IND = rem(floor(IND),nV) + 1 ;
M = V(IND) ; 