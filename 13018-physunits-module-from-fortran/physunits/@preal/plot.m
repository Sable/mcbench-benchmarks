function h=plot(varargin)
%PREAL/PLOT  Overloaded plot function for class PREAL.

global useUnitsFlag

for k=1:length(varargin)
    if isa(varargin{k},'preal'), varargin{k}=double(varargin{k}); end
end
if nargout==0
    plot(varargin{:});
else
    h=plot(varargin{:});
end