function add_wp(lon_deg, lat_deg, alt_ft, host, port)
% ADD_WP(LON_DEG, LAT_DEG, ALT_FT, HOST, PORT)
% 
% Adds waypoint/s (LON_DEG, LAT_DEG, ALT_FT) after last entry in
% stack of Flightgear route over socket connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


for i=1:min([length(lon_deg) length(lat_deg) length(alt_ft)])

    out.println(sprintf(...
       'set /autopilot/route-manager/input %3.10f,%3.10f@%d\r\n',...
       lon_deg(i),lat_deg(i),alt_ft(i)));

end


out.close();
fg_socket.close();

end

