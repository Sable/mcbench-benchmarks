function m = chessmat(rows,cols,l,offset)
%CHESSMAT   returns a chessboard-like matrix
%   Syntax   m = chessmat(rows,cols,l,offset)
%    where l is the width of one block, and offset defines the style of the
%    matrix, that offset == 0 means 1 

switch nargin
    case 0
        rows = 3;
        cols = 3;
        l = 1;
        offset = 0;
    case 1
        cols = rows;
        l = 1;
        offset = 0;
    case 2
        if ischar(cols)
            l = cols;
            cols = rows;
        else
            l = 1;
        end
        offset = 0;
    case 3
        if ischar(cols)
            offset = l;
            l = cols;
            cols = rows;
        else
            offset = 0;
        end
end
if ischar(l)
    l = fix(str2double(l));
end
if ischar(offset)
    switch lower(offset)
        case {'0', 'zero'}
            offset = 0.1;
        case {'1', 'one'}
            offset = 1;
        case {'-0', 'zero_enlarge'}
            offset = -0.1;
        case {'-1', 'one_enlarge'}
            offset = -1;
        otherwise
            fprintf('''%s'' is not an optional value of "offset".\n',offset);
            m = [];
            return;
    end
end
if abs(offset) < 1
    idx_rem = 0;
else
    idx_rem = 1;
end
l = abs(l)+(l == 0);
m = zeros(ceil(rows/l)*l,ceil(cols/l)*l);
for k1 = 0:ceil(rows/l)-1
    for k2 = 0:ceil(cols/l)-1
        if rem(k1+k2,2) == idx_rem
            m((k1*l+1):(k1*l+l),(k2*l+1):(k2*l+l)) = 1;
        end
    end
end
if offset >= 0
    m = m(1:rows,1:cols);
end

end
