function [s] = serialstart(opt)
% Funtion for initializing a serial interface in matlab for interfacing
% with modbus Eaton ELC PLC controllers over RS-232 serial connections
%
% mode 1 initializes the connection using the com port specified in
% opt.serial
%
% Functions using the serial port must be passed the serial port object s
% in order for the serial port to be acessable. 
%
% Originally by Steven Edmund


if nargin == 0
    mode = 1; 
    opt.serial = 'COM4'; % must be set according to your system.
end

% Initialize serial port on specified com port
s = serial(opt.serial);

% Specify connection parameters
set(s,'BaudRate',9600,'DataBits',8,'StopBits',1,'Parity','None','Timeout',5);

%Open serial connection
fopen(s);

% Specify Terminator - not used for binary mode (RTU) writing
s.terminator = 'CR/LF';

% Set read mode
set(s,'readasyncmode','continuous');


