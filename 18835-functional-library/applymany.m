
function applymany(arrays, varargin)
% APPLYMANY(INPUT_ARRAY, FUNC)
%   Here, INPUT_ARRAY is a cell array of arrays.  Each i'th array in
%   INPUT_ARRAY will provide the i'th argument in function invocations.
%   Arrays are stepped through in sync - ie, the j'th invocation of the
%   applied function with receive the j'th elements of the INPUT_ARRAY
%   elements.  Example:
%     APPLYMANY({[1, 2, 3], {2, 3}}, @someFunc)
%   Will call someFunc with (1, 2), (2, 3), and then exit (as the second
%   list - {2, 3} `ran out').  Thus, this allows one to use apply on high
%   arity functions.  APPLY(ARRAY, ...) and APPLYMANY({ARRAY}, ...) are
%   equivalent.
%

  if ~iscell(arrays)
    error('ApplyMany:Arguments', 'Array input (first argument) must be a cell array.');
  end

  least = min(map(arrays, @numel, 'double'));
  [funcs, args] = select(varargin, @islambda);

  if ~isscalar(funcs)
    error('ApplyMany:Arguments', 'One and only one function can be used in application.  Use composition for multiple functions.');
  end

  funcs = funcs{1};

  apply(1:least, generateManyFunc(arrays, funcs), args{:});
end

function f = generateManyFunc(arrays, func)
  function f = makeIdx(arr)
    if iscell(arr), f = @(idx) arr{idx}; else f = @(idx) arr(idx); end
  end
  idxs = map(arrays, @makeIdx);

  n = numel(arrays);
  args = cell(1,n);
  function applyFunc(index)
    for i = 1:n
      f = idxs{i};
      args{i} = f(index);
    end
    func(args{:});
  end

  f = @applyFunc;
end
