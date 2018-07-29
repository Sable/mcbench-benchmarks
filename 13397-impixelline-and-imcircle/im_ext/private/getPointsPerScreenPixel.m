function points_per_screen_pixel = getPointsPerScreenPixel
%getPointsPerScreenPixel Returns points per screen pixel.
%   POINTS_PER_SCREEN_PIXEL = getPointsPerScreenPixel returns the number of
%   points per screen pixel.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/05/27 14:07:19 $
  
points_per_inch = 72;
pixels_per_inch = get(0, 'ScreenPixelsPerInch');

points_per_screen_pixel = points_per_inch / pixels_per_inch;

