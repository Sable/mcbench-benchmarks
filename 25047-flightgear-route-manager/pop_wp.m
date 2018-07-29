function pop_wp(host, port)
% POP_WP(HOST, PORT)
% 
% Pops current waypoint in Flightgear over socket connection
% (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


out.println(sprintf('set /autopilot/route-manager/input @pop\r\n'));


out.close();
fg_socket.close();

end

