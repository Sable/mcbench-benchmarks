% seconds of the week.
function sow = mydatesow (epoch, epoch2)
    % use epoch2 if you wish sod to refer to a different week, 
    % e.g., to the previous week, so that sod is continuous 
    % across the week boundary. In this case, epoch2 
    % is a scalar.
    if (nargin < 2),  epoch2 = epoch;  end
    %epoch, epoch2  % DEBUG

    % beginning of week:
    bow2 = mydatesow_aux (epoch2);

    % seconds since beginning of week:
    sow = epoch - bow2;
end

%!test
%! % on a Sunday, sow == sod.
%! vec = [2008 11 30  13 14 15];
%! num = mydatenum(vec);
%! sod = mydatesod(num);
%! sow = mydatesow(num);
%! %sod, sow  % DEBUG
%! myassert (sow, sod, -sqrt(eps));

%!test
%! % random sow (within one weeek):
%! sow = randint(0, 7*24*3600);
%! bow_vec = [2008 11 30  0 0 0];
%! bow_num = mydatenum(bow_vec);
%! num = bow_num + sow;
%! sow2 = mydatesow(num);
%! %sow2, sow, sow2-sow  % DEBUG
%! tol = 1e-7;
%! myassert (sow2, sow, -tol);

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
%! tol = 1e-7;
%! myassert (sow2a, sow, -tol);
%! myassert (sow2b, sow+7*24*3600, -tol);

