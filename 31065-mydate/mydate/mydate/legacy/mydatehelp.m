% (this is just an interface)
function varargout = mydatehelp (varargin)
    [varargout{1:nargout}] = mydatestd_aux (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatehelp(1);

