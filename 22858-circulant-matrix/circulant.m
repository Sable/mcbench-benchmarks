function C = circulant(vec,direction)
%CIRCULANT Circulant Matrix.
%  CIRCULANT(V,DIR) generates a square circulant matrix using the vector V
%  as the first row of the result if V is a row vector or as the first
%  column of the result if V is a column vector. V may be any numeric data
%  type or a character string.
%  DIR is an optional input argument that describes the circular shift
%  direction. If DIR = 1, the shift is forward. If DIR = -1, the shift is
%  backward. If DIR is not provided, DIR = 1 is used.
%
%  References:
%    http://en.wikipedia.org/wiki/Circulant_matrix
%    http://mathworld.wolfram.com/CirculantMatrix.html
%
% Example:
%  A backwards (-1) shift, result is a symmetric
%  matrix.
%
%  circulant([2 3 5 7 11 13],-1)
%
%  ans =
%       2     3     5     7    11    13
%       3     5     7    11    13     2
%       5     7    11    13     2     3
%       7    11    13     2     3     5
%      11    13     2     3     5     7
%      13     2     3     5     7    11
%
% Example:
%  A forwards (+1) shifted circulant matrix,
%  built using the first row defined by vec.
%
%  circulant([2 3 5 7 11],1)
%
%  ans =
%       2     3     5     7    11
%      11     2     3     5     7
%       7    11     2     3     5
%       5     7    11     2     3
%       3     5     7    11     2
%
% Example:
%  A postively shifted circulant matrix, built
%  from vec as the first column.
%
%  circulant([2;3;5;7;11],1)
%  ans =
%       2    11     7     5     3
%       3     2    11     7     5
%       5     3     2    11     7
%       7     5     3     2    11
%      11     7     5     3     2
%
% Example:
%  A negative shift applied to build a character
%  circulant matrix.
%  
%  circulant('abcdefghij',-1)
%
%  ans =
%  abcdefghij
%  bcdefghija
%  cdefghijab
%  defghijabc
%  efghijabcd
%  fghijabcde
%  ghijabcdef
%  hijabcdefg
%  ijabcdefgh
%  jabcdefghi
%
%  See also: toeplitz, hankel
% 
%  Author: John D'Errico
%   (The help was re-written to be more clear
%    and concise by Duane Hanselman.)
%  e-mail: woodchips@rochester.rr.com
%  Release: 1.1
%  Release date: 2/3/09


% error checks
if (nargin<1) || (nargin > 2)
  error('circulant takes only one or two input arguments')
end

if (nargin < 2) || isempty(direction)
  direction = 1;
elseif ~ismember(direction,[1,-1])
  error('direction must be either +1 or -1 if it is supplied')
end

% verify that vec is a vector or a scalar
if ~isvector(vec)
  error('vec must be a vector')
elseif length(vec) == 1
  % vec was a scalar
  C = vec;
  return
end

% how long is vec?
n = length(vec);
n1 = n-1;

if direction == -1
  % negative circular shift.
  
  % create the circulant matrix. Yeah, I know,
  % it only takes one line using bsxfun. 
  %
  % Alternatively, it can be done as a hankel
  % matrix variant. I like the bsxfun construct
  % the best, and it is 40% faster than a call
  % to Hankel. Even my repmat version is faster
  % than the hankel solution.
  %
  %  C = vec(hankel(1:n,circshift(1:n,[0 1]))));
  %
  % For anyone who really wants a slight speed
  % bump, uncomment the bsxfun version below
  % instead, and comment out the repmat version
  % below. I considered putting in a test to see
  % if bsxfun exists, but the test itself wastes
  % more time on small vectors compared to the
  % small additional time the repmat version
  % requires.
  %
  %  C = vec(mod(bsxfun(@plus,(0:n1)',0:n1),n)+1);
  %
  % The fact is, there are still too many users
  % around that don't have a new enough release
  % that includes bsxfun. Since the repmat
  % solution here is absolutely trivial,
  % I'll be friendly and use it instead. I also
  % did a very quick test, and even for vectors
  % of length 500, there was only a 10% time
  % penalty for the use of repmat versus bsxfun
  % here.
  C = repmat(0:n1,n,1);
  C = vec(mod(C+C',n)+1);
else
  % positive circular shift. We end up as a
  % call to toeplitz here. This variant too can
  % be sped up using bsxfun. Here the speedup
  % is roughly 20% over toeplitz for vectors of
  % length 500. Again though, for small vectors,
  % the test just to see if bsxfun exists takes
  % more time than the call to toeplits.
  
  % if bsxfun exists and you really want that
  % speed bump, just swap in the following block
  % of code:
  
%  if size(vec,1) == 1
%    % vec was a row vector, so it defines
%    % the first row of C.
%    C = vec(mod(bsxfun(@plus,(0:-1:(-n1))',0:n1),n)+1);
%  else
%    % vec must be a column vector, so it
%    % defines the first column of C.
%    C = vec(mod(bsxfun(@plus,(0:n1)',0:-1:(-n1)),n)+1);
%  end
  
  % assuming no bsxfun
    
  % was vec a row or column vector?
  if size(vec,1) == 1
    % vec was a row vector, so it defines
    % the first row of C.
    rind = 1:n;
    cind =  n + 2 - rind' ;
    cind(cind == (n+1)) = 1;
  else
    % vec was a column vector, so it defines
    % the first column of C.
    cind = (1:n)';
    rind =  n + 2 - cind';
    rind(rind == (n+1)) = 1;
  end
  % once the first row and column is given,
  % just call toeplitz
  C = vec(toeplitz(cind,rind));
  
end

