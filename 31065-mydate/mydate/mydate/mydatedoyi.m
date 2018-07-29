function num = mydatedoyi (doy, year)
    myassert(length(year)==length(doy) || isscalar(year))

    %% define the epoch corresponding to the beginning to that year:
    vec0 = zeros(max(length(year),length(doy)), 3);
    vec0(:,1) = year;
    num0 = mydatenum(vec0);

    %%
    num = num0 + doy .* (3600 * 24);
end

%!test
%! vec = [2000 1 1 0 0 0];
%! num = mydatenum(vec);
%! doy = 1;
%! year = 2000;
%! num2 = mydatedoyi(doy, year);
%! myassert (num2, num);

%!test
%! vec = [2000 1 30 0 0 0];
%! num = mydatenum(vec);
%! doy = 30;
%! year = 2000;
%! num2 = mydatedoyi(doy, year);
%! myassert (num2, num);

%!test
%! vec = [2000 2 01 0 0 0];
%! num = mydatenum(vec);
%! doy = 32;
%! year = 2000;
%! num2 = mydatedoyi(doy, year);
%! myassert (num2, num);

