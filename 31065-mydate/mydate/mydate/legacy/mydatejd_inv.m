% (this is just an interface)
function varargout = mydatejd_inv (varargin)
    [varargout{1:nargout}] = mydatejdi (varargin{:});
end

%!test
%! % just check whether it runs:
%! mydatejd_inv(1);



