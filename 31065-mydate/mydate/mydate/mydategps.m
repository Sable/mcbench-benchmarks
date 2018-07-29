function varargout = mydategps (epoch)
    error(nargoutchk(0, 3, nargout, 'struct'));

    sec_per_hour = 60^2;
    sec_per_day  = 24 * sec_per_hour;
    sec_per_week = 7 * sec_per_day;
    %epoch0 = mydatenum([1980 01 13]);  % WRONG!
    epoch0 = mydatenum([1980 01 06]);
    % as per <http://facility.unavco.org/data/glossary.html#GPS week>
    
    sow = mydatesow(epoch);
    dow = floor(sow ./ sec_per_day);
    sod = sow - dow .* sec_per_day;
    week = (epoch - epoch0) ./ sec_per_week;
    week = floor(week);

    switch nargout
    case {0, 1}
        varargout = {sow};
    case 2
        varargout = {week, sow};
    case 3
        varargout = {week, dow, sod};
    end
end

%!test
%! % using SOPAC's date converter:
%! % <http://sopac.ucsd.edu/scripts/convertDate.cgi>
%! year = 2009;
%! mon = 10;
%! day = 28;
%! week = 1555;
%! dow = 3;
%! sod = 100*rand;
%! vec = [year, mon, day, 0, 0, sod];
%! num = mydatenum(vec);
%! [week2, dow2, sod2] = mydategps (num);
%! %[ [week2, dow2, sod2]; [week, dow, sod]; ...
%! %  [week2, dow2, sod2] - [week, dow, sod] ]  % DEBUG
%! myassert(week2, week);
%! myassert(dow2, dow);
%! myassert(sod2, sod, sqrt(eps));

%!test
%! % using SOPAC's date converter:
%! % <http://sopac.ucsd.edu/scripts/convertDate.cgi>
%! year = 2000;
%! mon = 01;
%! day = 01;
%! week = 1042;
%! dow = 6;
%! sod = 100*rand;
%! vec = [year, mon, day, 0, 0, sod];
%! num = mydatenum(vec);
%! [week2, dow2, sod2] = mydategps (num);
%! %[ [week2, dow2, sod2]; [week, dow, sod]; ...
%! %  [week2, dow2, sod2] - [week, dow, sod] ]  % DEBUG
%! myassert(week2, week);
%! myassert(dow2, dow);
%! myassert(sod2, sod, sqrt(eps));

%!test
%! % using SOPAC's date converter:
%! % <http://sopac.ucsd.edu/scripts/convertDate.cgi>
%! year = 2010;
%! mon = 06;
%! day = 05;
%! week = 1586;
%! dow = 6;
%! sod = 0;
%! vec = [year, mon, day, 0, 0, sod];
%! num = mydatenum(vec);
%! [week2, dow2, sod2] = mydategps (num);
%! %[ [week2, dow2, sod2]; [week, dow, sod]; ...
%! %  [week2, dow2, sod2] - [week, dow, sod] ]  % DEBUG
%! myassert(week2, week);
%! myassert(dow2, dow);
%! myassert(sod2, sod, sqrt(eps));

