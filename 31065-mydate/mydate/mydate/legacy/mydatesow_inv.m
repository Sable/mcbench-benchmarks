% (this is just an interface)
function varargout = mydatesow_inv (varargin)
    [varargout{1:nargout}] = mydatesowi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatesow_inv(1, 2);



