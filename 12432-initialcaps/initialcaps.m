function y = initialcaps(A,varargin)
%INITIALCAPS  Convert string to "initial caps" format (initial capitals on all words).
%   B = INITIALCAPS(A) converts the initial letter of all words in A to capitals, where
%   A is a string.  Only initial letters are affected.
%
%   B = INITIALCAPS(A,idx) converts only the words in A indexed by vector 'idx' to 
%   "initial caps" format.  A "word" for these purposes is any string of letters 
%   separated by one or more non-letters, excluding apostrophes.  Thus, the phrase 
%   "don't talk to grown-ups" contains 5 words.
%
%   Examples:  A = 'life, don''t talk to me about life.'
%              y = initialcaps(A)
%                  y =
%                      Life, Don't Talk To Me About Life.
%
%              y = initialcaps(A,1)
%                  y =
%                      Life, don't talk to me about life.
%
%              y = initialcaps(A,[2 3])
%                  y =
%                      life, Don't Talk to me about life.
%
%              y = initialcaps(A,[2,5:7])
%                  y =
%                      life, Don't talk to Me About Life.
%
%   Acknowledgments: Thanks to Jerome from France for the vectorized code (vastly
%   nicer than my original clunker), and thanks to John D'Errico for the suggestion 
%   regarding inclusion of a second input argument. 
%
%   See also UPPER, LOWER, HEADLINE.

if isempty(A),
    y = A;
    return
end
Narg = nargin;
error(nargchk(1,2,Narg,'struct'))
if Narg==2,
    targetWordIx = varargin{1};
    if ~isvector(targetWordIx),
        error('Second argument must be an index vector.')
    end
end

A = [' ' A];
apostrophes = A=='''';
letters = isletter(A) | apostrophes;
nonLetters = ~letters ;

initialCapElements = [0 nonLetters] & [letters 0];

if Narg==2,
    numWords = nnz(initialCapElements);
    wordIx = find(initialCapElements);
    
    if (targetWordIx < 1) | (targetWordIx > numWords),
        error(['Index vector out of range.  Note: There are' ' ' num2str(numWords) ' words in the current input string.'])
    end

    wordIx = wordIx(targetWordIx);
    initialCapElements = false(size(initialCapElements));
    initialCapElements(wordIx) = 1;
end

A(initialCapElements) = upper(A(initialCapElements));
y = A(2:end);

