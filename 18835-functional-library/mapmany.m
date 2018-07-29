
function varargout = mapmany(arrays, varargin)
% [OUTPUT1, .., OUTPUTN] = MAPMANY(INPUT_ARRAY, ARGUMENTS+)
%   Here, INPUT_ARRAY is a cell array of arrays.  Each i'th array in
%   INPUT_ARRAY will provide the i'th argument in function invocations.
%   Arrays are stepped through in sync - ie, the j'th invocation of the
%   mapping function with receive the j'th elements of the INPUT_ARRAY
%   elements.  Example:
%     MAPMANY({[1, 2, 3], {2, 3}}, @someFunc)
%   Will call someFunc with (1, 2), (2, 3), and then exit (as the second
%   list - {2, 3} `ran out').  Thus, this allows one to apply map to high
%   arity functions.  ARGUMENTS are the normal MAP arguments, with OUTPUTS
%   also being the same.  MAP(ARRAY, ...) and MAPMANY({ARRAY}, ...) are
%   equivalent.  See MAP for more information.
%

  if ~iscell(arrays)
    error('MapMany:Arguments', 'Array input (first argument) must be a cell array.');
  end

  least = min(map(arrays, @numel, 'double'));
  [funcs, args] = select(varargin, @islambda);

  if ~isscalar(funcs)
    error('MapMany:Arguments', 'Only one function can be used in mapping.  Use composition for multiple functions.');
  end

  funcs = funcs{1};

  [varargout{1:nargout}] = map(1:least, generateManyFunc(arrays, funcs), args{:});
end

function f = generateManyFunc(arrays, func)
  function f = makeIdx(arr)
    if iscell(arr), f = @(idx) arr{idx}; else f = @(idx) arr(idx); end
  end
  idxs = map(arrays, @makeIdx);

  n = numel(arrays);
  args = cell(1, n);
  function varargout = applyFunc(index)
    for i = 1:n
      f = idxs{i};
      args{i} = f(index);
    end
    [varargout{1:nargout}] = func(args{:});
  end

  f = @applyFunc;
end
