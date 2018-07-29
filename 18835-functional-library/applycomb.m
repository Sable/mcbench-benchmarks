
function applycomb(arrays, varargin)
% APPLYCOMB(INPUT_ARRAY, FUNC, OPTIONS)
%   Here, INPUT_ARRAY is a cell array of arrays.  Each i'th array in
%   INPUT_ARRAY will provide the i'th argument in function invocations.
%   Unlike APPLYMANY, every combination of arguments is used.  This is done
%   such that the first list is incremented through, then there is an
%   increment in the next, and so on - ie, the function enumerats through
%   a string of digits where each digit is a respective list element.
%   Example:
%     APPLYCOMB({[1, 2, 3], {2, 3}}, @someFunc)
%   Will call someFunc with (1, 2), (2, 2), (3, 2), (1, 3), (2, 3), (3, 3).
%   Thus, this allows one to use apply on high arity functions.
%
%     OPTIONS
%       'linear'
%         Arrange the output such that linear indexing of output will
%         enumerate through matrix elements as if they were the values
%         attained from incrementing a digit sequence.  So, if we have
%         the function someFunc, and INPUT_ARRAYS is {{1, 2}, {3, 4, 5}},
%         we would invoke someFunc with (1, 3), (1, 4), (1, 5), (2, 3),
%         (2, 4), (2, 5) -- ie `opposite' of what is normal.
%

  if ~iscell(arrays)
    error('ApplyComb:Arguments', 'Array input (first argument) must be a cell array.');
  end

  [funcs, args] = select(varargin, @islambda);
  if ~isscalar(funcs)
    error('ApplyComb:Arguments', 'One and only one function can be used in application.  Use composition for multiple functions.');
  end
  funcs = funcs{1};

  [linearOpts, args] = select(args, grep('^linear([- ]?ord(er(ing)?)?)?', 's'));
  linearOrder = ~isempty(linearOpts);
  
  sizes = map(arrays, @numel, 'double');
  num = prod(sizes);

  apply(1:num, generateCombFunc(arrays, funcs, linearOrder), args{:});
end

function f = generateCombFunc(arrays, func, linearOrder)
  function f = makeIdx(arr)
    if iscell(arr), f = @(idx) arr{idx}; else f = @(idx) arr(idx); end
  end

  indices = map(arrays, konst(1), 'double');
  idxs    = map(arrays, @makeIdx);
  num     = map(arrays, @numel, 'double');
  n       = numel(arrays);

  args = cell(1, n);
  function applyFunc(index)
    % Get the arguments.
    for i = 1:n
      f = idxs{i};
      args{i} = f(indices(i));
    end

    % Update the indices to the next combination.
    if linearOrder
      indices(end) = indices(end) + 1;
      i = n;
      while indices(i) > num(i)
        indices(i) = 1;
        i = i - 1;
        if i == 0, break; end
        indices(i) = indices(i) + 1;
      end
    else
      indices(1) = indices(1) + 1;
      i = 1;
      while indices(i) > num(i)
        indices(i) = 1;
        if i == n, break; end
        i = i + 1;
        indices(i) = indices(i) + 1;
      end
    end

    % Apply the function.
    func(args{:});
  end

  f = @applyFunc;
end
