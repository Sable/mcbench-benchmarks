% seconds of the day.
function sod = mydatesod (epoch, epoch0)
    if (nargin < 2),  epoch0 = [];  end
    if isempty(epoch)
        sod = epoch;
        return;
    end
    num0 = mydatesod_aux (epoch, epoch0);

    if (size(epoch,2) == 1)
        % epoch is in mydatenum format
        num = epoch;
        %no need to calculate vec.
        %vec = mydatevec(num);
    else
        % epoch is in mydatevec format
        vec = epoch;
        num = mydatenum(vec);
    end
    
    %%
    sod = (num - num0);
    %num, num0  % DEBUG
    %vec, vec0  % DEBUG
end

%!test
%! d = [2000 1 1 0 5 0];
%! sod_correct = 300;
%! sod_answer = mydatesod(mydatenum(d));
%! myassert (sod_answer, sod_correct, -sqrt(eps));

%!test
%! d  = [2000 1 2 0 5 0];
%! d0 = [2000 1 1 0 0 0];
%! sod_correct = 300 + 24*60^2;
%! sod_answer = mydatesod(mydatenum(d), d0);
%! myassert (sod_answer, sod_correct, -sqrt(eps));
%! sod_answer = mydatesod(mydatenum(d), mydatenum(d0));
%! myassert (sod_answer, sod_correct, -sqrt(eps));

%!test
%! in = NaN(2,1);
%! out = mydatesod(in);
%! myassert(out, in)

