
function f = indexAt(arrays)
% FUNC = INDEXAT(ARRAYS)
%   Take a cell of arrays, and return a function that can ordinally index
%   into that array.  IE, we return FUNC such that
%     FUNC(i, idx)
%   gets the i'th element of the idx'th array.
%

  function v = indexFunc(i, idx)
    arr = arrays{idx};
    if iscell(arr)
      v = arr{i};
    else
      v = arr(i);
    end
  end

  f = @indexFunc;
end
