function [vec, num2, factor] = mydatebase ()
    year = 2000;
    vec = horzcat(year, zeros(1,5));
    num2 = datenum(vec);
    factor = 60 * 60 * 24;  % datenum is in decimal days, mydatenum is in seconds.
end

%!test
%! [vec, num2, factor] = mydatebase ();
%! assert(isequal(size(vec), [1,6]))
%! assert(isscalar(num2))
%! assert(isscalar(factor))

