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
% See also: colon, mcolonops, mcolsettol
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 31-Dec-2010 correct casting bug with 'CHAR'

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

b = l>0; % m x 1, sum(b)==p
i1 = i1(b);
if isscalar(d)
    % expand d with the same size as i1
    dval = d;
    d = i1;
    d(:) = dval; % n x 1
else
    d = d(b);
end
l = l(b);
a =  mcolonmex(i1,d,l);
if nargout>=2
    i = mcolonmex(find(b),zeros(size(l),'double'),l); % n x 1
end

end % mcolon
