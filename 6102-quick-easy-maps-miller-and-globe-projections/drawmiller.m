% DRAWMILLER - Plots a flat map of the world
%
% USAGE: drawmiller
%        drawmiller(lon)
%
% lon = optional longitude of the map center (default is zero)
%
% Notes: This is a miller cylindrical projection, which is pleasant
%        to view while having a convenient rectangular map shape.
%
% Michael Kleder, October 2004

function drawmiller(varargin)
if nargin > 0
    lon = varargin{1};
else
    lon = 0;
end
figure
axesm miller
setm(gca,'origin',[0 lon])
h=displaym(worldlo('POline'));
gridm
set(h,'color',[.3 .3 .3])
tightmap