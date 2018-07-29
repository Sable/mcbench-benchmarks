function [latitude, longitude, altitude] = igrfline(time, lat_start, ...
    lon_start, alt_start, coord, distance, nsteps)

% IGRFLINE Trace IGRF magnetic field line.
% 
% Usage: [LATITUDE, LONGITUDE, ALTITUDE] = IGRFLINE(TIME, LAT_START,
%           LON_START, ALT_START, COORD, DISTANCE, NSTEPS)
%     or LLA = IGRFLINE(...)
% 
% Gives the coordinates of the magnetic field line starting at a given
% latitude, longitude, and altitude. A total of NSTEPS points on the field
% line over a distance DISTANCE are given. Note that the step length
% (DISTANCE/NSTEPS) should be small (the smaller it is, the more accurate
% the results will be). The output coordinates are NSTEPS+1 long column
% vectors with LAT_START, LON_START, and ALT_START being the first element
% in each vector. The input coordinates can either be in the geocentric or
% geodetic (default) system (specified by COORD), and the output will be in
% the same system as the input. If just one output argument is requested,
% LATITUDE, LONGITUDE, and ALTITUDE, are output as an NSTEPS+1-by-3 matrix
% as LLA = [LATITUDE, LONGITUDE, ALTITUDE].
% 
% This function relies on having the file igrfcoefs.mat in the MATLAB
% path to function properly when a time is input. If this file cannot be
% found, this function will try to create it by calling GETIGRFCOEFS.
% 
% Inputs:
%   -TIME: Time to get the magnetic field line coordinates in MATLAB serial
%   date number format or a string that can be converted into MATLAB serial
%   date number format using DATENUM with no format specified (see
%   documentation of DATENUM for more information).
%   -LAT_START: Starting point geocentric or geodetic latitude in degrees.
%   -LON_START: Starting point geocentric or geodetic longitude in degrees.
%   -ALT_START: For geodetic coordiates, the starting height in km above
%   the Earth's surface. For geocentric coordiates, the starting radius in
%   km from the center of the Earth.
%   -COORD: String specifying the coordinate system to use. Either
%   'geocentric' or 'geodetic' (optional, default is geodetic).
%   -DISTANCE: Distance in km to trace along the magnetic field line.
%   Positive goes up the field line (towards the geographic north pole /
%   geomagnetic south pole), while negative goes the other way.
%   -NSTEPS: Number of steps to compute the magnetic field line.
% 
% Outputs:
%   -LATITUDE: Column vector of the geocentric or geodetic latitudes in
%   degrees of the NSTEPS+1 points along the magnetic field line.
%   -LONGITUDE: Column vector of the geocentric or geodetic longitudes in
%   degrees of the NSTEPS+1 points along the magnetic field line.
%   -ALTITUDE: For geodetic coordiates, the heights in km above the Earth's
%   surface of the NSTEPS+1 points along the magnetic field line. For
%   geocentric coordiates, the radii in km from the center of the Earth of
%   the NSTEPS+1 points along the magnetic field line. Also a column
%   vector.
%   LLA: NSTEPS+1-by-3 matrix of [LATITUDE, LONGITUDE, ALTITUDE].
% 
% See also: IGRF, GETIGRFCOEFS, LOADIGRFCOEFS, DATENUM.

error(nargchk(7, 7, nargin));

% Length of each step.
steplen = distance/abs(nsteps);

% Convert from geodetic coordinates to geocentric coordinates if necessary.
% The coordinate system used here is spherical coordinates (r,phi,theta)
% corresponding to radius, azimuth, and elevation, respectively.
if isempty(coord) || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    % First convert to ECEF, then convert to spherical. The function
    % geod2ecef assumes meters, but we use km here.
    [x, y, z] = geod2ecef(lat_start, lon_start, alt_start*1e3);
    [phi, theta, r] = cart2sph(x, y, z); r = r/1e3;
elseif strcmpi(coord, 'geocentric') || strcmpi(coord, 'geoc') || ...
        strcmpi(coord, 'gc')
    r = alt_start;
    phi = lon_start*pi/180;
    theta = lat_start*pi/180;
else
    error('igrfline:coordInputInvalid', ['Unrecognized command ' coord ...
        ' for COORD input.']);
end

% Get coefficients from loadigrfcoefs.
gh = loadigrfcoefs(time);

% Initialize for loop.
r = [r; zeros(nsteps, 1)];
phi = [phi; zeros(nsteps, 1)];
theta = [theta; zeros(nsteps, 1)];

for index = 1:nsteps
    
    % Get magnetic field at this point. Note that IGRF outputs the
    % Northward (x), Eastward (y), and Downward (z) components, but we want
    % the radial (-z), azimuthal (y), and elevation (x) components
    % corresponding to (r,phi,theta), respectively.
    [Bt, Bp, Br] = igrf(gh, theta(index)*180/pi, phi(index)*180/pi, ...
        r(index), 'geoc'); Br = -Br;
    B = hypot(Br, hypot(Bp, Bt));
    
    % Unit vector in the (r,phi,theta) direction:
    dr = Br/B; dp = Bp/B; dt = Bt/B;
    
    % The next point is steplen km from the previous point in the direction
    % of the unit vector just found above.
    r(index+1) = r(index) + steplen*dr;
    theta(index+1) = theta(index) + steplen*dt/r(index);
    phi(index+1) = phi(index) + steplen*dp/(r(index)*cos(theta(index)));
    
end

% Convert the field line to the proper coordinate system.
if isempty(coord) || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    % First convert to ECEF, then geodetic. The function ecef2geod assumes
    % meters, but we want km here.
    [x, y, z] = sph2cart(phi, theta, r*1e3);
    [latitude, longitude, altitude] = ecef2geod(x, y, z);
    altitude = altitude/1e3;
else
    latitude = theta*180/pi;
    longitude = phi*180/pi;
    altitude = r;
end

if nargout <= 1
    latitude = [latitude(:), longitude(:), altitude(:)];
end