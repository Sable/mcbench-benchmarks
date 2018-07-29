function [x_data,y_data] = pixel2DataUnits(h_axes,x_pixel,y_pixel)
%pixel2DataUnits Converts pixel coordinates to data coordinates.
%    [X_DATA,Y_DATA] = pixel2DataUnits(H_AXES,X_PIXEL,Y_PIXEL)
%    converts the (X_PIXEL,Y_PIXEL) coordinates to data units (X_DATA,Y_DATA)

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/12/12 23:22:36 $

[dx_per_screen_pixel, dy_per_screen_pixel] = getAxesScale(h_axes);

x_data = x_pixel * dx_per_screen_pixel;
y_data = y_pixel * dy_per_screen_pixel;
