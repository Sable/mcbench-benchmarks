function [dx_per_screen_pixel, dy_per_screen_pixel] = getAxesScale(h_axes)
%getAxesScale Returns x and y axes scale in data units per screen pixels.
%   [DX_PER_SCREEN_PIXEL, DY_PER_SCREEN_PIXEL] = getAxesScale(HAXES) computes the
%   data units per screen pixel for both the x and y directions.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/06/20 03:10:21 $
  
axes_position = hgconvertunits(iptancestor(h_axes, 'figure'), ...
                               get(h_axes, 'Position'), ...
                               get(h_axes, 'Units'), ...
                               'pixels', ...
                               get(h_axes, 'Parent'));

axes_width  = axes_position(3);
axes_height = axes_position(4);

x_limits = get(h_axes, 'XLim');
y_limits = get(h_axes, 'YLim');

if axes_width <= 1
  % Degenerate case; return 1 (arbitrary choice).
  dx_per_screen_pixel = 1;
else
  dx_per_screen_pixel = (x_limits(2) - x_limits(1)) / axes_width;
end

if axes_height <= 1
  % Degenerate case; return 1 (arbitrary choice).
  dy_per_screen_pixel = 1;
else
  dy_per_screen_pixel = (y_limits(2) - y_limits(1)) / axes_height;
end
