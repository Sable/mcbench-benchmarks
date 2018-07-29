function m = testmat(rows,cols,mattype)
n_arg = nargin;
if n_arg == 2
    if ischar(cols)
        mattype = cols;
        cols = rows;
    else
        mattype = 'sequence';
    end
end
if n_arg == 1
    if ischar(rows)
        mattype = rows;
        rows = 3;
        cols = 3;
    else
        mattype = 'sequence';
        cols = rows;
    end
end
if n_arg == 0
    mattype = 'sequence';
    rows = 3;
    cols = 3;
end
if strncmpi(mattype,'sequence',3)
    m = reshape(1:rows*cols,cols,rows)';
elseif strncmpi(mattype,'stage',3)
    m = repmat((0:rows-1)',1,cols)+repmat(1:cols,rows,1);
else
    fprintf('unspecified ''%s''\n',mattype)
end
end
