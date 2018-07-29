function num0 = mydatesod_aux (epoch, epoch0)
    if (nargin < 2),  epoch0 = [];  end
    if ischar(epoch0) && strcmp(epoch0, 'first')
        epoch0 = epoch(1);
        if isnan(epoch0)
            epoch0 = epoch(find(~isnan(epoch), 1, 'first'));
        end
    end
    if ~isempty(epoch0)
        num0 = mydatebod (epoch0);
    else
        num0 = mydatebod (epoch);
    end
end

%!test
%! % mydatesod_aux()
%! test('mydatesod')
%! test('mydatesodi')

