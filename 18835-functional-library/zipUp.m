
function arr = zipUp(varargin)
% ARRAY = ZIPUP(INPUT_ARRAY+)
%   Create an N x M ARRAY where M is NARGIN (ie the number of input
%   arrays), and N is MIN(NUMEL(A)) where A ranges across INPUT_ARRAYs.
%   The element ARRAY{C,D} is the C'th element of input array D.
%

  if nargin == 0
    arr = [];
    return;
  end

  if nargin == 1
    arr = map(varargin{1}, @(i) {i}, 'cell');
    return;
  end

  n = min(map(varargin, @numel, 'double'));
  m = nargin;

  function f = makeIdx(arr)
    if iscell(arr), f = @(idx) arr{idx}; else f = @(idx) arr(idx); end
  end
  idxs = map(varargin, @makeIdx);

  arr = cell(n,nargin);
  for i = 1:n
    for j = 1:m
      idx = idxs{j};
      arr{i,j} = idx(i);
    end
  end
end
