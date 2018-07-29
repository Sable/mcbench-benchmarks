% (this is just an interface)
function varargout = mydatemjd_inv (varargin)
    [varargout{1:nargout}] = mydatemjdi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatemjd_inv(1);


