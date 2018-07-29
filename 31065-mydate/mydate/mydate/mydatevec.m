% Pair to mydatenum().
function vec = mydatevec (num, is_diff)
    if (nargin < 2),  is_diff = false;  end
    [vec0, num0, factor] = mydatebase ();
    if is_diff,  vec0 = zeros(1,6);  end
    %vec2 = datevec (num0 + num ./ factor);  % we may lose precision.
    vec2 = datevec (num ./ factor);
    %num, factor, num/factor, vec2  % DEBUG
    vec = vec2 + repmat(vec0, [size(num,1), 1]);
end

%!test
%! myassert(mydatevec (0), [2000 0 0 0 0 0]);
%! myassert(mydatevec (1), [2000 0 0 0 0 1]);
%! myassert(mydatevec (1, true), [0 0 0 0 0 1]);

%!test
%! num2 = now();
%! vec2 = datevec(num2);
%! [vec0, num0, factor] = mydatebase();
%! veca = vec2;
%! numa = mydatenum(veca);
%! numb = (num2 - num0) .* factor;
%! vecb = mydatevec(numb);
%!   %[numa, numb, numa-numb]
%!   %[veca; vecb; veca-vecb]

