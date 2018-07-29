function h=loglog(varargin)
%PREAL/LOGLOG  Overloaded loglog function for class PREAL.

global useUnitsFlag

for k=1:length(varargin)
    if isa(varargin{k},'preal'), varargin{k}=double(varargin{k}); end
end
if nargout==0
    loglog(varargin{:});
else
    h=loglog(varargin{:});
end