
function b = isall(list, func)
% BOOL = ISALL(ARRAY)
% BOOL = ISALL(ARRAY, FUNC)
%   Without FUNC, ISALL returns true if every element of ARRAY is logically
%   true.  With FUNC, every element first has FUNC applied to it, and this
%   result is used instead - thus if every application of FUNC across ARRAY
%   is true, then ISALL(ARRAY, FUNC) is true.
%

  if nargin < 2, func = @(x) x; end
  % We don't use foldl so as to incur better performance via short circuit.
  b = 1;
  if iscell(list)
    for i = 1:numel(list)
      if ~func(list{i})
        b = 0;
        return;
      end
    end
  else
    for i = 1:numel(list)
      if ~func(list(i))
        b = 0;
        return;
      end
    end
  end
end
