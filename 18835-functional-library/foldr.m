
function r = foldr(list, identity, func)
% VAL = FOLDR(ARRAY, ID, FUNC)
%   Perform a right fold on ARRAY using FUNC with identity ID.  FOLDR is
%   the generic recursive list operator.  It applies FUNC to every element
%   of ARRAY in reverse order, along with ID.  The result is an `update' to
%   ID.  The final result of ID is returned.
%
%   FOLDR is most simply viewed as the haskell code
%     foldr []   id f = id
%     foldr x:xs id f = f (foldr xs id f) x
%
%   FOLDL and FOLDR are implemented as a loop for optimization purposes in
%   these libraries, whereas usually FOLDL is tail recursive and thus more
%   efficient on most platforms.
%

  if isempty(list)
    r = identity;
    return;
  end

  if iscell(list)
    for i = numel(list):-1:1
      identity = func(identity, list{i});
    end
  else
    for i = numel(list):-1:1
      identity = func(identity, list(i));
    end
  end

  r = identity;
end
