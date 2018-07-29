% setLineStyle(obj, parameter, value ...)
%  Modifies the properties of the plotted line. The parameter-value
%  pairs are the same as those for LINE.
%
% Example:
%  d = dynamicplot(@() randn(1,100), 0.5);
%  setLineStyle(d, 'color', 'r', 'linewidth', 1, 'marker', 'o');

function setLineStyle(s, varargin)

s.checkValidity();

lh = s.getLineHandle();
set(lh, varargin{:});


