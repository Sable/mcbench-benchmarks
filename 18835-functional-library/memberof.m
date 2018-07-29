
function b = memberof(list, item, func)
% BOOL = MEMBEROF(ARRAY, ITEM)
% BOOL = MEMBEROF(ARRAY, ITEM, FUNC)
%   Returns true if ITEM is an element of ARRAY.  Equality is tested using
%   FUNC.  If FUNC isn't provided, it defaults to @(i, j) = (i == j).
%

  if isempty(item)
    b = 0;
    return;
  end

  if nargin < 3, func = @(i, j) (i == j); end
  if ~strcmp(class(func), 'function_handle')
    error('memberof requires the third argument to be a membership predicate.');
  end

  b = map(item, @(j) isany(list, @(i) func(i, j)), 'logical');
end
