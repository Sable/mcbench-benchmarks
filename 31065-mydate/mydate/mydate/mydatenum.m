% Intented to give more resolution to epoch units, for near-current epochs.
function num = mydatenum (vec, is_diff)
    if (nargin < 2),  is_diff = false;  end

    m = size(vec,2);
    if isempty(vec)
        num = vec;
        return;
    end
    if (m > 6)
        error('MATLAB:mydatenum:inputError', ...
            'Input must have fewer than 6 columns.');
    end
    % complete missing columns with zeros:
    vec(:,(end+1):6) = 0;
    if any( ~(0 <= vec(:,2) & vec(:,2) <= 12) & ~isnan(vec(:,2)) )
        warning('mydatenum:monthRange', 'Invalid month range.');
    end
        
    [vec0, num0, factor] = mydatebase (); %#ok<ASGLU>
    if is_diff,  vec0 = zeros(1,6);  end
    
    %num = (datenum(vec) - num0) .* 3600 .* 24;
    % remove offset before calling datenum(); otherwise we lose precision:
    vec(:,1) = vec(:,1) - vec0(1);
    temp = mat2cell(vec, size(vec,1), ones(1,size(vec,2)));
    num = datenum(temp{:}) * factor;
    %num = datenum(vec) * factor; %WRONG! see test case below.
end

%!test
%! myassert(mydatenum ([2000 0 0 0 0 0]), 0);
%! %mydatenum ([2000 0 0 0 0 1])  % DEBUG
%! myassert(mydatenum ([2000 0 0 0 0 1]), 1);
%! myassert(mydatenum ([0 0 0 0 0 1], true), 1);
%! myassert(mydatenum ([0 0 0 1 0 0], true), 3600);
%! myassert(mydatenum ([2000 0 0]), 0);

%!test
%! myassert(isempty(mydatenum(zeros(1,0))))

%!test
%! in = NaN(2,6);
%! out = NaN(2,1);
%! out2 = mydatenum(in);
%! myassert(isequalwithequalnans(out2, out))

