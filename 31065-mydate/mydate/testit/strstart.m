function answer = strstart (str1, str2)
    case_sensitive = true;
    answer = strstarti (str1, str2, case_sensitive);
end

%!test
%! myassert(strstart('haha', 'haha/private'));
%! myassert(~strstart('Haha', 'haha/private'));
%! myassert(~strstart('hahablah', 'haha/private2'));
%! myassert(~strstart('packed:rcond:complexNotSupported', ...
%!     'packed:chol:complexNotSupported'));
%! out = strstart('haha', {'haha/private', 'blah/private', ''});
%! myassert(out, [true, false, false])

