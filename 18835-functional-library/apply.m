
function apply(array, func)
% APPLY(ARRAY, FUNC)
%   Apply FUNC to every element of ARRAY.
%
%   Example:
%     apply(1:10, @disp) % Display every element of the array.
%

  if iscell(array)
    for i = 1:numel(array)
      func(array{i});
    end
  else
    for i = 1:numel(array)
      func(array(i));
    end
  end
end
