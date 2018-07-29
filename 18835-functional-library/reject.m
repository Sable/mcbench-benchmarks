
function varargout = reject(array, func)
% REJECTED = REJECT(ARRAY, FUNC)
%   Take the given matrix ARRAY, and iterate over it.  For each element i,
%   if FUNC(i) is true, then *DO NOT* add i to the result vector FILTERED.
%   This is the opposite of select - we are choosing which elements to
%   reject from the matrix ARRAY.
%
% [REJECTED, PASSED] = REJECT(ARRAY, PRED)
%   As above, but return the elements that do not pass PRED in PASSED.
%

  [varargout{1:(max(nargout,1))}] = select(array, negate(func));
end
