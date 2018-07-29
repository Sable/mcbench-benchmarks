
function r = foldl(list, identity, func)
% VAL = FOLDL(ARRAY, ID, FUNC)
%   Perform a left fold over ARRAY with FUNC using ID as the identity.
%   FOLDL applies FUNC to the current identity (initially ID) and each item
%   of ARRAY successively.  Thus, FOLDL iterates over ARRAY with FUNC.  ID
%   is updated to be the result of this function.  The final result of ID
%   is returned from the function.
%
%   FOLDL is most simply viewed as the haskell code
%     foldl []   id f = id
%     foldl x:xs id f = foldl xs (f id x) f
%
%   FOLDL and FOLDR are implemented as a loop for optimization purposes in
%   these libraries.  FOLDL is tail recursive and thus more efficient on
%   most platforms that use the above functional definition.
%
%   Examples of Common FOLDL uses:
%     sum(array) == foldl(array, 0, @(a,b) a + b)
%     all(array) == foldl(array, true, @(a,b) a && b)
%     any(array) == foldl(array, false, @(a,b) a || b)
%

  if isempty(list)
    r = identity;
    return;
  end

  if iscell(list)
    for i = 1:numel(list)
      identity = func(identity, list{i});
    end
  else
    for i = 1:numel(list)
      identity = func(identity, list(i));
    end
  end

  r = identity;
end
