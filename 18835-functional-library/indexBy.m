
function v = indexBy(idx, arr)
% VAL = INDEXBY(INDEX, ARRAY)
%   Get the INDEX'th of ARRAY regardless of if it is a cell or not.
%

  if iscell(arr)
    v = arr{idx};
  else
    v = arr(idx);
  end
end
