
function v = indexInto(arr, idx)
% VAL = INDEXBY(ARRAY, INDEX)
%   Get the INDEX'th of ARRAY regardless of if it is a cell or not.
%

  if iscell(arr)
    v = arr{idx};
  else
    v = arr(idx);
  end
end
