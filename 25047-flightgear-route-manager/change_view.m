function change_view(viewno, host, port)
% CHANGE_VIEW(VIEWNO, HOST, PORT)
% 
% Change view to view # VIEWNO in Flightgear over socket connection
% (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


% change view
out.println(sprintf(...
    'set /sim/current-view/view-number %d\r\n',viewno));


out.close();
fg_socket.close();

end

