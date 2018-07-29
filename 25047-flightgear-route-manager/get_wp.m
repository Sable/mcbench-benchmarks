function [wp_lat_deg, wp_lon_deg, wp_alt_ft]=get_wp(wp, host, port)
% [WP_LAT_DEG, WP_LON_DEG, WP_ALT_FT]=GET_WP(WP, HOST, PORT)
% 
% Read waypoint WP from waypoint stack in Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".
%
% Function returns:
% - Lattitude degree
% - Longitude degree
% - Altitude feet

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);
in = BufferedReader(InputStreamReader(fg_socket.getInputStream()));


% Read waypoint wp
% Latitude degree
if wp == 1
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp/latitude-deg\r\n'));
else
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp[%d]/latitude-deg\r\n'...
    ,wp-1));
end
wp_lat_deg_str = char(in.readLine());
j = findstr(wp_lat_deg_str,'''');
wp_lat_deg = str2double(wp_lat_deg_str(j(1)+1:j(2)-1));

% Longitude degree
if wp == 1
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp/longitude-deg\r\n'));
else
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp[%d]/longitude-deg\r\n'...
    ,wp-1));
end
wp_lon_deg_str = char(in.readLine());
j = findstr(wp_lon_deg_str,'''');
wp_lon_deg = str2double(wp_lon_deg_str(j(1)+1:j(2)-1));

% Altitude feet
if wp == 1
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp/altitude-ft\r\n'));
else
    out.println(sprintf(...
    'get /autopilot/route-manager/route/wp[%d]/altitude-ft\r\n'...
    ,wp-1));
end
wp_alt_ft_str = char(in.readLine());
j = findstr(wp_alt_ft_str,'''');
wp_alt_ft = str2double(wp_alt_ft_str(j(1)+1:j(2)-1));


out.close();
in.close();
fg_socket.close();

end

