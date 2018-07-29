% PLOTBEARTH Plot the Earth's magnetic field lines using the IGRF.
% 
% Plots a globe and a number of magnetic field lines starting at each point
% specified by the vectors in lat_start and lon_start. Both distance and
% nsteps should be the same length as lat_start. The plot will spin if spin
% is true and will continue to spin until the user hits CTRL+C.

clear;
close all;

font = 'Times New Roman';
axis_font = 12;
title_font = 12;

time = datenum([2007 7 17 6 30 0]);
lat_start = 30:15:60; % Geodetic latitudes in degrees.
lon_start = 0:30:330; % Geodetic longitudes in degrees.
alt_start = 0; % Altitude in km.
distance = -sign(lat_start).*[30e3 70e3 150e3]; % km.
nsteps = abs(distance)/10;
spin = false;

% Get the magnetic field line points.
lat = zeros(max(nsteps(:))+1, numel(lat_start)*numel(lon_start));
lon = zeros(max(nsteps(:))+1, numel(lat_start)*numel(lon_start));
alt = zeros(max(nsteps(:))+1, numel(lat_start)*numel(lon_start));
for index1 = 1:numel(lat_start)
    for index2 = 1:numel(lon_start)
        [lat(1:nsteps(index1)+1, ...
            index1*(numel(lon_start)-1)+index2) lon(1:nsteps(index1)+1, ...
            index1*(numel(lon_start)-1)+index2) alt(1:nsteps(index1)+1, ...
            index1*(numel(lon_start)-1)+index2)] = ...
            igrfline(time, lat_start(index1), lon_start(index2), ...
            alt_start, 'geod', distance(index1), nsteps(index1));
    end
end

% Plot the magnetic field lines.
figure;
hold on;

% If the mapping toolbox is not available, use non-mapping toolbox
% functions to plot the globe and lines.
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
    
% Otherwise, use mapping toolbox functions to plot globe and lines.
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
title(['Magnetic Field Lines at ' datestr(time)], 'FontName', font, ...
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