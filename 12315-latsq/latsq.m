function [M,R] = latsq(N)
% LATSQ - (randomized) Latin Square
%    M = LATSQ(N) creates a latin square of size N-by-N containing
%    the numbers 1 to N. N should be a positive integer. M is also known as
%    the (backward shifted) circulant matrix of the vector 1:N.
%
%    [M, R] = LATSQ(N) also returns a randomized latin square in R.
%
%    A latin square of size N is a N-by-N matrix filled with N different
%    numbers in such a way that each number occurs exactly once in each row
%    and exactly once in each column. They have applications in the design
%    of experiments. 
%    More information: http://en.wikipedia.org/wiki/Latin_square
%
%    Example:
%    [M,R] = latsq(4) % ->
%      % M is unrandomized
%      %    1  2  3  4
%      %    2  3  4  1
%      %    3  4  1  2
%      %    4  1  2  3
%      % R is randomized
%      %    2  3  1  4
%      %    3  4  2  1
%      %    4  1  3  2
%      %    1  2  4  3
%
%    Note that "sort(ballatsq(N),1/2)" will return 1:N in each column/row.
%
%    See also MAGIC, GALLERY, 
%             BALLATSQ, CIRCULANT, SLM (File Exchange)

% for Matlab R13
% version 1.4 (feb 2009)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (apr 2006) created
% 1.1 (sep 2006) revised for the File Exchange
% 1.2 (sep 2006) fixed minor spelling errors
% 1.3 (sep 2006) fixed small error in randomization
% 1.4 (feb 2009) mention circulant matrices

if nargin ~= 1 || ~isnumeric(N) || numel(N)~=1 || N<1 || fix(N)~=N,
    error('Single argument should be a positive integer') ;
end

% setup latin square
% similar to circulant(1:N,-1). See FEX ID 22876
M = [1:N ; ones(N-1,N)] ;
M = rem(cumsum(M)-1,N)+1 ;

% M is now a latin square.
if nargout==2,
    % We can randomize by permuting rows ...
    R = M(randperm(N),:) ;
    % ... and permuting columns
    R = R(:,randperm(N)) ;
end
