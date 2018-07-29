
function varargout = select(array, func)
% PASSED = SELECT(ARRAY, PRED)
%   Take the given matrix ARRAY, and iterate over it.  For each element i,
%   if PRED(i) is true, then add i to the result vector PASSED.
%
% [PASSED, REJECTED] = SELECT(ARRAY, PRED)
%   As above, but return the elements that do not pass PRED in REJECTED.
%

  idx = isTrue(array, func);
  varargout{1} = array(idx);
  if nargout > 1, varargout{2} = array(~idx); end
end
