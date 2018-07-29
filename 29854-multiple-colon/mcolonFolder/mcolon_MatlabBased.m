function [a i] = mcolon(varargin)
% Multiple colons
%
% [a i] = MCOLON(i1, i2)
%
% INPUTS: i1, i2 arrays of the same size, respectively left and
%         right bracket
% OUTPUT: a = [ i1(1):i2(1) i1(2):i2(2) ... i1(end):i2(end) ]
%         i array same size than a, corresponding index in i1 and i2
%
% function [a i] = mcolon(i1, step, i2)
% step is applied to each colon ...  i1(j):step(j):i2(j) ...
% step can be a scalar, which is common for all intervals
%
% MCOLON(..., 'tol', tol) to adjust the relative floating point
% tolerance of the stepping error. The default tolerance is 1e-12.
%
% Note: Only single/double are supported
%
% See also: colon, mcolonops, mcolsettol
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 31-Dec-2010 correct casting bug with 'CHAR'
% Default tolerance

% Inquire the default tolerance
tol = mcolsettol();

argin = varargin;
tolidx = strcmpi('tol',argin);
if any(tolidx)
    % parse the tolerance in the arguments
    tolidx = find(tolidx,1,'first');
    if tolidx<length(argin)
        tol = argin{tolidx+1};
        argin(tolidx:end) = []; % delete the tail
    end
end

if length(argin)==2
    i1 = argin{1};
    i2 = argin{2};
    d = 1;
elseif length(argin)==3
    i1 = argin{1};
    d = argin{2};
    i2 = argin{3};
else
    error('mcolon: requires 2 or 3 inputs');
end

% reshape in column and cast them to the same type
[i1,d,i2] = castarrays(i1(:),d(:),i2(:));

% lengths of intervals, class <double>
lext = (double(i2)-double(i1))./double(d); % use double to avoid overflow
l = floor(lext)+1;
l = max(l,0);

% Adjust the length for lext almost equal to ceil(lext) for
% floating point error with certain tolerance 'tol'
% similar to Matlab COLON behavior
if isfloat(d) && tol>0 && ~isequal(d,1)
    adjusted = lext > l.*(1-tol);
    if any(adjusted)
        if isscalar(d)
            d = d + zeros(size(l),class(d));
        end
        d(adjusted) = (i2(adjusted)-i1(adjusted))./l(adjusted);
        l(adjusted) = l(adjusted)+1;
    end
end

warning('mcolon:mexnotinstalled', 'Please install using mcolon_install.m');

csl = cumsum([1; l]); % (m+1) x 1

n = csl(end)-1; % == sum(l)

b = l>0; % m x 1, sum(b)==p
i1 = i1(b); % p x 1

% array of steps
if isscalar(d)
    if ~ischar(d)
        s = d + zeros(n,1,class(d)); % n x 1
    else
        s = d + zeros(n,1,'int16'); % n x 1
    end
else
    d = d(b); % p x 1
    s = accumarray(csl(b),[d(1); diff(d)],[n 1]); % n x 1
    s = cumsum(s); % n x 1
end

% right bound
ib = csl(b);
i2 = i1+(l(b)-1).*d; % p x 1
b = [false; b];
ie = csl(b)-1;
b(1) = true;
lastint = find(b,1,'last');
b(lastint) = false;
% set the jump beween two consecutive intervales
s(csl(b)) = i1-[0; i2(1:end-1)]; % assign p elements
a = cumsum(s);
% force the final points equal to bracket values
a(ib) = i1;
a(ie) = i2;

% reshape in row
a = reshape(a,1,[]);

if nargout>=2
    if n>0
        csl(lastint:end) = [];
        i = cumsum(accumarray(csl,1,[n 1])); % n x 1
        i = reshape(i,1,[]);
    else
        i = zeros(0,1);
    end
end

end % mcolon
