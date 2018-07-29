
function b = isany(list, func)
% BOOL = ISANY(ARRAY)
% BOOL = ISANY(ARRAY, FUNC)
%   Without FUNC, ISANY returns true if any element of ARRAY is logically
%   true.  With FUNC, every element first has FUNC applied to it, and this
%   result is used instead - thus if any application of FUNC across ARRAY
%   is true, then ISANY(ARRAY, FUNC) is true.
%

  if nargin < 2, func = @(x) x; end
  % We don't use foldl so as to incur better performance via short circuit.
  b = 0;
  if iscell(list)
    for i = 1:numel(list)
      if func(list{i})
        b = 1;
        return;
      end
    end
  else
    for i = 1:numel(list)
      if func(list(i))
        b = 1;
        return;
      end
    end
  end
end
