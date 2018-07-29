function [wp_stack]=get_wpstack(host, port)
% [WP_STACK]=GET_WPSTACK(HOST, PORT)
% 
% Read number of waypoints in stack from Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);
in = BufferedReader(InputStreamReader(fg_socket.getInputStream()));


% Waypoints in stack
out.println(sprintf('get /autopilot/route-manager/route/num\r\n'));
wp_stack_str = char(in.readLine());
j = findstr(wp_stack_str,'''');
wp_stack = str2double(wp_stack_str(j(1)+1:j(2)-1));


out.close();
in.close();
fg_socket.close();

end

