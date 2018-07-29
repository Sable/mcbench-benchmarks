% PLOTBLINE Plot the one of Earth's magnetic field lines using the IGRF.
% 
% Plots a globe and a single magnetic field lines starting at lat_start and
% lon_start. The line will extend a length of distance km. The plot will
% spin if spin is true and will continue to spin until the user hits
% CTRL+C.

clear;
close all;

font = 'Times New Roman';
axis_font = 12;
title_font = 12;

time = datenum([2007 7 17 6 30 0]);
lat_start = -60; % Geodetic latitude in degrees.
lon_start = 180; % Geodetic longitude in degrees.
alt_start = 0; % Altitude in km.
distance = 90e3; % km.
nsteps = abs(distance)/1;
spin = false;

% Get the magnetic field line points.
[lat, lon, alt] = igrfline(time, lat_start, lon_start, alt_start, ...
    'geod', distance, nsteps);
lat = lat(alt > -1); lon = lon(alt > -1); alt = alt(alt > -1);
lon(lon > 180) = lon(lon > 180) - 360;

% Plot the magnetic field line.
figure;
hold on;

% If the mapping toolbox is not available, use non-mapping toolbox
% functions to plot the globe and line.
if ~license('test', 'MAP_Toolbox')
    
    % WGS84 parameters.
    a = 6378.137; f = 1/298.257223563;
    b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;
    
    % Plot a globe.
    load('topo.mat', 'topo', 'topomap1');
    [xe, ye, ze] = ellipsoid(0, 0, 0, a, a, b, 100);
    surface(-xe, -ye, ze, 'FaceColor', 'texture', ...
        'EdgeColor', 'none', 'CData', topo);
    colormap(topomap1);
    
    % Convert lla to xyz.
    [x, y, z] = geod2ecef(lat, lon, alt*1e3); % geod coord
    x = x/1e3; y = y/1e3; z = z/1e3;          % geod coord
    % [x, y, z] = sph2cart(lon*pi/180, lat*pi/180, alt); % geoc coord
    
    % Make the plots.
    plot3(x, y, z, 'r');
    axis equal;
    
% Otherwise, use mapping toolbox functions to plot globe and line.
else
    load('topo.mat', 'topo', 'topolegend');
    axesm('globe', 'Geoid', 6371.2)
    meshm(topo, topolegend); demcmap(topo);
    % [x, y, z] = sph2cart(lon*pi/180, lat*pi/180, alt*1e3); % geoc coord
    % [lat, lon, alt] = ecef2geod(x, y, z); alt = alt/1e3;   % geoc coord
    plot3m(lat, lon, alt, 'r'); % geod coord
end

% Set the plot background to black.
set(gcf, 'color', 'k');
axis off;
title(['Magnetic Field Line at ' datestr(time)], 'FontName', font, ...
    'FontSize', title_font, 'Color', 'w');

% Spin the plot indefinitely.
index = 0;
view(mod(index, 360), 23.5); % Earth's axis tilts by 23.5 degrees
while spin
    view(mod(index, 360), 23.5); % Earth's axis tilts by 23.5 degrees
    drawnow;
    pause(0.1);
    index = index - 5;
end