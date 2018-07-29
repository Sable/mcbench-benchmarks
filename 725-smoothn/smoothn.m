function Y = smoothn(X,sz,filt,std)

%SMOOTHN Smooth N-D data
%   Y = SMOOTHN(X, SIZE) smooths input data X. The smoothed data is
%       retuirned in Y. SIZE sets the size of the convolution kernel
%       such that LENGTH(SIZE) = NDIMS(X)
%
%   Y = SMOOTHN(X, SIZE, FILTER) Filter can be 'gaussian' or 'box' (default)
%       and determines the convolution kernel.
%
%   Y = SMOOTHN(X, SIZE, FILTER, STD) STD is a vector of standard deviations 
%       one for each dimension, when filter is 'gaussian' (default is 0.65)

%     $Author: ganil $
%     $Date: 2001/09/17 18:54:39 $
%     $Revision: 1.1 $
%     $State: Exp $

if nargin == 2,
  filt = 'b';
elseif nargin == 3,
  std = 0.65;
elseif nargin>4 | nargin<2
  error('Wrong number of input arguments.');
end

% check the correctness of sz
if ndims(sz) > 2 | min(size(sz)) ~= 1
  error('SIZE must be a vector');
elseif length(sz) == 1
  sz = repmat(sz,ndims(X));
elseif ndims(X) ~= length(sz)
  error('SIZE must be a vector of length equal to the dimensionality of X');
end

% check the correctness of std
if filt(1) == 'g'
  if length(std) == 1
    std = std*ones(ndims(X),1);
  elseif ndims(X) ~= length(std)
    error('STD must be a vector of length equal to the dimensionality of X');
  end
  std = std(:)';
end

sz = sz(:)';

% check for appropriate size
padSize = (sz-1)/2;
if ~isequal(padSize, floor(padSize)) | any(padSize<0)
  error('All elements of SIZE must be odd integers >= 1.');
end

% generate the convolution kernel based on the choice of the filter
filt = lower(filt);
if (filt(1) == 'b')
  smooth = ones(sz)/prod(sz); % box filter in N-D
elseif (filt(1) == 'g')
  smooth = ndgaussian(padSize,std); % a gaussian filter in N-D
else
  error('Unknown filter');
end


% pad the data
X = padreplicate(X,padSize);

% perform the convolution
Y = convn(X,smooth,'valid');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = ndgaussian(siz,std)

% Calculate a non-symmetric ND gaussian. Note that STD is scaled to the
% sizes in SIZ as STD = STD.*SIZ


ndim = length(siz);
sizd = cell(ndim,1);

for i = 1:ndim
  sizd{i} = -siz(i):siz(i);
end

grid = gridnd(sizd);
std = reshape(std.*siz,[ones(1,ndim) ndim]);
std(find(siz==0)) = 1; % no smoothing along these dimensions as siz = 0
std = repmat(std,2*siz+1);


h = exp(-sum((grid.*grid)./(2*std.*std),ndim+1));
h = h/sum(h(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function argout = gridnd(argin)

% exactly the same as ndgrid but it accepts only one input argument of 
% type cell and a single output array

nin = length(argin);
nout = nin;

for i=nin:-1:1,
  argin{i} = full(argin{i}); % Make sure everything is full
  siz(i) = prod(size(argin{i}));
end
if length(siz)<nout, siz = [siz ones(1,nout-length(siz))]; end

argout = [];
for i=1:nout,
  x = argin{i}(:); % Extract and reshape as a vector.
  s = siz; s(i) = []; % Remove i-th dimension
  x = reshape(x(:,ones(1,prod(s))),[length(x) s]); % Expand x
  x = permute(x,[2:i 1 i+1:nout]);% Permute to i'th dimension
  argout = cat(nin+1,argout,x);% Concatenate to the output 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function b=padreplicate(a, padSize)
%Pad an array by replicating values.
numDims = length(padSize);
idx = cell(numDims,1);
for k = 1:numDims
  M = size(a,k);
  onesVector = ones(1,padSize(k));
  idx{k} = [onesVector 1:M M*onesVector];
end

b = a(idx{:});

