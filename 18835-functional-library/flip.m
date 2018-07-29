
function func = flip(f, varargin)
% FUNC = FLIP(F)
% FUNC = FLIP(F, INDICES)
%   Take function F and rearrange the order of arguments being passed to F.
%   If INDICES is not given, then arguments are just reversed.  If INDICES
%   is given, then INDICES decides which arguments take what positions - so
%   that FLIP(F, 1, 2, 3) (or [1, 2, 3] or [1, 2], 3 - both work) will
%   result in the first three arguments being passed in order.  If we have
%   instead FLIP(F, 1, 5, 2) then F will be called with the first, fifth,
%   and second arguments respectively, and none else.
%
% FUNC = FLIP(F, PROCESSOR)
%   Use PROCESSOR (Which takes all the arguments being passed to FUNC) to
%   determine the index set for the arguments.  Should return something
%   that can be used directly to index arguments.  PROCESSOR should have
%   the form:
%     INDEX_SET = PROCESSOR(VARARGIN)
%

  function varargout = reverseArgs(varargin)
    arguments = varargin(end:-1:1);
    [varargout{1:nargout}] = f(arguments{:});
  end

  transform = [];
  if ~isempty(varargin)
    if islambda(varargin{1})
      transform = varargin{1};
      varargin(1) = [];
    end
  end

  indices = map(varargin, @(i) i(:));
  indices = cat(1, indices(:));
  indices = [indices{:}];

  function varargout = transformArgs(varargin)
    indices = transform(varargin{:});
    arguments = varargin(indices);
    [varargout{1:nargout}] = f(arguments{:});
  end
  
  function varargout = selectArgs(varargin)
    arguments = varargin(indices);
    [varargout{1:nargout}] = f(arguments{:});
  end

  if ~isempty(transform)
    func = @transformArgs;
  elseif isempty(indices)
    func = @reverseArgs;
  else
    func = @selectArgs;
  end
end
