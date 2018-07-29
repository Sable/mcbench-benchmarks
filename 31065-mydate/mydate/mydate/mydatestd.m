function [epoch_std, year] = mydatestd (epoch)
    temp = mydatevec(epoch);
    year = temp(:,1);
    [year_len, year_start] = mydatestd_aux(year);

    std_year_len = mydatestd_aux();

    epoch_std = (epoch - year_start) ./ year_len .* std_year_len;
end

%!test
%! % mydatestd()
%! test('mydatestd_aux')

