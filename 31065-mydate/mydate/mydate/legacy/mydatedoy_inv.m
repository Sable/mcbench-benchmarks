% (this is just an interface)
function varargout = mydatedoy_inv (varargin)
    [varargout{1:nargout}] = mydatedoyi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatedoy_inv(1, 2);


