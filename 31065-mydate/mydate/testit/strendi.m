function answer = strendi (str1, str2, case_sensitive)
    if (nargin < 3) || isempty(case_sensitive),  case_sensitive = false;  end
    flipcell = @(c) cellfun(@(ci) flip(ci), c, 'UniformOutput',false);
    if iscell(str1),  str1 = flipcell(str1);  else  str1 = flip(str1);  end
    if iscell(str2),  str2 = flipcell(str2);  else  str2 = flip(str2);  end
    answer = strstarti (str1, str2, case_sensitive);
end

%!test
%! myassert(strendi('Private', 'haha/private'));
%! myassert(~strendi('Private', 'haha/private2'));
%! myassert(~strendi('packed:rcond:complexNotSupported', ...
%!     'packed:chol:complexNotSupported'));
%! myassert(strendi('Private', 'haha/private'));
%! myassert(strendi('a', {'a', 'b'}), [true, false]);
%! myassert(strendi({'a', 'b'}, 'b'), [false, true]);

