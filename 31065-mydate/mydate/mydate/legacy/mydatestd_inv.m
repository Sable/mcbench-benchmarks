% (this is just an interface)
function varargout = mydatestd_inv (varargin)
    [varargout{1:nargout}] = mydatestdi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatestd_inv(1, 2);



