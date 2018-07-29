function varargout = interp2(varargin)
% bsarray/interp2: 2-D interpolation (table lookup)
% usage: ZI = interp2(B,XI,YI);
%    or: ZI = interp2(B,XI,YI,EXTRAPVAL);
%
% arguments:
%   B - bsarray object having tensorOrder 2. The positions of the
%       x-coordinates of the underlying data array are assumed to be 
%       X = s(2).*(1:Nx), where Nx is the number of data points in the X 
%       dimension (i.e., second element of get(B,'dataSize')), and s 
%       is the element spacing (i.e., get(B,'elementSpacing')). The
%       positions of the y-coordinates of the underlying data array are
%       assumed to be Y = s(1).*(1:Ny).
%   XI - x-coordinates of points at which to interpolate B.
%   YI - y-coordinates of points at which to interpolate B. YI must be the
%       same size as XI.
%
%   EXTRAPVAL - value to return for points in XI and YI that are outside 
%       the range of X and Y, respectively. Default EXTRAPVAL = NaN.
%
%   ZI - the values of the underlying bsarray B evaluated at the points in
%       the array XI.
%

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

% parse input arguments
[b,xi,yi,extrapval] = parseInputs(varargin{:});

% get flag to determine if basis functions in each dimension are centred or
% shifted
m = double(get(b,'centred'));
mx = m(2); my = m(1);

% get number of data elements and coefficients, determine amount of padding
% that has been done to create coefficients
nData = get(b,'dataSize'); nDatax = nData(2); nDatay = nData(1);
n = get(b,'coeffsSize'); nx = n(2); ny = n(1);
padNum = (n-nData-1)/2; padNumx = padNum(2); padNumy = padNum(1);

% get the spacing between elements, and then construct vectors of the
% locations of the data and of the BSpline coefficients
h = get(b,'elementSpacing'); hx = h(2); hy = h(1);
xCol = hx.*((1-padNumx):(nDatax+padNumx+1))';
xDataCol = xCol((1+padNumx):(end-padNumx));
yCol = hy.*((1-padNumy):(nDatay+padNumy+1))';
yDataCol = yCol((1+padNumy):(end-padNumy));

% turn evaluation points into a column vector, but retain original size so
% output can be returned in same size as input
siz_xi = size(xi);
siz_zi = siz_xi;

% grab the BSpline coefficients
cMat = get(b,'coeffs');

% initialize some variables for use in interpolation
numelXi = numel(xi);
ziMat = zeros(numelXi,1);
p = 1:numelXi;

% Find indices of subintervals, x(k) <= u < x(k+1),
% or u < x(1) or u >= x(m-1).
kx = min(max(1+floor((xi(:)-xCol(1))/hx),1+padNumx),nx-padNumx) + 1-mx;
ky = min(max(1+floor((yi(:)-yCol(1))/hy),1+padNumy),ny-padNumy) + 1-my;
sx = (xi(:) - xCol(kx))/hx;
sy = (yi(:) - yCol(ky))/hy;

% perform interpolation
d = get(b,'degree'); dx = d(2); dy = d(1);
xflag = (~mx && mod(dx,2));
yflag = (~my && mod(dy,2));
for j=1:ceil((dx+1)/2) % loop over BSpline degree in x dimension
    Bx1 = evalBSpline(sx+j-(1+mx)/2,dx);
    Bx2 = evalBSpline(sx-j+(1-mx)/2,dx);
    for i=1:ceil((dy+1)/2) % loop over BSpline degree in y dimension
        By1 = evalBSpline(sy+i-(1+my)/2,dy);
        By2 = evalBSpline(sy-i+(1-my)/2,dy);
        for ind = 1:numelXi % loop over evaluation points, computing interpolated value
            ziMat(ind) = ziMat(ind) + cMat(ky(ind)-i+my,kx(ind)-j+mx).*By1(ind).*Bx1(ind) + ...
                cMat(ky(ind)+i-1+my,kx(ind)-j+mx).*By2(ind).*Bx1(ind) + ...
                cMat(ky(ind)-i+my,kx(ind)+j-1+mx).*By1(ind).*Bx2(ind) + ...
                cMat(ky(ind)+i-1+my,kx(ind)+j-1+mx).*By2(ind).*Bx2(ind);
        end
    end
    if yflag % add a correction factor if BSpline in y direction is shifted and of odd degree 
        By1 = evalBSpline(sy+i+1/2,dy);
        for ind = 1:numelXi
            ziMat(ind) = ziMat(ind) + By1(ind).*...
                (cMat(ky(ind)-i-1,kx(ind)-j+mx).*Bx1(ind) + cMat(ky(ind)-i-1,kx(ind)+j-1+mx).*Bx2(ind));
        end
    end
end
if xflag % add a correction factor if BSpline in x direction is shifted and of odd degree
    Bx1 = evalBSpline(sx+j+1/2,dx);
    for i=1:ceil((dy+1)/2)
        By1 = evalBSpline(sy+i-(1+my)/2,dy);
        By2 = evalBSpline(sy-i+(1-my)/2,dy);
        for ind = 1:numelXi
            ziMat(ind) = ziMat(ind) + Bx1(ind).*...
                (cMat(ky(ind)-i+my,kx(ind)-j-1).*By1(ind) + cMat(ky(ind)+i-1+my,kx(ind)-j-1).*By2(ind));
        end
    end
end

% perform extrapolation
outOfBounds = xi(:)<xDataCol(1) | xi(:)>xDataCol(nDatax) | yi(:)<yDataCol(1) | yi(:)>yDataCol(nDatay);
ziMat(p(outOfBounds)) = extrapval;

% reshape result to have same size as input xi
zi = reshape(ziMat,siz_zi);
varargout{1} = zi;


%% subfunction parseInputs
function [b,xi,yi,extrapval] = parseInputs(varargin)

nargs = length(varargin);
error(nargchk(3,4,nargs));

% Process B
b = varargin{1};
if ~isequal(b.tensorOrder,2)
    error([mfilename,'parseInputs:WrongOrder'], ...
        'bsarray/interp2 can only be used with bsarray objects having tensor order 2.');
end

% Process XI
xi = varargin{2};
if ~isreal(xi)
    error([mfilename,'parseInputs:ComplexInterpPts'], ...
        'The interpolation points XI should be real.')
end

% Process YI
yi = varargin{3};
if ~isreal(yi)
    error([mfilename,'parseInputs:ComplexInterpPts'], ...
        'The interpolation points YI should be real.')
end
if ~isequal(size(xi),size(yi))
    error([mfilename,'parseInputs:YIXINotSameSize'], ...
        'YI must be the same size as XI');
end

% Process EXTRAPVAL
if nargs > 3
    extrapval = varargin{4};
else
    extrapval = [];
end
if isempty(extrapval)
    extrapval = NaN;
end
if ~isscalar(extrapval)
    error([mfilename,':NonScalarExtrapValue'],...
        'EXTRAP option must be a scalar.')
end
