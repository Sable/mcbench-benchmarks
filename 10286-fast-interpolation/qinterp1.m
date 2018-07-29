function Yi = qinterp1(x,Y,xi,methodflag)
% Performs fast interpolation compared to interp1
%
% qinterp1 provides a speedup over interp1 but requires an evenly spaced
% x array.  As x and y increase in length, the run-time for interp1 increases
% linearly, but the run-time for
% qinterp1 stays constant.  For small-length x, y, and xi, qinterp1 runs about
% 6x faster than interp1.
%
%
% Usage:
%   yi = qinterp1(x,Y,xi)  - Same usage as interp1
%   yi = qinterp1(x,Y,xi,flag)
%           flag = 0       - Nearest-neighbor
%           flag = 1       - Linear (default)
%
% Example:
%   x = [-5:0.01:5];   y = exp(-x.^2/2);
%   xi = [-4.23:0.3:4.56];
%   yi = qinterp1(x,y,xi,1);
%
% Usage restrictions
%    x must be monotonically and evenly increasing
%    e.g.,  x=-36:0.02:123;
%
%    Y may be up to two-dimensional
%
% Using with non-evenly spaced arrays:
%   Frequently the user will wish to make interpolations "on the fly" from
%   a fixed pair of library (i.e., x and y) vectors.  In this case, the
%   user can generate an equally-spaced set of library data by calling
%   interp1 once, and then storing this library data in a MAT-file or
%   equivalent.  Because the speed of qinterp1 is independent of the length
%   of the library vectors, the author recommends over-sampling this
%   generated set untill memory considerations start limitting program speed.
%
%   If the user wishes to use two or more spacings (i.e., a closely-spaced
%   library in the region of fine features, and a loosely-spaced library in
%   the region of coarse features), just create multiple libraries, record
%   the switching points, and send the search data to different qinterp1
%   calls depending on its value.
%
%   Example:
%       x1 = [-5:0.01:5];   x2 = [-40:1:-5 5:1:40];
%       y1 = exp(-x1.^2/3); y2 = exp(-x2.^2/3);
%       xi = [-30:0.3:30];
%       in = xi < 5 & xi > -5;
%       yi(in) = qinterp1(x1,y1,xi(in));
%       yi(~in) = qinterp1(x2,y2,xi(~in));

% Author: N. Brahms
% Copyright 2006

% Forces vectors to be columns
x = x(:); xi = xi(:);
sx = size(x); sY = size(Y);
if sx(1)~=sY(1)
    if sx(1)==sY(2)
        Y = Y';
    else
        error('x and Y must have the same number of rows');
    end
end

if nargin>=4
    method=methodflag;
else
    method = 1;    % choose nearest-lower-neighbor, linear, etc.
                   % uses integer over string for speed
end

% Gets the x spacing
ndx = 1/(x(2)-x(1)); % one over to perform divide only once
xi = xi - x(1);      % subtract minimum of x

% Fills Yi with NaNs
s = size(Y);
if length(s)>2
    error('Y may only be one- or two-dimensional');
end
Yi = NaN*ones(length(xi),s(2));

switch method
    case 0 %nearest-neighbor method
        rxi = round(xi*ndx)+1;        % indices of nearest-neighbors
        flag = rxi<1 | rxi>length(x) | isnan(xi);
                                      % finds indices out of bounds
        nflag = ~flag;                % finds indices in bounds
        Yi(nflag,:) = Y(rxi(nflag),:);
    case 1 %linear interpolation method
        fxi = floor(xi*ndx)+1;          % indices of nearest-lower-neighbors
        flag = fxi<1 | fxi>length(x)-1 | isnan(xi);
                                        % finds indices out of bounds
        nflag = ~flag;                  % finds indices in bounds
        Yi(nflag,:) = (fxi(nflag)-xi(nflag)*ndx).*Y(fxi(nflag),:)+...
            (1-fxi(nflag)+xi(nflag)*ndx).*Y(fxi(nflag)+1,:);
end