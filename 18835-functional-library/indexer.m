
function result = indexer(func, index, increment, ord)
% IFUNC = INDEXER(FUNC, START, INC, ORD)
%   Returns a function IFUNC that, when called, invokes FUNC with its own
%   arguments, plus a `counter' argument that is updated with every
%   invocation.  Counting starts at START and is incremented by INC.  ORD
%   describes where to place the counting variable in the argument list.
%   If ORD non-positive, then it is appended to the end of the argument
%   list.  If ORD is greater than the number of arguments, then it is then
%   also appended to the end of the argument list.  Otherwise, it is made
%   to be the ORD'th argument.
%
%   Note that the return function can handle multiple input and multiple
%   outputs.
%

  if nargin < 1
    error('Indexer:Arguments', 'Indexer requires a function as an input.');
  end

  if nargin < 4, ord = -1; end
  if nargin < 3, increment = 1; end
  if nargin < 2, index = 1; end

  function varargout = indexfunc(varargin)
    if ord < 1 || ord > numel(varargin)
      input = {varargin{:}, index};
    else
      input = {varargin{1:ord-1}, index, varargin{ord:end}};
    end
    index = index + increment;
    if ~nargout
      func(input{:});
    else
      [varargout{1:nargout}] = func(input{:});
    end
  end

  result = @indexfunc;
end
