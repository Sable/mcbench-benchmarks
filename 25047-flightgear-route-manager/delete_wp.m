function delete_wp(pos, host, port)
% DELETE_WP(POS, HOST, PORT)
% 
% Delete waypoint at position POS in stack of Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


out.println(sprintf(...
    'set /autopilot/route-manager/input @delete%d\r\n', pos-1));


out.close();
fg_socket.close();

end

