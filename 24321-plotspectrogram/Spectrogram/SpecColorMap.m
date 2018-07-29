function cm = SpecColorMap (m, Colors)
% Spectrogram colour map with m elements.
% cm = SpecColorMap ([m [,Colors]])
% m - Number of colours. The default number of colours is is taken from the
%     current colour map.
% Colors - Nc by 3 array of colours. The first colour is for the lowest
%     intensity; the last colour is for the highest intensity. The
%     intermediate colours are equally spaced in the color map. The
%     colormap is interpolated (in the RGB domain) between these equally
%     spaced colors.
%
% If the Colors array is not specified, three colors are used,
%   Background colour: light yellow [1 1   0.85]
%   Mid colour:        mid red      [1 0.3 0.3 ]
%   Highlight colour:  black        [0 0.4 0   ]
% These values give a gray level spectrogram on non-colour printers, while
% retaining colour for colour printers.

% $Id: SpecColorMap.m,v 1.3 2008/11/05 19:59:37 pkabal Exp $

if (nargin < 1)
  m = size(get(gcf,'colormap'),1);
end

% Colours
if (nargin < 2)
  LightYellow = [1 1 0.85];
  MidRed = [1 0.3 0.3];
  Black = [0 0 0];
  Colors = [LightYellow; MidRed; Black];
end

% Colour positions in the colour bar (equally spaced on 0 to 1)
NC = size(Colors, 1);
P = linspace(0, 1, NC);

% Interpolate the colours (piecewise cubic interpolation)
% The cubic interpolation can (in some cases) create RGB components
% larger than one. If so, revert to linear interpolation.
xi = linspace(0, 1, m);
cm = interp1(P, Colors, xi, 'pchip');
if (any (cm > 1))
  cm = interp1(P, Colors, xi, 'linear');
end

% Grey scale for testing
%g = sum (cm, 2) / 3;
%cm = [g g g];

return
