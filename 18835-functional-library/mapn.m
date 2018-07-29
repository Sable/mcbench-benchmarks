
function varargout = mapn(array, start, varargin)
% [OUTPUT] = MAPN(ARRAY, START, FUNC, OPTIONS)
%   This is MAP(ARRAY, FUNC', OPTIONS) where FUNC' takes the ordinal
%   position of the array element we are mapping across instead of the
%   actual value.  Positions start counting at start.
%

  [funclist, varargin] = select(varargin, @islambda);

  if nargin < 2, start = 1; end
  if nargin == 0
    error('MapN:Arguments', 'Array argument to MapN is required.');
  end
  
  if isempty(funclist)
    varargout{1} = start:(numel(array) - 1 + start);
    return;
  end

  if numel(funclist) > 1
    error('MapN:Arguments', 'Too many functions to mapn.');
  end

  func = funclist{1};
  function varargout = mapNFunc(index, varargin)
    [varargout{1:(max([nargout, 1]))}] = func(index);
  end

  [varargout{1:(max([nargout, 1]))}] = map(array, indexer(@mapNFunc, start, 1, 1), varargin{:});
end
