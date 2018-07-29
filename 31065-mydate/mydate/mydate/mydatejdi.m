function epoch = mydatejdi (jd)
    n = numel(jd);
    jd = reshape(jd, [n,1]);
    
    int = @(x) floor(x);

    z = int(jd - 1721118.5);
    r = jd - 1721118.5 - z;
    g = z - .25;
    a = int(g ./ 36524.25);
    b = a - int(a ./ 4);
    year = int((b+g) ./ 365.25);
    c = b + z - int(365.25 .* year);
    month = fix((5 .* c + 456) ./ 153);
    day = c - fix((153 .* month - 457) ./ 5) + r;
    %if month > 12 then 
    %       year = year + 1 
    %       month = month - 12 
    %end
    idx = (month > 12);
    year(idx) = year(idx) + 1;
    month(idx) = month(idx) - 12;
    
    %[year month day]  % DEBUG
    epoch = mydatenum([year month day]);
end

%!test
%! % internal consistency check:
%! n = 10;
%! temp = 60*60*24*365.25*10;  % 10-year interval
%! num = randint(-temp, +temp, n, 1);
%! vec = mydatevec(num);
%!   jd = mydatejd(num);
%! num2 = mydatejdi(jd);
%!  jd2 = mydatejd(num2);
%! %[num, num2, num2 - num]  % DEBUG
%! %[ jd,  jd2,  jd2 -  jd]  % DEBUG
%! myassert(num2, num, -nthroot(eps(), 4))
%! myassert( jd2,  jd, -sqrt(eps()))

%!test
%! temp = mydatejdi (0);
%! temp2 = mydatenum([-4713 11 24 12 0 0]);
%! myassert (temp, temp2)

%!test
%! temp = mydatejdi (-0.5);
%! temp2 = mydatenum([-4713 11 24 0 0 0]);
%! myassert (temp, temp2)

%!test
%! temp = mydatejdi (2444239.0);
%! temp2 = mydatenum([1979 12 31 12 0 0]);
%! myassert (temp, temp2)

%!test
%! temp = mydatejdi (2444239.5);
%! temp2 = mydatenum([1980 01 01 0 0 0]);
%! myassert (temp, temp2)

%!test
%! temp = mydatejdi (2444240.0);
%! temp2 = mydatenum([1980 01 01 12 0 0]);
%! myassert (temp, temp2)

%!test
%! temp = mydatejdi (2444240.5);
%! temp2 = mydatenum([1980 01 01 24 0 0]);
%! myassert (temp, temp2)

%!test
%! % multiple epochs in multiple months:
%! n = 1 + ceil(10*rand);
%! vec = horzcat(...
%!     round(randint(2000, 2100, n, 1)), ...
%!     round(randint(1, 12, n, 1)), ...
%!     round(randint(1, 30, n, 1)), ...
%!     round(randint(1, 24, n, 1)), ...
%!     round(randint(1, 60, n, 1)), ...
%!           randint(1, 60, n, 1) ...
%! );
%! num = mydatenum(vec);
%! jd = mydatejd(num);
%! num = NaN(n,1);
%! for i=1:n
%!     num(i) = mydatejdi(jd(i));
%! end
%! num2 = mydatejdi(jd);
%! %num, num2 % DEBUG
%! myassert(num2, num)

%!test
%! temp = mydatejdi (2299149.5);
%! temp2 = mydatenum([1582 	10 	4.0]);
%! myassert (temp, temp2)
