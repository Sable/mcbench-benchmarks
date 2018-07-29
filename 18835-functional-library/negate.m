
function func = negate(inFunc)
% NFUNC = NEGATE(FUNC)
%   Return the NOT composition of a function - ie, if such a function
%   returns a true value, this would return false, and vice versa.
%
  func = @(i) ~inFunc(i);
end
