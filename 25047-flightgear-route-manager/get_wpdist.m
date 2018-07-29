function [wp_dist_m]=get_wpdist(host, port)
% [WP_DIST_M]=GET_WPDIST(HOST, PORT)
% 
% Read distance WP_DIST of aircraft from current waypoint in
% Flightgear over socket connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);
in = BufferedReader(InputStreamReader(fg_socket.getInputStream()));


% waypoint distance meter
out.println(sprintf('get /autopilot/route-manager/wp/dist\r\n'));
wp_dist_m_str = char(in.readLine());
j = findstr(wp_dist_m_str,'''');
%Conversion from sea miles (nm) to meter
wp_dist_m = str2double(wp_dist_m_str(j(1)+1:j(2)-1)) * 1852;


out.close();
in.close();
fg_socket.close();

end

