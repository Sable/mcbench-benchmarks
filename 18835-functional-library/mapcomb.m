
function varargout = mapcomb(arrays, varargin)
% [OUTPUT1, .., OUTPUTN] = MAPCOMB(INPUT_ARRAY, FUNC, OPTION, ...)
%   Here, INPUT_ARRAY is a cell array of arrays.  Each i'th array in
%   INPUT_ARRAY will provide the i'th argument in function invocations.
%   Unlike MAPMANY, every combination of arguments is used.  This is done
%   such that the first list is incremented through, then there is an
%   increment in the next, and so on - ie, the function enumerates through
%   a string of digits where each digit is a respective list element.
%   Example:
%     MAPCOMB({[1, 2, 3], {2, 3}}, @someFunc)
%   Will call someFunc with (1, 2), (2, 2), (3, 2), (1, 3), (2, 3), (3, 3).
%   Thus, this allows one to apply map to high arity functions.  OPTION
%   are the normal MAP arguments, with those below added.  OUTPUTS are also
%   the same.  MAP(ARRAY, ...) and MAPCOMB({ARRAY}, ...) are equivalent.
%   See MAP for more information.
%
%   The outputs are shaped in a M1 x M2 x ... x Mn array, where each Mi is
%   the size of the i'th element of INPUT_ARRAY.  Given this and the
%   ordering that the elements are taken in, for each OUTPUTi, the value
%     OUTPUTi(IDX1, ... , IDXn)
%   will be the value calculated using the appropriate values from each
%   element of INPUT_ARRAY (ie, the IDX1'th element of the first array,
%   and so on).
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
%       All the normal OPTIONS to map are available.
%

  if ~iscell(arrays)
    error('MapComb:Arguments', 'Array input (first argument) must be a cell array.');
  end

  [funcs, args] = select(varargin, @islambda);
  if ~isscalar(funcs)
    error('MapComb:Arguments', 'One and only one function can be used in mapping.  Use composition for multiple functions.');
  end
  funcs = funcs{1};

  [linearOpts, args] = select(args, grep('^linear([- ]?ord(er(ing)?)?)?', 's'));
  linearOrder = ~isempty(linearOpts);
  
  sizes = map(arrays, @numel, 'double');
  num = prod(sizes);

  nOut   = max(nargout, 1);
  output = cell(1, nOut);
  [output{1:nOut}] = map(1:num, generateCombFunc(arrays, funcs, linearOrder), args{:});
  for i = 1:nOut
    varargout{i} = reshape(output{i}, sizes);
  end
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
  function varargout = applyFunc(index)
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
    [varargout{1:nargout}] = func(args{:});
  end

  f = @applyFunc;
end
