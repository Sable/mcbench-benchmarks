function str = mydatestr (num, format)
    if (nargin < 2) || isempty(format),  format = 'yymmmdd';  end
    vec = mydatevec(num);
    str = datestr(vec, format);
end

%!test
%! format = 'ddmmmyy';
%! num = mydatenum(datevec(now));
%! str = mydatestr(num, format);
%! %str = mydatestr(num)

