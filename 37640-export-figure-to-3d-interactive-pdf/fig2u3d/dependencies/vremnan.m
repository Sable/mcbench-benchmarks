function [x] = vremnan(x, dim)
% dim = 1 removes column vectors
% dim = 2 removes row vectors
%
% See also isnan, any.
%
% File:      vremnan.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.05.11
% Language:  MATLAB R2012a
% Purpose:   trim columns which contain at least one NaN element
% Copyright: Ioannis Filippidis, 2012-

% DIM
szx = size(x);
if nargin == 1 || isempty(dim)
    dim = 1;
    
    % First non singleton dimension
    %dim = find(szx ~= 1, 1, 'first');
elseif ~(isnumeric(dim) && (dim > 0) && (rem(dim, 1) == 0) ) || (dim > numel(szx) )
    error('vremnan:fmtDim', 'DIM should be a scalar positive integer <= ndims(x)');
end

bad_elements = isnan(x);
bad_columns = any(bad_elements, dim);
bad_columns = ~bad_columns;

switch dim
    case 1
        x = x(:, bad_columns);
    case 2
        x = x(bad_columns, :);
    otherwise
        error('vremnan:dim', 'Dim > 2 is not implemented.')
end
