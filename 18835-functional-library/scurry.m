
function func = scurry(varargin)
% FUNC = SCURRY(FORMAT, ARGS+)
%   Return a curried sprintf function.  This uses SPRINTF(FORMAT, ARGS{:},
%   VARARGIN{:}) where VARARGIN are the variable number of arguments to the
%   returned curried function FUNC.
%
%   Note that if ARGS has the appropriate number of arguments, then FUNC()
%   returns the formatted string.
%

  if nargin == 0
    func = @scurry;
    return;
  end

  format = varargin{1};
  varargin(1) = []; %#ok<NASGU>
  args = varargin;

  if ~ischar(format)
    error('SCurry:Arguments', 'First argument must be a format string.');
  end

  i = 2;
  formatters = 0;
  while i <= numel(format)
    if format(i-1) == '%'
      if format(i) ~= '%'
        formatters = formatters + 1;
      end
      i = i + 1;
    end
    i = i + 1;
  end

  func = curry(formatters + 1, @sprintf, format, args{:});
end
