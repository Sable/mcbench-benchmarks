function iq = acquireIqVector(mxa_ip)

% MATLAB/MXA example 7
% Getting IQ data using the MXA driver and plot display

% Version: 1.0
% Date: Sep 11, 2006  
% 2006 Agilent Technologies, Inc.

% TCPIP parameters
mxa_port = 5025;

% MXA Interface creation and connection opening
mxa_if = tcpip(mxa_ip,mxa_port);
mxa = icdevice('agilent_mxa.mdd', mxa_if);
connect(mxa,'object')

% Get IQ data
iq = invoke(mxa,'getIQ');


% Close the MXA connection and clean up
disconnect(mxa);
delete(mxa);
clear mxa;
