function insert_wp(lat_deg, lon_deg, alt_ft, pos, host, port)
% INSERT_WP(LAT_DEG, LON_DEG, ALT_FT, POS, HOST, PORT)
% 
% Inserts waypoints (LAT_DEG, LON_DEG, ALT_FT) at position POS in
% stack of Flightgear over socket connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


for i=min([length(lat_deg) length(lon_deg) length(alt_ft)]):-1:1

    out.println(sprintf(...
    'set /autopilot/route-manager/input @insert%d:%3.10,%3.10@%d'...
    ,pos-1,lon_deg(i),lat_deg(i),alt_ft(i)));

end


out.close();
fg_socket.close();

end

