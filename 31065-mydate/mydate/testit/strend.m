function answer = strend (str1, str2)
    case_sensitive = true;
    answer = strendi (str1, str2, case_sensitive);
end

%!test
%! myassert(strend('private', 'haha/private'));
%! myassert(~strend('Private', 'haha/private'));
%! myassert(~strend('private', 'haha/private2'));
%! myassert(~strend('packed:rcond:complexNotSupported', ...
%!     'packed:chol:complexNotSupported'));
%! out = strend('private', {'haha/private', 'haha/wrong', ''});
%! myassert(out, [true, false, false])

