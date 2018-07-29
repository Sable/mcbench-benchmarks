% seconds of the day.
function num = mydatesodi (sod, epoch0)
    num0 = mydatesod_aux ([], epoch0);
    num = num0 + sod;
end

%!test
%! vec = [2000 1 1 0 5 0];
%! num = mydatenum(vec);
%! sod = mydatesod(num);
%! num2 = mydatesodi(sod, vec);
%! %num2, num  % DEBUG
%! myassert (num2, num, -sqrt(eps));

%!test
%! vec  = [2000 1 2 0 5 0];
%! num = mydatenum(vec);
%! vec0 = [2000 1 1 0 0 0];
%! sod = mydatesod(num, vec0);
%! num2 = mydatesodi(sod, vec0);
%! %num2, num  % DEBUG
%! myassert (num2, num, -sqrt(eps));

