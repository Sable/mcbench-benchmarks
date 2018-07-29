function tsim=get_simtime(host, port)
% TSIM = GET_SIMTIME(HOST, PORT)
% 
% Read simulation time from Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);
in = BufferedReader(InputStreamReader(fg_socket.getInputStream()));


% simulation time in seconds
out.println(sprintf('get /sim/time/elapsed-sec\r\n'));
t_sec_str = char(in.readLine());
j = findstr(t_sec_str,'''');
tsim = str2double(t_sec_str(j(1)+1:j(2)-1));


out.close();
in.close();
fg_socket.close();

end