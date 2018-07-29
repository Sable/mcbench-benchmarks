
function func = konst(value)
% FUNC = KONST(VALUE)
%   Return a function that always returns VALUE.
%

  function ret = konstFunc(varargin)
    ret = value;
  end
  func = @konstFunc;
end