% This M-file is to change the settings of the LMS sensor in MATLAB to do the following:
% 1) Change LMS Angular Resolution to 1' with range of 0-180 (181 data values)
% 2) Change the measurement units to mm
% 3) Change the baudrate to 500k using RS422 communication setup via Fastcom 422/2-PCI-335 board
% 4) Permanently set this configuration for the sensor (To memorize even the power is turned off)


%% Create a serial object for MATLAB to talk with the board
s=serial('COM3','BaudRate',9600);
fopen(s)
%% At this time, switch on the Sick Sensor connected to the PC either using the RS-232 or RS-422 connection 
% Read the initial response message from the LMS (30sec after the unit is turned on when the LED turns GREEN)
Initial_Response = fread(s,29,'uint8');
%% Status Request Telegram
% This telegram can be sent at any time to verify if you are able to
% communicate with the sensor.
% NOTE: A response telegram from the sensor if it starts with 
% 06hex (6 decimal) indicates success
% 15hex (21 decimal) indicates failure in the sense that the sensor is unable to send any response for the telegram
Status_Chk = uint8([2 0 1 0 49 21 18]);
fwrite(s,Status_Chk);
Status_Ack = fread(s,161,'uint8');
%% Change to Installation Mode Telegram
Install_Mode = uint8([2 0 10 0 32 0 83 73 67 75 95 76 77 83 190 197]);
fwrite(s,Install_Mode);
InstallMode_Ack = fread(s);
%% Set the units to be mm (you need to first send the Installation Mode Telegram if you are not already in that mode)
Units_mm = uint8([2 0 33 0 119 0 0 0 0 0 0 1 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 252 126]);
fwrite(s,Units_mm);
Units_mm_Ack = fread(s);
%% Change LMS Angular Resolution mode to Range 0-180 with 1' resolution
Range_180_Res1 = uint8([2 0 5 0 59 180 0 100 0 151 73]); % data values = 181
fwrite(s,Range_180_Res1);
Range_180_Res1_Ack = fread(s,14,'uint8');
%% Change to 500K BaudRate (high-speed mode) Telegram
Bd500k = uint8([2 0 2 0 32 72 88 8]);
fwrite(s,Bd500k);
Bd500k_Ack = fread(s,10,'uint8');
% change the board rate on the PC as well before any further communications
s.BaudRate = 9600; % the board assumes 9600 would actually correspond to highest possible BaudRate for the corresponding clock rate
%% close the serial object
fclose(s);

%% At this time, change the board settings from the PC by right clicking on
% My Computer->Properties->Hardware->Device Manager->Ports and change the clock rate to 8 MHz and check the "enable custom baudrate" option 

%%  Reopen the serial object
fopen(s);
%% Change to Installation mode (password is hex SICK_LMS)
Install_Mode = uint8([2 0 10 0 32 0 83 73 67 75 95 76 77 83 190 197]);
fwrite(s,Install_Mode);
InstallMode_Ack = fread(s);
%% Set the current configuration as permanent
Perm_Conf = uint8([2 0 2 0 102 2 158 78]);
fwrite(s,Perm_Conf);      
Perm_Conf_Ack = fread(s);
%% Close the serial port object in MATLAB
fclose(s);