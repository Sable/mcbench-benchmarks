function sec = mydatesec (num, is_diff)
    %if (nargin < 2) || isempty(is_diff),  is_diff = false;  end  % WRONG!
    if (nargin < 2) || isempty(is_diff),  is_diff = true;  end
    [vec0, num0, factor] = mydatebase (); %#ok<ASGLU>
    factor0 = 60*60*24;
    if is_diff
        dnum = num;
    else
        dnum = num - num0;
    end
    if (factor == factor0)
        sec = dnum;
    else
        sec = dnum ./ (factor / factor0);
    end
end

%!test
%! num = 100 * rand();
%! sec = mydatesec (num);
%! assert(sec == num)

