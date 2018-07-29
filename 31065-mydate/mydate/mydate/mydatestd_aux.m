function [year_len, year_start, year_end] = mydatestd_aux (year)
    if (nargin == 0) || isempty(year),  year = 2000;  end

    n = length(year);

    temp = repmat([0  1  1   0 0 0], n, 1);
    temp(:,1) = year;
    year_start = mydatenum(temp);

    temp = repmat([0 12 31  24 0 0], n, 1);
    temp(:,1) = year;
    year_end = mydatenum(temp);

    year_len = year_end - year_start;
end

%!test
%! % year = 2000 is a special case.
%! year = 2000;
%! [year_len, year_start, year_end] = mydatestd_aux (year);
%! myassert(year_start, 1*3600*24);
%! %myassert(year_len, ref_year_len)

%!test
%! % empty input
%! myassert(mydatestd_aux(), mydatestd_aux(2000))

%!test
%! % mydatestd_aux()
%! warning('off', 'test:noFuncCall')

%!test
%! % consistency check with easy epoch:
%! epoch_vec = [2000 1 1  0 0 0];
%! epoch = mydatenum(epoch_vec);
%! [epoch_std, year] = mydatestd(epoch);
%! epoch2 = mydatestdi(epoch_std, year);
%! myassert(epoch2, epoch, -eps)

%!test
%! % consistency check with any epoch:
%! epoch = rand*(100*365.25*24*3600);  % 100 years range
%! [epoch_std, year] = mydatestd(epoch);
%! epoch2 = mydatestdi(epoch_std, year);
%! %epoch2 - epoch  % DEBUG
%! myassert(epoch2, epoch, -sqrt(eps))

%!test
%! % multiple epochs:
%! n = ceil(10*rand);
%! epoch = rand(n,1)*(100*365.25*24*3600);
%! [epoch_std, year] = mydatestd(epoch);
%! epoch2 = mydatestdi(epoch_std, year);
%! %epoch2 - epoch  % DEBUG
%! myassert(epoch2, epoch, -sqrt(eps))

%!test
%! % test irregular case: std epoch greater than 1 std year len, multiple epochs.
%! %year = 2000;  day_excess = 2;
%! n = ceil(10*rand);
%! year = round(3000*rand(n,1));
%! %day_excess = round(365*rand(n,1));  % WRONG!
%! %day_excess = ceil(365*rand(n,1));  % WRONG!
%! day_excess = round(randint(1, 364, n, 1));
%! 
%! year2 = year + 1;
%! epoch_vec = [year2, ones(n,1), 1+day_excess,  zeros(n,3)];
%! epoch = mydatenum(epoch_vec);
%! 
%! year_len2 = mydatestd_aux(year2);
%! std_year_len = mydatestd_aux();
%! epoch_std_excess = day_excess.*24*3600 ./ year_len2 .* std_year_len;
%! epoch_std = std_year_len + epoch_std_excess;
%! 
%! % converting from year2 is regular case:
%! epoch2 = mydatestdi(epoch_std_excess, year2);
%! epoch_std2 = mydatestd(epoch2);
%!   myassert(epoch2, epoch, -sqrt(eps));
%!   myassert(epoch_std2, epoch_std_excess, -sqrt(eps));
%! epoch_vec2 = mydatevec(epoch2);
%! 
%! % try irregular case now:
%! epoch2 = mydatestdi(epoch_std, year);
%! epoch_std2 = mydatestd(epoch2);
%!   myassert(epoch2, epoch, -sqrt(eps));
%!   myassert(epoch_std2, epoch_std_excess, -sqrt(eps));
%!   % *VERY IMPORTANT*: an irregular std epoch, 
%!   % greater than std year len, 
%!   % converted to epoch then back to std is NOT  
%!   % equal to the original irregular std epoch --;
%!   % it is equal to its excess std epoch only!;
%! epoch_vec2 = mydatevec(epoch2);
%!   % Don't check epoch_vec because day_excess may be > 31.

%!test
%! % test irregular case: negative std epoch, multiple epochs.
%! %year = 2000;  day_excess = -2;
%! n = ceil(10*rand);
%! year = round(3000*rand(n,1));
%! %day_excess = -round(365*rand(n,1));  % WRONG!
%! %day_excess = -round(364*rand(n,1));  % WRONG!
%! day_excess = -round(randint(1, 364, n, 1));
%! 
%! epoch_vec = [year, ones(n,1), 1+day_excess,  zeros(n,3)];
%! epoch = mydatenum(epoch_vec);
%! year2 = year - 1;
%! 
%! year_len2 = mydatestd_aux(year2);
%! std_year_len = mydatestd_aux();
%! epoch_std_excess = day_excess.*24*3600 ./ year_len2 .* std_year_len;
%! epoch_std = std_year_len + epoch_std_excess;
%! 
%! % converting from year2 is regular case:
%! epoch2 = mydatestdi(epoch_std, year2);
%! epoch_std2 = mydatestd(epoch2);
%! epoch_vec2 = mydatevec(epoch2);
%!   myassert(epoch2, epoch, -sqrt(eps));
%!   myassert(epoch_std2, epoch_std, -sqrt(eps));
%! 
%! % try irregular case now:
%! epoch2 = mydatestdi(epoch_std_excess, year);
%! epoch_std2 = mydatestd(epoch2);
%! epoch_vec2 = mydatevec(epoch2);
%!   % Don't check epoch_vec because day_excess is < 0.
%!   myassert(epoch2, epoch, -sqrt(eps));
%!   myassert(epoch_std2, epoch_std, -sqrt(eps));
%!   % *VERY IMPORTANT*: an irregular std epoch, negative, 
%!   % converted to epoch then back to std is NOT  
%!   % equal to the original irregular std epoch!

%!test
%! % test CIRA.epoch: 
%! std_year_len = mydatestd_aux();
%! epoch_std = ((1:12)'-0.5)./12 .* std_year_len;
%!   de = unique(diff(epoch_std));
%! epoch_stdd = [epoch_std(end); epoch_std; epoch_std(1)];
%! epoch_std = [epoch_std(1)-de; epoch_std; epoch_std(end)+de];
%!   de = unique(diff(epoch_std));
%!   myassert(isscalar(de))  % epoch_std is still regularly spaced
%! 
%! year = 2000;
%! epoch = mydatestdi(epoch_std, year);
%!   de = unique(diff(epoch));
%!   myassert(~isscalar(de))  % epoch is NOT regularly spaced
%! epoch_vec = mydatevec(epoch);
%! 
%! epoch_std2 = mydatestd(epoch);
%! myassert(epoch_std2, epoch_stdd);
%!   % An irregular std epoch converted to epoch then back to std 
%!   % is NOT equal to the original std epoch!

%!test
%! lasterror('reset')

%!error
%! mydatestdi(3*mydatestd_aux(), round(rand))

%!test
%! s = lasterror;
%! myassert(strcmp(s.identifier, 'MATLAB:mydatestdi:outRange'))

%!test
%! warning('on', 'test:noFuncCall')

