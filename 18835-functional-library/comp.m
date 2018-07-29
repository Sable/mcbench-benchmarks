
function f = comp(varargin)
% FUNC = COMP(FUNCTIONS+)
%   Form the composition of FUNCTIONS, resulting in FUNC.
%

  functions = varargin;
  function varargout = func(varargin)
    in = varargin;
    for i = 1:numel(functions)
      func = functions{i};
      if iscell(func)
        [func, nout] = deal(func{:});
      else
        nout = max(nargout(func), 1);
      end
      out = cell(1, nout);
      [out{:}] = func(in{:});
      in = out;
    end

    [varargout{1:max(nargout, 1)}] = deal(in{:});
  end

  f = @func;
end
