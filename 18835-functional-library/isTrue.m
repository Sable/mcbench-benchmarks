
function b = isTrue(array, pred)
% BOOL = ISTRUE(ARRAY, PRED)
%   ISTRUE returns an BOOL, the same shape and size as ARRAY, where each
%   corresponding element of BOOL is true or false based on the application
%   of PRED to that element in ARRAY.  Thus, the resulting array can be
%   used for logical indexing and such in array.  This abstracts away
%   whether ARRAY contains actual data or cell references and allows
%   arbitrary PRED functions.
%

  if nargin <= 1, pred = @(i) i; end

  n = numel(array);
  b = false(size(array));

  if iscell(array)
    for i = 1:n
      b(i) = pred(array{i});
    end
  else
    for i = 1:n
      b(i) = pred(array(i));
    end
  end
end
