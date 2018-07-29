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
%% Send Continuous Data Telegram
Send_Data = uint8([2 0 2 0 32 36 52 8]);
fwrite(s,Send_Data);
DataSet = fread(s); % 6 is success and then you can see the data header as well
% You should get DataSet as a [512 x 1] vector. This is so because the default
% buffer size is set as 512. You can change the buffer size using the
% command: s.InputBufferSize = xxxx;
%% Stop Continuous Data Telegram
Stop_Data = uint8([2 0 2 0 32 37 53 8]);
fwrite(s,Stop_Data);
StopData_Ack = fread(s,10,'uint8');
%% Close the serial port object in MATLAB
fclose(s);
%% The below commands are to be used only for Configuration purposes
%% Change to 500K BaudRate (high-speed mode) Telegram
Bd500k = uint8([2 0 2 0 32 72 88 8]);
fwrite(s,Bd500k);
Bd500k_Ack = fread(s,10,'uint8');
% change the board rate on the PC as well before any further communications
s.BaudRate = 9600; % the board assumes 9600 would actually correspond to highest possible BaudRate for the corresponding clock rate
%% Change to 9600 BaudRate Telegram
Bd9600 = uint8([2 0 2 0 32 66 82 8]);
fwrite(s,Bd9600);
Bd9600_Ack = fread(s,10,'uint8');
% change the board rate on the PC as well before any further communications
s.BaudRate = 9600;
%% Change to 19200 BaudRate Telegram
Bd19200 = uint8([2 0 2 0 32 65 81 8]);
fwrite(s,Bd19200);
Bd19200_Ack = fread(s,10,'uint8');
% change the board rate on the PC as well before any further communications
s.BaudRate = 19200;
%% Change to 38400 BaudRate Telegram
Bd38400 = uint8([2 0 2 0 32 64 80 8]);
fwrite(s,Bd38400);
Bd38400_Ack = fread(s,10,'uint8');
% change the board rate on the PC as well before any further communications
s.BaudRate = 38400;
%% Change LMS Angular Resolution mode to Range 0-100 with 1' resolution
Range_100_Res1 = uint8([2 0 5 0 59 100 0 100 0 29 15]); % data values = 101
fwrite(s,Range_100_Res1);
Range_100_Res1_Ack = fread(s,14,'uint8');
%% Change LMS Angular Resolution mode to Range 0-100 with 0.5' resolution
Range_100_Res05 = uint8([2 0 5 0 59 100 0 50 0 177 89]); % data values = 201
fwrite(s,Range_100_Res05);
Range_100_Res05_Ack = fread(s,14,'uint8');
%% Change LMS Angular Resolution mode to Range 0-100 with 0.25' resolution
Range_100_Res025 = uint8([2 0 5 0 59 100 0 25 0 231 114]); % data values = 401
fwrite(s,Range_100_Res025);
Range_100_Res025_Ack = fread(s,14,'uint8');
%% Change LMS Angular Resolution mode to Range 0-180 with 1' resolution
Range_180_Res1 = uint8([2 0 5 0 59 180 0 100 0 151 73]); % data values = 181
fwrite(s,Range_180_Res1);
Range_180_Res1_Ack = fread(s,14,'uint8');
%% Change LMS Angular Resolution mode to Range 0-180 with 0.5' resolution (default)
Range_180_Res05 = uint8([2 0 5 0 59 180 0 50 0 59 31]); % data values = 361
fwrite(s,Range_180_Res05);
Range_180_Res05_Ack = fread(s,14,'uint8');
%% Change to Installation Mode Telegram (password is hex SICK_LMS)
Meas_Mode = uint8([2 0 10 0 32 0 83 73 67 75 95 76 77 83 190 197]);
fwrite(s,Meas_Mode);
MeasMode_Ack = fread(s);
%% Set the units to be mm (you need to first send the Installation Mode Telegram if you are not already in that mode)
Units_mm = uint8([2 0 33 0 119 0 0 0 0 0 0 1 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 252 126]);
fwrite(s,Units_mm);
Units_mm_Ack = fread(s);
%% Set the units to be cm (you need to first send the Installation Mode Telegram if you are already not in that mode)
Units_cm = uint8([2 0 33 0 119 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 232 114]);
fwrite(s,Units_cm);
Units_cm_Ack = fread(s);
%% Set the current BaudRate as permanent (you need to first send the Installation Mode Telegram if you are already not in that mode)
Perm_BdRate = uint8([2 0 2 0 102 1 157 78]);
fwrite(s,Perm_BdRate);      
Perm_BdRate_Ack = fread(s);
%% Set the current Configuration as permanent (you need to first send the Installation Mode Telegram if you are already not in that mode)
Perm_Conf = uint8([2 0 2 0 102 2 158 78]);
fwrite(s,Perm_Conf);      
Perm_Conf_Ack = fread(s);
%% close the serial object
fclose(s);