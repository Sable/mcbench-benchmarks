function [lat_deg, lon_deg, alt_ft, gnd_elev_m, head_deg, ...
    pitch_deg, yaw_deg, roll_deg]=get_pos(host, port)
% [LAT_DEG, LON_DEG, ALT_FT, GND_ELEV_M, HEAD_DEG, PITCH_DEG,
% YAW_DEG, ROLL_DEG]=GET_POS(HOST, PORT)
% 
% Read aircraft position and orientation from Flightgear over socket
% connection (HOST, PORT).
% Run Flightgear on HOST (e.g. '127.0.0.1' = localhost) with
% parameter "--props = PORT".
%
% Function returns:
% -----------------
% POSITION:
% - Latitude degree
% - Longitude degree
% - Altitude feet
% - Ground elevation meter
%
% ORIENTATION:
% - Heading degree
% - Pitch degree
% - Yaw degree
% - Roll degree

import java.net.Socket
import java.io.*

fg_socket = Socket(host, port);
out = PrintWriter(fg_socket.getOutputStream(), true);
in = BufferedReader(InputStreamReader(fg_socket.getInputStream()));


%% Position of aircraft
% Latitude degree
out.println(sprintf('get /position/latitude-deg\r\n'));
lat_deg_str = char(in.readLine());
j = findstr(lat_deg_str,'''');
lat_deg = str2double(lat_deg_str(j(1)+1:j(2)-1));

% Longitude degree
out.println(sprintf('get /position/longitude-deg\r\n'));
lon_deg_str = char(in.readLine());
j = findstr(lon_deg_str,'''');
lon_deg = str2double(lon_deg_str(j(1)+1:j(2)-1));

% Altitude feet
out.println(sprintf('get /position/altitude-ft\r\n'));
alt_ft_str = char(in.readLine());
j = findstr(alt_ft_str,'''');
alt_ft = str2double(alt_ft_str(j(1)+1:j(2)-1));

% Ground elevation meter
out.println(sprintf('get /position/ground-elev-m\r\n'));
gnd_elev_m_str = char(in.readLine());
j = findstr(gnd_elev_m_str,'''');
gnd_elev_m = str2double(gnd_elev_m_str(j(1)+1:j(2)-1));


%% Orientation of aircraft
% Heading deg
out.println(sprintf('get /orientation/heading-deg\r\n'));
head_deg_str = char(in.readLine());
j = findstr(head_deg_str,'''');
head_deg = str2double(head_deg_str(j(1)+1:j(2)-1));

% Pitch deg
out.println(sprintf('get /orientation/pitch-deg\r\n'));
pitch_deg_str = char(in.readLine());
j = findstr(pitch_deg_str,'''');
pitch_deg = str2double(pitch_deg_str(j(1)+1:j(2)-1));

% Yaw deg
out.println(sprintf('get /orientation/yaw-deg\r\n'));
yaw_deg_str = char(in.readLine());
j = findstr(yaw_deg_str,'''');
yaw_deg = str2double(yaw_deg_str(j(1)+1:j(2)-1));

% Roll deg
out.println(sprintf('get /orientation/roll-deg\r\n'));
roll_deg_str = char(in.readLine());
j = findstr(roll_deg_str,'''');
roll_deg = str2double(roll_deg_str(j(1)+1:j(2)-1));


out.close();
in.close();
fg_socket.close();

end