function num = mydateseci (sec, is_diff)
    %if (nargin < 2) || isempty(is_diff),  is_diff = false;  end  % WRONG!
    if (nargin < 2) || isempty(is_diff),  is_diff = true;  end
    [vec0, num0, factor] = mydatebase (); %#ok<ASGLU>
    factor0 = 60*60*24;
    if (factor == factor0)
        dnum = sec;
    else
        dnum = sec .* (factor / factor0);
    end
    if is_diff
        num = dnum;
    else
        num = dnum + num0;
    end
end
