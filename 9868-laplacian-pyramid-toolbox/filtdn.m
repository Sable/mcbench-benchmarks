function y = filtdn(x, f, dim, extmod, shift)
% FILTDN   Filter and downsample (by 2) along a dimension
%
%       y = filtdn(x, f, dim, extmod, shift)
%
% Input:
%   x:      input signal
%   f:      1-D filter
%   dim:    the processing dimension
%   extmod: extension mode (e.g. 'per' or 'sym')
%   shift:  specifies the window over which filtering occurs
%
% Output:
%   y:      filtered and dowsampled signal
%
% Note:
%   The origin of the filter f is assumed to be floor(size(f)/2) + 1.
%   Amount of shift should be no more than floor((size(f)-1)/2).

% Skip singleton dimension
if size(x, dim) == 1    
    y = x;
    return
end

% Cell array of indexes for each dimension
nd = ndims(x);
I = cell(1, nd);
for d = 1:nd
    I{d} = 1:size(x,d);
end

% Border extend
n = size(x, dim);
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
y = x(I{:});
    
% Filter, downsample, and return only the 'valid' part
y = filter(f, 1, y, [], dim);
    
I{dim} = (1:2:n) + length(f) - 1;
y = y(I{:});