function [C, IDX] = kthcombn (V,N,K)
% KTHCOMBN - the K-th combination of elements
%   M = KTHCOMBN(V,N,K) returns the K-th combination(s) of N elements of
%   the elements in vector V. N is a positive scalar, and K is a vector of
%   one or more integers between 1 and numel(V)^N.
%   V can be a vector of numbers, characters, cells strings, or even
%   structures.
%
%   [M,IDX] = KTHCOMBN(V,N,K) also returns an index matrix, so that M = V(IDX).
%
%   Examples:
%     V = [7 31] , N = 3 , K = [7 4]
%     M = kthcombn(V, N, K)
%     % returns the 2-by-3 matrix:
%     % -> 31    31     7
%     %     7    31    31
%     % being the 7th and 4th combination (out of 9) of 3 elements of the V.
%
%     kthcombn('abcde',10, 5^9)
%     % -> aeeeeeeeee
%     
%     V = cellstr(['a':'z'].') ; N = 5 ; K = [1 10000000 11881376] ;
%     M = kthcombn(V,N,K)
%     % returns the first, 10 millionth, and the last combination
%     % -> 'a'    'a'    'a'    'a'    'a'
%     %    'v'    'w'    'y'    'x'    'j'
%     %    'z'    'z'    'z'    'z'    'z'
%
%   All elements in V are regarded as unique, so M = KTHCOMBN([2 2],3, K)
%   return [2 2] for all values of K.
%
%   This function does the same as 
%     M = COMBN(V,N)  
%     M = M(K,:)
%   but it does not need to create all combinations first, before
%   selecting, thereby avoiding some obvious memory issues with large values of N.
%   Beware of round-off errors for large values of N and K (see INTMAX).
%
%   For V = [0 1], KTHCOMBN returns a similar results as dec2bin(K-1,N)-'0'
%
%   See also NCHOOSEK, PERMS
%        and COMBN, ALLCOMB, NCHOOSE on the File Exchange

% version 1.1 (jan 2012)
% tested in R2011a, but should work on most releases
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (nov 2011) created after request by email. The algorithm is based on dec2base.
% 1.1 (jan 2012) fixed some textual errors in the help; checked that K is
%    larger than 0

% check the arguments
error(nargchk(3,3,nargin)) ;

if ~isnumeric(N) || numel(N) ~= 1 || N < 0 || N ~= fix(N)
    error('2nd argument N should be a positive integer.')
end
if ~isnumeric(K) || numel(K) < 1 || any(K < 1) || any(K ~= fix(K))
    error('3rd argument K should contain one or more positive integer(s).')
end

B = numel(V) ;
M = B ^ N ; % the maximum number of combinations
if any (K > M),
    error('Value(s) of K exceed the maximum number of combinations of N elements out of V (which is %d).',M) ;
end

K = K(:)-1 ; % start counting from 0

% find the decomposition of K, like a decimal value
%   abcd = a * 10^3 + b * 10^2 + c * 10^1 + d * 10^0
% in which (a,b,c,d) are values between 0 and 9
% but now using B instead of 10.
%   K(1) = IDX(1,1) * B^(N-1) + ... IDX(1,N) * B^0
% see, for instance, dec2base
IDX(:,N) = rem(K,B) ;
for j=N-1:-1:1,
    K = floor(K/B) ;
    IDX(:,j) = rem(K,B) ; 
end

IDX = IDX + 1 ; % add 1 again to start counting from 1 
C = V(IDX) ; % return the values

