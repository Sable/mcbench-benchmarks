function [latitude, longitude, altitude] = ecef2geod(x, y, z, tol)

% ECEF2GEOD Convert ECEF coordinates to geodetic coordinates.
% 
% Usage: [LATITUDE, LONGITUDE, ALTITUDE] = ECEF2GEOD(X, Y, Z, TOL)
%     or [LATITUDE, LONGITUDE, ALTITUDE] = ECEF2GEOD(XYZ, TOL)
%     or LLA = ECEF2GEOD(X, Y, Z, TOL)
%     or LLA = ECEF2GEOD(XYZ, TOL)
% 
% Converts Earth-centered, Earth fixed (ECEF) coordinates X, Y, and Z to
% geodetic coordinates LATITUDE, LONGITUDE, and ALTITUDE. For a matrix
% input, the first dimension with length 3 is assumed to have the three
% separate X, Y, and Z inputs across it. The World Geodetic System 1984
% (WGS84) ellipsoid model of the Earth is assumed.
% 
% Inputs:
%   -X: x coordinates of the point in meters.
%   -Y: y coordinates of the point in meters.
%   -Z: z coordinates of the point in meters.
%   -TOL: Maximum error tolerance in the latitude in radians (optional,
%   default is 1e-12).
%   -XYZ: Matrix with at least one dimension with length 3, the first of
%   which corresponding to the dimension across which the three inputs
%   above go.
% 
% Ouputs:
%   -LATITUDE: Geodetic latitude in degrees.
%   -LONGITUDE: Geodetic longitude in degrees.
%   -ALTITUDE: Height above the Earth in meters.
%   -LLA: When just one output is requested, the three outputs above are
%   returned as a row vector for scalar inputs, an M-by-3 matrix for column
%   vector inputs, a 3-by-M matrix for row vector inputs, or the three
%   outputs concatenated either along the next largest dimension when the
%   inputs are separate arguments or the same dimension that the inputs
%   went across when a single matrix is input.
% 
% See also: ECEF2LLA, GEOD2ECEF.

% Input checking.
if nargin <= 2
    error(nargchk(1, 2, nargin));
    if nargin == 1
        tol = [];
    else
        tol = y;
    end
    sizex = size(x); first3 = find(sizex == 3, 1, 'first');
    x = reshape(permute(x, [first3, 1:(first3 - 1), ...
        (first3 + 1):ndims(x)]), 3, []);
    sizex(first3) = 1;
    y = reshape(x(2, :), sizex);
    z = reshape(x(3, :), sizex);
    x = reshape(x(1, :), sizex);
else
    error(nargchk(3, 4, nargin));
end
if nargin <= 3 || isempty(tol)
    tol = 1e-12;
end

% WGS84 parameters.
a = 6378137; f = 1/298.257223563; b = a*(1 - f); e2 = 1 - (b/a)^2;

% Longitude is easy:
longitude = atan2(y, x)*180/pi;

% Compute latitude recursively.
rd = hypot(x, y);
[latitude, Nphi] = recur(asin(z ./ hypot(x, hypot(y, z))), z, a, e2, ...
    rd, tol, 1);
sinlat = sin(latitude); coslat = cos(latitude); latitude = latitude*180/pi;

% Get altitude from latitude.
altitude = rd.*coslat + (z + e2*Nphi.*sinlat).*sinlat - Nphi;

% Shape output according to number of arguments.
if nargout <= 1
    if nargin <= 2
        latitude = cat(first3, latitude, longitude, altitude);
    else
        dims = ndims(latitude);
        if dims == 2
            if size(latitude, 2) == 1
                latitude = [latitude, longitude, altitude];
            else
                latitude = [latitude; longitude; latitude];
            end
        else
            latitude = cat(dims + 1, latitude, longitude, altitude);
        end
    end
end

function [latitude, Nphi] = recur(lat_in, z, a, e2, rd, tol, iter)
thisNphi = a ./ sqrt(1 - e2*sin(lat_in).^2);
nextlat = atan((z + thisNphi*e2.*sin(lat_in))./rd);
if all(abs(lat_in - nextlat) < tol) || iter > 100
    latitude = nextlat; Nphi = thisNphi;
else
    [latitude, Nphi] = recur(nextlat, z, a, e2, rd, tol, iter + 1);
end