function varargout = interp1(varargin)
% bsarray/interp1: 1-D interpolation (table lookup)
% usage: YI = interp1(B,XI);
%    or: YI = interp1(B,XI,EXTRAPVAL);
%
% arguments:
%   B - bsarray object having tensorOrder 1. The positions of the
%       underlying data array are assumed to be X = s.*(1:N), where N is 
%       the number of data points (i.e., max(get(B,'dataSize'))), and s 
%       is the element spacing (i.e., get(B,'elementSpacing')).
%   XI - points at which to interpolate B.
%   EXTRAPVAL - value to return for points in XI that are outside the range
%       of X. Default EXTRAPVAL = NaN.
%
%   YI - the values of the underlying bsarray B evaluated at the points in
%       the array XI.
%

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

% parse input arguments
[b,xi,extrapval] = parseInputs(varargin{:});

% get flag to determine if basis functions are centred or shifted
m = double(get(b,'centred'));

% get number of data elements and coefficients, determine amount of padding
% that has been done to create coefficients
nData = max(get(b,'dataSize'));
n = max(get(b,'coeffsSize'));
padNum = (n-nData-1)/2;

% get the spacing between elements, and then construct vectors of the
% locations of the data and of the BSpline coefficients
h = get(b,'elementSpacing');
xCol = h.*((1-padNum):(nData+padNum+1))';
xDataCol = xCol((1+padNum):(end-padNum));

% turn evaluation points into a column vector, but retain original size so
% output can be returned in same size as input
siz_xi = size(xi);
xiCol = xi(:);
siz_yi = siz_xi;

% grab the BSpline coefficients
cMat = get(b,'coeffs');

% initialize some variables for use in interpolation
numelXi = length(xiCol);
yiMat = zeros(numelXi,1);
p = 1:numelXi;

% Find indices of subintervals, x(k) <= u < x(k+1),
% or u < x(1) or u >= x(m-1).
k = min(max(1+floor((xiCol-xCol(1))/h),1+padNum),n-padNum) + 1-m;
s = (xiCol - xCol(k))/h;

% perform interpolation
d = get(b,'degree');
for i=1:ceil((d+1)/2)
    yiMat(:) = yiMat(:) + cMat(k-i+m).*evalBSpline(s+i-(1+m)/2,d);
    yiMat(:) = yiMat(:) + cMat(k+i-1+m).*evalBSpline(s-i+(1-m)/2,d);
end
if ~m && mod(d,2)
    yiMat(:) = yiMat(:) + cMat(k-i-1).*evalBSpline(s+i+1/2,d);
end

% perform extrapolation
outOfBounds = xiCol<xDataCol(1) | xiCol>xDataCol(nData);
yiMat(p(outOfBounds)) = extrapval;

% reshape result to have same size as input xi
yi = reshape(yiMat,siz_yi);
varargout{1} = yi;


%% subfunction parseInputs
function [b,xi,extrapval] = parseInputs(varargin)

nargs = length(varargin);
error(nargchk(2,3,nargs));

% Process B
b = varargin{1};
if ~isequal(b.tensorOrder,1)
    error([mfilename,'parseInputs:WrongOrder'], ...
        'bsarray/interp1 can only be used with bsarray objects having tensor order 1.');
end

% Process XI
xi = varargin{2};
if ~isreal(xi)
    error([mfilename,'parseInputs:ComplexInterpPts'], ...
        'The interpolation points XI should be real.')
end

% Process EXTRAPVAL
if nargs > 2
    extrapval = varargin{3};
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
