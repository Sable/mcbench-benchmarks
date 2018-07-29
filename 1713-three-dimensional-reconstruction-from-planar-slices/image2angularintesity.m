function [RI, TI, ZI] = image2angularintesity(vi, I, params)
%This function transforms the image such that each set of pixels that radiate 
% out at a given angle from the centroid become a vertical line in a new image.

if nargin < 2
    params.number_angular_divisions = 2^6;
    params.number_radial_divisions  = 40;
end

if nargin < 3
    verbose = 0;
end

[num_rows, num_cols] = size(I);
[col_distance, row_distance] = meshgrid(linspace(-(num_cols) / 2 , (num_cols) / 2, num_cols),...
                                        linspace(-(num_rows) / 2 , (num_rows) / 2, num_rows));
[T, R] = cart2pol(col_distance, row_distance);

params.radius_min = sqrt(0.5);
params.radius_max = max(R(R < min(R(~vi))));
params.theta_min  = -pi + ((2 * pi) / params.number_angular_divisions) / 2;
params.theta_max  =  pi - ((2 * pi) / params.number_angular_divisions) / 2; 

radii  = linspace(params.radius_min, params.radius_max, params.number_radial_divisions);
thetas = linspace(params.theta_min , params.theta_max , params.number_angular_divisions);

[RI, TI, ZI] = griddata(R(vi), T(vi), double(I(vi)), radii, thetas');
 
ZI(isnan(ZI)) = mean(ZI(~isnan(ZI)));


if params.VERBOSE
    figure
    h = surf(RI, TI, ZI);
    view (-90,90)
    colormap(params.map)
    title('Image as a function of radius and angle')
    xlabel('Radius(pixels)')
    ylabel('Theta (radians)')
    set (h, 'linestyle', 'none')
end
% Copyright 2002 - 2009 The MathWorks, Inc.

