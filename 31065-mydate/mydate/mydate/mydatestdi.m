function epoch = mydatestdi (epoch_std, year)
    [year_len, year_start] = mydatestd_aux(year);

    std_year_len = mydatestd_aux();

    epoch = epoch_std ./ std_year_len .* year_len + year_start;
    
    if any(epoch_std > 2.*std_year_len) ...
    || any(epoch_std <   -std_year_len)
        error('MATLAB:mydatestdi:outRange', ...
        'First argument is out of valid input range.');
    end

    year = repmat(year, length(epoch_std), 1);

    idx = (epoch_std > std_year_len);
    if any(idx)
        epoch(idx) = mydatestdi(epoch_std(idx)-std_year_len, year(idx)+1);
    end

    idx = (epoch_std < 0);
    if any(idx)
        epoch(idx) = mydatestdi(std_year_len-abs(epoch_std(idx)), year(idx)-1);
    end
end

%!test
%! % mydatestdi()
%! test('mydatestd_aux')

