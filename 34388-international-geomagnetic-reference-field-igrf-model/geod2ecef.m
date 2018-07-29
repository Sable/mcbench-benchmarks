function [x, y, z] = geod2ecef(latitude, longitude, altitude)

% GEOD2ECEF Convert geodetic coordinates to ECEF coordinates.
% 
% Usage: [X, Y, Z] = GEOD2ECEF(LATITUDE, LONGITUDE, ALTITUDE)
%     or [X, Y, Z] = GEOD2ECEF(LLA)
%     or XYZ = GEOD2ECEF(LATITUDE, LONGITUDE, ALTITUDE)
%     or XYZ = GEOD2ECEF(LLA)
% 
% Converts geodetic coordinates LATITUDE, LONGITUDE, and ALTITUDE to
% Earth-centered, Earth fixed (ECEF) coordinates X, Y, and Z. The inputs
% can either be three separate arguments or 1 matrix. For a matrix input,
% the first dimension with length 3 is assumed to have the three separate
% LATITUDE, LONGITUDE, and ALTITUDE inputs across it. The World Geodetic
% System 1984 (WGS84) ellipsoid model of the Earth is assumed.
% 
% Inputs:
%   -LATITUDE: Geodetic latitude in degrees.
%   -LONGITUDE: Geodetic longitude in degrees.
%   -ALTITUDE: Height above the Earth in meters.
%   -LLA: Matrix with at least one dimension with length 3, the first of
%   which corresponding to the dimension across which the three inputs
%   above go.
% 
% Ouputs:
%   -X: x coordinates of the point in meters.
%   -Y: y coordinates of the point in meters.
%   -Z: z coordinates of the point in meters.
%   -XYZ: When just one output is requested, the three outputs above are
%   returned as a row vector for scalar inputs, an M-by-3 matrix for column
%   vector inputs, a 3-by-M matrix for row vector inputs, or the three
%   outputs concatenated either along the next largest dimension when the
%   inputs are separate arguments or the same dimension that the inputs
%   went across when a single matrix is input.
% 
% See also: LLA2ECEF, ECEF2GEOD.

% Input checking/conversion.
error(nargchk(1, 3, nargin));
if nargin == 1
    sizelatitude = size(latitude);
    first3 = find(sizelatitude == 3, 1, 'first');
    latitude = reshape(permute(latitude, [first3, 1:(first3 - 1), ...
        (first3 + 1):ndims(latitude)]), 3, []);
    sizelatitude(first3) = 1;
    longitude = reshape(latitude(2, :), sizelatitude);
    altitude = reshape(latitude(3, :), sizelatitude);
    latitude = reshape(latitude(1, :), sizelatitude);
end
latitude = latitude*pi/180; longitude = longitude*pi/180;

% WGS84 parameters.
a = 6378137; f = 1/298.257223563; b = a*(1 - f); e2 = 1 - (b/a)^2;

% Conversion from:
% en.wikipedia.org/wiki/Geodetic_system#Conversion_calculations
Nphi = a ./ sqrt(1 - e2*sin(latitude).^2);
x = (Nphi + altitude).*cos(latitude).*cos(longitude);
y = (Nphi + altitude).*cos(latitude).*sin(longitude);
z = (Nphi.*(1 - e2) + altitude).*sin(latitude);

% Shape output according to number of arguments.
if nargout <= 1
    if nargin == 1
        x = cat(first3, x, y, z);
    else
        dims = ndims(x);
        if dims == 2
            if size(x, 2) == 1
                x = [x, y, z];
            else
                x = [x; y; x];
            end
        else
            x = cat(dims + 1, x, y, z);
        end
    end
end