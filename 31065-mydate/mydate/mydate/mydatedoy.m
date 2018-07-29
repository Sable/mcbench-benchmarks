function [doy, year] = mydatedoy (epoch, year)
    if (nargin < 2),  year = [];  end
    if (size(epoch,2) == 1)
        % epoch is in mydatenum format
        num = epoch;
        vec = mydatevec(num);
    else
        % epoch is in mydatevec format
        vec = epoch;
        num = mydatenum(vec);
    end
    clear epoch

    %% now define the epoch corresponding to the beginning to that year:
    if isempty(year),  year = vec(:,1);  end
    if ischar(year) && any(strcmpi(year, {'median','fixed'}))
        year = median(vec(:,1));
    end
    vec0 = zeros(size(vec));
    vec0(:,1) = year;
    num0 = mydatenum(vec0);

    %%
    doy = (num - num0) ./ (3600 .* 24);
end

%!test
%! d = [2000 1 1 0 0 0];
%! doy_correct = 1;
%! doy_answer = mydatedoy(mydatenum(d));
%! myassert (doy_answer, doy_correct);

%!test
%! d = [2000 1 30 0 0 0];
%! doy_correct = 30;
%! doy_answer = mydatedoy(mydatenum(d));
%! myassert (doy_answer, doy_correct);

%!test
%! d = [2000 2 1 0 0 0];
%! doy_correct = 32;
%! doy_answer = mydatedoy(mydatenum(d));
%! myassert (doy_answer, doy_correct);

