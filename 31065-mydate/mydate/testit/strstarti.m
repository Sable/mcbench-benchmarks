function answer = strstarti (str1, str2, case_sensitive)
    if (nargin < 3) || isempty(case_sensitive),  case_sensitive = false;  end
    if ~iscell(str1),  str1 = {str1};  end
    if ~iscell(str2),  str2 = {str2};  end
    ns = cellfun(@numel, str1);
    answer = strnscmpi (str1, str2, ns, case_sensitive);
end

function answer = strnscmpi (str1, str2, ns, case_sensitive)
    strncmp2 = @strncmpi;  if case_sensitive,  strncmp2 = @strncmp;  end
    n = unique(ns);
    if isscalar(n)
        answer = strncmp2(str1, str2, n);
        return;
    end
    N = numel(str1);
    if (numel(str2) ~= N)
        error('MATLAB:strcmp:InputsSizeMismatch', ...
            'Inputs must be the same size or either one can be a scalar.');
    end
    str2 = cellfun(@(i) str2{i}(1:min(ns(i),end)), 1:N, ...
        'UniformOutput',false);
    answer = cellfun(@(i) strncmp2(str1{i}, str2{i}, ns(i)), 1:N);
end

%!test
%! myassert(strstarti('haha', 'haha/private'));
%! myassert(~strstarti('hahablah', 'haha/private2'));
%! myassert(~strstarti('packed:rcond:complexNotSupported', ...
%!     'packed:chol:complexNotSupported'));
%! out = strstarti('haha', {'haha/private', 'blah/private', ''});
%! myassert(out, [true, false, false])
%! out = strstarti({'haha','haha','haha'}, {'haha/private','blah/private',''});
%! myassert(out, [true, false, false])

