function W = nchoose(S)
% NCHOOSE - all combinations of the elements of a set
%   W = nchoose(S) returns all possible combinations of one or more
%   elements of the set S. In total there are 2^N-1 combinations, where N
%   is the number of elements in S. W is a cell array: each cell holds one
%   of these combination (as a row vector). S can be a cell array, and each
%   cell of W will then contain a cell array.  
%
%   Example:
%      nchoose([2 4 6 8])
%        % -> { [2] ; 
%        %      [4] ; 
%        %      [2 4] ; 
%        %      [6] ;
%        %      ...
%        %      [2 6 8] ;
%        %      [4 6 8] ;
%        %      [2 4 6 8]} ; % in total (2^4)-1 = 15 different combinations
% 
%   Notes: 
%   - For sets containing more than 18 elements a warning is given, as this
%     can take some time. On my PC, a set of 20 elements took 20 seconds.
%     Hit Ctrl-C to intterupt calculations.
%   - If S contain non-unique elements (e.g. S = [1 1 2]), NCHOOSE will
%     return non-unique cells. In other words, NCHOOSE treats all elements
%     of S as being unique. One could use NCHOOSE(UNIQUE(S)) to avoid that.
%   - Loosely speaking, NCHOOSE(S) collects all output of multiple calls to
%     NCHOOSEK(S,K) where K is looping from 1 to the number of elements of
%     S. The implementation of NCHOOSE, however, does rely of a different
%     method and is much faster than such a loop.
%   - By adding an empty cell to the output, the power set of a cell array
%     is formed:
%       S = {1 ; 'hello' ; { 1 2 3}}
%       PowerS = nchoose(S) 
%       PowerS(end+1) = {[]}
%     See: http://en.wikipedia.org/wiki/Power_set
%   
%   See also NCHOOSEK, PERMS
%            COMBN, ALLCOMB on the File Exchange

% for Matlab R13 and up
% version 2.1 (may 2010)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0, may 2008 - inspired by a post on CSSM
% 2.0, may 2008 - improvemed algorithm
% 2.1, mar 2010 - added a note on "power set", updated ML version

% Acknowledgements:
% 2.0: Urs Schwarz, for suggesting a significant speed improvement using bitget


N = numel(S) ; 

% How many unique combinations of 1 to N elements are there
M = (2^N)-1 ;
if N > 18,
    warning('Nchoose:LargeOutput', ...
        'There are %d unique combinations. Please be patient ...',M) ;
end

S = S(:).' ;   % make the set a row vector, for uniform output

% The selection of elements is based on the binary representation of all
% numbers between 1 and M. The binary representation of numbers stored in X
% can be calculated using the formula (see DEC2BIN):
%    B1 = rem(floor(X(:) * pow2(1-N:0)),2) 
% (* means matrix multiplication) in which row B(k,:) represents X(k)
% Based on the suggestion by US, this formula can be rewritten as:
%    B2 = bitget(X2 * (2.^(N-1:-1:0)),N) > 0
% for a specific number X2. Although the bits of B2 are in reversed order
% (compared to B1), this is, however, exactly what we want, as we can now
% select the elements of S directly. We do not need to flip the order
% afterwards. 

% Looping over the numbers is faster than creating a whole matrix at once
W = cell(M,1) ;    % Pre-allocation of output
p2=2.^(N-1:-1:0) ; % This part of the formula can be taken out of the loop

for i=1:M,
    % calculate the (reversed) binary representation of i
    % select the elements of the set based on this representation
    W{i} = S(bitget(i*p2,N) > 0) ; 
end


% Two other options, which are less efficient
% % 1) looping over nchoosek (slow)
% for i=N:-1:1,
%     W{i} = nchoosek(S,i) ;
% end
% % and now W still has to be split into distinct cells ...
% 
% % 2) in one big step (memory inefficient)
% Q = rem(floor([1:M].'*pow2(1-N:0)),2).' ;
% [R,C] = find(Q) ;
% W = mat2cell(S(R),1,sum(Q)).' ;