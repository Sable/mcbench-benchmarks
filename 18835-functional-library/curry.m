
function func = curry(varargin)
% FUNC = CURRY(N, F, ARGS)
% FUNC = CURRY(F, ARGS)
%   Return a curried function of F.  If N is given, then N arguments are
%   expected for F (otherwise, N is taken to be NARGIN(F)).  If N is
%   negative, then |N| or more arguments are accepted (but F is invoked as
%   soon as there are at least N arguments).  ARGS are counted in N.  If
%   less than N arguments are supplied in total, then a *new* curried
%   function involving all arguments so far is returned.
%
% FUNC = CURRY()
%   This actually just returns CURRY and is a sort of `base case' for
%   currying functions.
%
% FUNC = CURRY(N)
%   This returns a function that waits for F to invoke CURRY(N, F, ...).
%

  if nargin == 0
    func = @curry;
    return;
  end

  arg = varargin{1};
  varargin(1) = [];

  if isnumeric(arg)
    many = arg < 0;
    params = abs(arg);
    if isempty(varargin)
      callback = [];
    else
      callback = varargin{1};
      varargin(1) = [];
    end
  elseif islambda(arg)
    many = true;
    params = nargin(arg);
    callback = arg;
  else
    error('Curry:Arguments', 'First argument must be either number of arguments or a function.');
  end
  args = varargin;
  % If not many, then we also know params but not necessarily callback.
  if ~many
    func = genExactFunc(callback, params, args);
  else
    func = genManyFunc(callback, params, args);
  end
end

% We always return a function, as we don't know what the actual outputs
% call for until an invocation.
% We also don't know if callback is known yet.
function func = genExactFunc(callback, params, args)
  function varargout = invokeCallback(varargin)
    n = numel(varargin) + numel(args);
    if n < params
      varargout{1} = genExactFunc(callback, params, [args, varargin]);
    elseif n > params
      error('Curry:Invocation', 'Function was supposed to be called with exactly %d parameters, but has %d instead.', params, n);
    else
      varargout{1:nargout} = callback(args{:}, varargin{:});
    end
  end

  function target = invokeCurry(varargin)
    target = curry(params, varargin{:});
  end

  % If we don't know what the callback is yet, just wait and have curry
  % figure it out and reinvoke this function.
  if isempty(callback)
    func = @invokeCurry;
  else
    func = @invokeCallback;
  end
end

function func = genManyFunc(callback, params, args)
  function varargout = invokeCallback(varargin)
    n = numel(varargin) + numel(args);
    if n < params
      varargout{1} = genManyFunc(callback, params, [args, varargin]);
    else
      varargout{1:nargout} = callback(args{:}, varargin{:});
    end
  end

  func = @invokeCallback;
end
