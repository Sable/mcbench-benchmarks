function [Xs, Ys] = Spherical2AzimuthalEquidistant(latsInDegrees, ...
                    longsInDegrees, centerLatInDegrees, centerLongInDegrees, ...
                    centerX, centerY, radius)
% Projects latitudes and longitudes onto an azimuthal equidistant image.
% Converts the given latitudes and longitudes into x and y values suitable for
% plotting on an azimuthal equidistant projection centered on the given latitude
% and longitude.  centerX is the x-coordinate at which to plot the center point,
% and centerY is the y-coordinate at which to plot the center point.  radius is
% the radius of the projection.
% 
%    usage: [Xs, Ys] = Spherical2AzimuthalEquidistant(latsInDegrees, ...
%                        longsInDegrees, centerLatInDegrees, ...
%                        centerLongInDegrees, centerX, centerY, radius)
    
    cosLats = cosd(latsInDegrees);
    sinLats = sind(latsInDegrees);
    
    cosCLat = cosd(centerLatInDegrees);
    sinCLat = sind(centerLatInDegrees);
    
    dLongsInDegrees = longsInDegrees - centerLongInDegrees;
    
    Js = cosLats .* cosd(dLongsInDegrees);
    
    cosCs = (sinCLat * sinLats) + (cosCLat * Js);
    
    Cs = acos(cosCs);
    % C = the distance of the projection from the center of the plot on a scale
    % from 0 to pi.  Mathematically, C = realsqrt((x .^ 2) + (y .^ 2)).
    
    sinCs = realsqrt(1 - (cosCs .^ 2));
    
    Ks = Cs ./ sinCs;
    % The cases in which sin(C) = 0 will be handled later in the function.
    
    % The values calculated so far are simply intermediary expressions in the
    % computation.
    
    unscaledXs = Ks .* (cosLats .* sind(dLongsInDegrees));
    unscaledYs = Ks .* ((cosCLat * sinLats) - (sinCLat * Js));
    % Produces values scaled from -pi to +pi, with x = 0, y = 0 in the middle of
    % the projection.
    
    specialCases = find(AreBadValues(Ks));
    % Collect indices of cases for which division by 0 occurred.
    
    centers = specialCases(Cs(specialCases) < (pi / 2));
    % Collect indices of special cases for which the point is closer to the
    % center of the projection than the rim.
    
    unscaledXs(centers) = 0;
    unscaledYs(centers) = 0;
    % These indices correspond to the special case in which the point to plot is
    % at the center of the projection, x = 0, y = 0.
    
    antipodes = setdiff(specialCases, centers);
    % Collect the indices of special cases for which the point is closer to the
    % rim of the projection than the center.  By definition, these are all the
    % remaining special cases.
    
    unscaledXs(antipodes) = pi;
    unscaledYs(antipodes) = 0;
    % These indices correspond to the case in which the point to plot the
    % antipode of the point at the center of the projection.  The azimuthal
    % equidistant projection does not project the antipode to any single point,
    % but rather the circle of radius pi that comprises the outer rim of the
    % projection.  The right-most point on this circle is arbitrarily declared
    % to be the anitpode.  Note that this is not necessarily consistent with the
    % arbitrary convention in the function GeodesicMidpoints for selecting a
    % geodesic midpoint between a point and its antipode.
    
    scalingFactor = radius / pi;
    % Determine the factor by which to stretch the projection, which has a
    % radius of pi by default.
    
    Xs = (scalingFactor * unscaledXs) + centerX;
    Ys = (scalingFactor * unscaledYs) + centerY;
    % Scales the projection as the user requested.
    
end