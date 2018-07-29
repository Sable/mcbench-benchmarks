function h=semilogy(varargin)
%PREAL/PLOT  Overloaded semilogy function for class PREAL.

global useUnitsFlag

for k=1:length(varargin)
    if isa(varargin{k},'preal'), varargin{k}=double(varargin{k}); end
end
if nargout==0
    semilogy(varargin{:});
else
    h=semilogy(varargin{:});
end