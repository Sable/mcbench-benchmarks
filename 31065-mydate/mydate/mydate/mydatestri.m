function num = mydatestri (str, format)
    if (nargin < 2) || isempty(format),  format = 'yymmmdd';  end
    num2 = datenum(str, format);
    %vec2 = datevec(num2)
    %num = mydatenum(vec2);
    [vec0, num0, factor] = mydatebase();
    num = (num2 - num0) * factor;
end

%!test
%! format = 'ddmmmyy';
%! vec = datevec(now());
%! vec(4:6) = 0;
%! num = mydatenum(vec);
%! str = mydatestr(num, format);
%! numb = mydatestri(str, format);
%! numc = mydatestri(lower(str), format);
%! %num, numb, numc, numb-num, numc-num  % DEBUG
%! myassert(numb, num)
%! myassert(numc, num)

