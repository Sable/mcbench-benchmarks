function y = upfilt(x, f, dim, extmod, shift)
% UPFILT   Upsample (by 2) and filter along a dimension
%
%       y = upfilt(x, f, dim, extmod, shift)
%
% Input:
%   x:      input signal
%   f:      1-D filter
%   dim:    the processing dimension
%   extmod: extension mode (e.g. 'per' or 'sym')
%   shift:  specifies the window over which filtering occurs
%
% Output:
%   y:      upsampled and filtered signal
%
% Note:
%   The origin of the filter f is assumed to be floor(size(f)/2) + 1.
%   Amount of shift should be no more than floor((size(f)-1)/2).

% Skip singleton dimension
if size(x, dim) == 1
    y = x;
    return
end

nd = ndims(x);
% Consider column vectors as 1-D signals 
if nd == 2 & size(x, 2) == 1
    nd = 1;
end

% Cell array of indexes for each dimension
I = cell(1, ndims(x));
for d = 1:ndims(x)
    I{d} = 1:size(x,d);
end

% Upsample (by 2)
sx = size(x);
sx(dim) = 2*sx(dim);
y = zeros(sx);
I{dim} = 1:2:sx(dim);
y(I{:}) = x;

% Border extend
n = size(y, dim);
hlf = (length(f) - 1) / 2;
% Amount of extension at two ends
e1 = floor(hlf) + shift;
e2 = ceil(hlf) - shift;

switch extmod
    case 'per'
        I{dim} = [ly-e1+1:n , 1:n , 1:e2];
        
    case 'sym'
        I{dim} = [e1+1:-1:2 , 1:n , n-1:-1:e2];
        
    otherwise
        error('Invalid input for EXTMOD')
        
end
y = y(I{:});
    
% Filter and return only the 'valid' part
y = filter(f, 1, y, [], dim);
    
I{dim} = (1:n) + length(f) - 1;
y = y(I{:});