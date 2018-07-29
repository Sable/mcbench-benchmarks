function DB = partial(varargin)
% bsarray\partial: compute partial derivative from B-Spline coefficients
% usage: DB = partial(B);
%    or: DB = partial(B,DIM);
%
% arguments:
%   B - bsarray object
%   DIM (scalar) - dimension along which partial derivative is computed
%       Default DIM == 1
%
%   DB - bsarray object corresponding to the partial deriviatve along the
%       DIM dimension of the array whose B-Spline coefficients are given 
%       in B.
%
%   Note: If DIM is a nonsingleton dimension of B, then DB will contain
%   zeros everywhere.
%

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

% parse inputs
[B,DIM] = parseInputs(varargin{:});

% copy B into output
DB = B;

% if DIM refers to a singleton dimension of B, return zeros
if B.dataSize(DIM)==1
    DB.coeffs = zeros(B.coeffsSize);
    DB.degree(DIM) = max(DB.degree(DIM)-1,0);
    return;
end

% if degree along DIM dimension is already zero, return zeros
if ((B.tensorOrder>1)&&(DB.degree(DIM)==0)) || ((B.tensorOrder==1)&&(DB.degree==0))
    DB.coeffs = zeros(B.coeffsSize);
    return;
end

% construct differentiation filter of [-1 1] along DIM dimension
F = shiftdim([1;-1],1-DIM);

% convolve BSpline coefficients with differentiation filter
DB.coeffs = convn(B.coeffs,F,'same');

% divide by element spacing, flip centred flag, and reduce degree of output
% bsarray in DIM dimension
if B.tensorOrder>1
    DB.coeffs = DB.coeffs./DB.elementSpacing(DIM);
    CFlag = DB.centred(DIM);
    DB.centred(DIM) = ~CFlag;
    DB.degree(DIM) = max(DB.degree(DIM)-1,0);
else
    DB.coeffs = DB.coeffs./DB.elementSpacing;
    CFlag = DB.centred;
    DB.centred = ~CFlag;
    DB.degree = max(DB.degree-1,0);
end

% remove padded dimensions
padNum = zeros(ndims(B.coeffs));
padNum(DIM) = 1;
numDims = B.tensorOrder;
idx = cell(1,numDims);
if CFlag
    for k=1:numDims
        idx{k} = 1:size(DB.coeffs,k);
    end
else
    for k=1:numDims
        idx{k} = 1:(size(DB.coeffs,k)-2*padNum(k));
    end    
end
DB.coeffs = DB.coeffs(idx{:});
DB.coeffsSize = size(DB.coeffs);

%% subfunction parseInputs
function [B,DIM] = parseInputs(varargin)

% check number of inputs
nargs = length(varargin);
error(nargchk(1,2,nargs));

% get, check B
B = varargin{1};
if ~isa(B,'bsarray')
    error([mfilename,'parseInputs:InvalidInput'],...
        'B must be a bsarray object');
end

% get, check DIM
if nargs<2
    DIM = [];
else
    DIM = varargin{2};
end
if isempty(DIM)
    DIM = 1;
end
if ~isscalar(DIM) || DIM<1 || ~isequal(DIM,round(DIM))
    error([mfilename,'parseInputs:InvalidDIM'],...
        'DIM must be an integer greater than or equal to 1.');
end