function activate_ap(speed, host, port)
% ACTIVATE_AP(SPEED, HOST, PORT)
% 
% Activate Autopilot in Flightgear over socket connection (HOST,
% PORT) and set target speed = SPEED [mph].
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);


% activate autopilot
out.println(sprintf(...
    'set /autopilot/locks/altitude altitude-hold\r\n'));
out.println(sprintf(...
    'set /autopilot/locks/heading true-heading-hold\r\n'));
out.println(sprintf(...
    'set /autopilot/locks/speed speed-with-throttle\r\n'));

% set target speed (convert mph to knots)
out.println(sprintf(...
    'set /autopilot/settings/target-speed-kt %d\r\n',speed*0.869));


out.close();
fg_socket.close();

end

