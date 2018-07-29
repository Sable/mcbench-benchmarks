function out = mydatehour (in)
    if (size(in,2) == 1)
        % in is in mydatenum format
        out = in ./ 3600;
    else
        % in is in mydatevec format
        out = mydatehour(mydatenum(in, true));
    end
end

%!shared
%! n = ceil(10*rand);
%! h = 100*rand(n,1);

%!test
%! in = h * 3600;
%! out = mydatehour(in);
%! %[h, out, out-h]  % DEBUG
%! myassert(out, h, -sqrt(eps))

%!test
%! in = zeros(n,6);  in(:,4) = h;
%! out = mydatehour(in);
%! %[h, out, out-h]  % DEBUG
%! myassert(out, h, -sqrt(eps))

