function h=semilogx(varargin)
%PREAL/PLOT  Overloaded semilogx function for class PREAL.

global useUnitsFlag

for k=1:length(varargin)
    if isa(varargin{k},'preal'), varargin{k}=double(varargin{k}); end
end
if nargout==0
    semilogx(varargin{:});
else
    h=semilogx(varargin{:});
end