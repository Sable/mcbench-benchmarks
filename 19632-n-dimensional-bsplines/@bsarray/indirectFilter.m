function X = indirectFilter(b)
% bsarray\indirectFilter: compute image/volume data from B-spline coefficients
% usage: X = indirectFilter(b);
%
% arguments: 
%   b - bsarray object
%
%   X - corresponding vector/image/volume data
%

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

% if D = 0 for all dimensions with shifted basis functions, and D = 0 or 1
% for all dimensions with centred basis functions, copy coefficients 
% directly into output
if all((b.degree-double(b.centred))<1)
    X = b.coeffs;
    padNum = floor((b.degree+double(b.centred)-1)/2);
    numDims = numel(padNum);
    idx = cell(1,numDims);
    for k=1:numDims
        idx{k} = 1:(size(X,k)-1);
    end
    X = X(idx{:});
    return;
end

% get coefficients for BSpline filters
F = cell(b.tensorOrder,1);
for i=1:b.tensorOrder
    F{i} = getBSplineFiltCoeffs(b.degree(i),b.centred(i),'indirect');
end

% construct full filter
Ffull = F{1};
for i=2:b.tensorOrder
    Ffull = convn(Ffull,shiftdim(F{i},1-i));
end

% filter BSpline coefficients
X = convn(b.coeffs,Ffull,'same');

% now remove padded elements
padNum = floor((b.degree+double(b.centred)-1)/2);
numDims = numel(padNum);
idx = cell(1,numDims);
for k=1:numDims
    idx{k} = (1+padNum(k)):(size(X,k)-padNum(k)-1);
end
X = X(idx{:});

% remove last element from any dimensions with shifted basis functions
for k=1:numDims
    if b.centred(k)
        idx{k} = 1:size(X,k);
    else
        idx{k} = 1:(size(X,k)-2);
    end
end
X = X(idx{:});
