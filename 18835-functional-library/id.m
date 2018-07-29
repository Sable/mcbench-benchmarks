
function varargout = id(varargin)
% OUTPUT = ID(INPUT)
% [OUTPUT, ...] = ID(INPUT, ...)
%   Identity function.  Output is same as input.
%
  [varargout{1:max(nargout, 1)}] = deal(varargin{:});
end
