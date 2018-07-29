function speedup_fg(sp, host, port)
% SPEEDUP_FG(SP, HOST, PORT)
% 
% Speeds up Flightgear's simulation speed by a factor SP over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".
%
% SP = 1: Realtime
% SP = 2: Realtime speeded up by factor 2
% ...

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


out.println(sprintf('set /sim/speed-up %2.1f\r\n', sp));


out.close();
fg_socket.close();

end

