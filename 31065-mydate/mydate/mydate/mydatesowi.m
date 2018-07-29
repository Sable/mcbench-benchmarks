function epoch = mydatesowi (sow, epoch2)
    bow2 = mydatesow_aux (epoch2);
    epoch = sow + bow2;
end

%!test
%! % on a Sunday, sow == sod.
%! vec = [2008 11 30  13 14 15];
%! num = mydatenum(vec);
%! sod = mydatesod(num);
%! sow = mydatesow(num);
%! num2 = mydatesodi(sod, num);
%! num3 = mydatesowi(sow, num);
%! %sod, sow  % DEBUG
%! %num, num2, num3  % DEBUG
%! myassert (sow, sod, -sqrt(eps));
%! myassert (num2, num, -sqrt(eps));
%! myassert (num3, num, -sqrt(eps));

%!test
%! % random sow (within one weeek):
%! sow = randint(0, 7*24*3600);
%! bow_vec = [2008 11 30  0 0 0];
%! bow_num = mydatenum(bow_vec);
%! num = bow_num + sow;
%! sow2 = mydatesow(num);
%! num2 = mydatesowi(sow2, num);
%! %sow2, sow, sow2-sow  % DEBUG
%! %num2, num, num2-num  % DEBUG
%! tol = 1e-7;
%! myassert (sow2, sow, -tol);
%! myassert (num2, num, -tol);

%!test
%! % epoch2 <> epoch.
%! sow = randint(0, 7*24*3600);
%! bow_vec = [2008 11 30  0 0 0];
%! bow_num = mydatenum(bow_vec);
%! num = bow_num + sow;
%! bow_vec2 = [2008 11 30-7  0 0 0];
%! bow_num2 = mydatenum(bow_vec2);
%! sow2a = mydatesow(num, bow_num);
%! sow2b = mydatesow(num, bow_num2);
%! num2a = mydatesowi(sow2a, bow_num);
%! num2b = mydatesowi(sow2b, bow_num2);
%! %num, num2a, num2b  % DEBUG
%! tol = 1e-7;
%! myassert (sow2a, sow, -tol);
%! myassert (sow2b, sow+7*24*3600, -tol);
%! myassert (num2a, num, -tol);
%! myassert (num2b, num, -tol);

