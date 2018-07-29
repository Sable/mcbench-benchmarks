function fillfigure(ax)
%FILLFIGURE Reset axes position and limits to fill figure
%
%   FILLFIGURE(AX) resets the position of axes AX, and either its XLim or
%   its YLlim, so that AX completely fills its parent figure.  It also
%   turns off the axes visibility.  After calling FILLFIGURE, you can make
%   use of the entire window while zooming and panning an image.
%   FILLFIGURE does not set up any callbacks or listeners; if you resize
%   the figure you may have to call it again.
%
%   Example 1
%   ---------
%   % Display an image and make the axes limits match the data limits
%   h = image(imread('ngc6543a.jpg')); axis equal
%   set(gca, 'XLim', get(h,'XData') + [-0.5 0.5],...
%            'YLim', get(h,'YData') + [-0.5 0.5])
%
%   % Position the figure to use most of the screen
%   set(gcf, 'Position', get(0,'ScreenSize') + [10 60 -20 -150])
%
%   % Make the axes fill the figure
%   fillfigure(gca)
%
%   Example 2 (requires the Mapping Toolbox(TM))
%   ---------
%   % Display a GeoTIFF image of Boston, Mass. (image courtesy of GeoEye)
%   [map_X, map_cmap, map_R, bbox] = geotiffread('boston.tif');
%   mapshow(map_X, map_cmap, map_R);
%
%   % Elongate the figure top-to-bottom
%   s = get(0, 'ScreenSize');
%   pos = [s(1) s(2) s(3)/2 s(4)] + [10 60 -20 -150];
%   set(gcf, 'Position', pos )
%
%   % Make the axes fill the figure
%   fillfigure(gca)

% Written by: Rob Comer

% Copyright 2004-2009 The MathWorks, Inc.

% Get figure position in pixel units.
f = ancestor(ax,'figure');
old_units = get(f,'Units');
set(f,'Units','pixels');
p = get(f,'Position');
set(f,'Units',old_units)

% Set axes position to use entire figure.
old_units = get(f,'Units');
set(ax,'Units','normalized')
set(ax,'Position',[0 0 1 1])
set(ax,'Units',old_units)

% Turn off axes visibility
set(ax,'Visible','off')

% Reset either XLim or YLim
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
if p(4) * diff(xlim) < p(3) * diff(ylim)
    % Need to reset ylim
    dylim = diff(xlim) * p(4) / p(3);
    set(ax, 'YLim', mean(ylim) + dylim * [-0.5 0.5])
else
    % Need to reset xlim
    dxlim = diff(ylim) * p(3) / p(4);
    set(ax, 'XLim', mean(xlim) + dxlim * [-0.5 0.5])
end
