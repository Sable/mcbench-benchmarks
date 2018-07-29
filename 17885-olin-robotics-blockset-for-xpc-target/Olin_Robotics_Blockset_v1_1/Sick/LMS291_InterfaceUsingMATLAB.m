% This M-file is to verify the ability to communicate with the sensor using
% MATLAB. This M-file can be run when the sensor is connected both via
% RS232 and RS422 setups.


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