
function func = ftest(pred, t, f)
% FUNC = FCOND(PREDICATE, TRUE_FUNC, FALSE_FUNC)
%   Make a function FUNC that takes any number of ARGS and invokes
%   TRUE_FUNC(ARGS) if PREDICATE(ARGS), otherwise invokes FALSE_FUNC(ARGS).
%

  function varargout = ftestFunc(varargin)
    if pred(varargin{:})
      [varargout{1:nargout}] = t(varargin{:});
    else
      [varargout{1:nargout}] = f(varargin{:});
    end
  end
  func = @ftestFunc;
end
