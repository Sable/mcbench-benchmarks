
function func = fcond(c, varargin)
% FUNC = FCOND(COND-FUNC, FUNCTION_1, ...)
%   Make a function FUNC that takes any number of ARGS, and invokes
%   FUNCTO_n with them, where n = COND-FUNC(ARGS).
%

  functions = varargin;
  function varargout = fcondFunc(varargin)
    idx = c(varargin{:});
    f = functions{idx};
    [varargout{1:nargout}] = f(varargin{:});
  end

  func = @fcondFunc;
end
