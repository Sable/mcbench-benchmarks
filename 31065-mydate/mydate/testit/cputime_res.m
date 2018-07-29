function res = cputime_res
    % clock resolution:
    res = 0; while (res == 0), res = abs(cputime - cputime); end
end

%!test
%! res = cputime_res;

