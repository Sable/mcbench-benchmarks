% (this is just an interface)
function varargout = mydatesod_inv (varargin)
    [varargout{1:nargout}] = mydatesodi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatesod_inv(1, 2);



