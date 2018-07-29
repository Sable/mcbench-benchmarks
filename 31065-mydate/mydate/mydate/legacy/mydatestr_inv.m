% (this is just an interface)
function varargout = mydatestr_inv (varargin)
    [varargout{1:nargout}] = mydatestri (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatestr_inv('2000', 'YYYY');



