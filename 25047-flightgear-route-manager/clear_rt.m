function clear_rt(host, port)
% CLEAR_RT(HOST, PORT)
% 
% Clear entire stack of waypoints (route) in Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


out.println(sprintf(...
    'set /autopilot/route-manager/input @clear\r\n'));


out.close();
fg_socket.close();

end

