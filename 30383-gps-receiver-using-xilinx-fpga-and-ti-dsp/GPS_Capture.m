% GPS Signal Capture Script
% This requires LeCroy's ActiveDSO Interface, available at http://www.lecroy.com
% No additional MathWorks products are required.
% The scope state has been setup via front panel controls:
% 50 MSPS rate, 48 M words record length, 0.1V/div, BWL 20 MHz
% and a single shot capture has been made. 
% Copywrite 2002-2011 The Mathworks, Inc.
% Dick Benson
%% Create ActiveX Control to establish communication with scope
hDSO = actxcontrol('lecroy.activedsoctrl.1',[130 80 800 600]);
MakeConnection(hDSO,'TCPIP: 192.168.0.13'); % static IP set for this scope

%  inspect(hDSO)      %What do we know about it?
%  methodsview(hDSO)  %What can we do with it, and how?

% returns unsigned int8, need to remove offset, and recast to int8
y = int8(int16((GetByteWaveform(hDSO,'C1',48e6,0)))-128); % 48 million samples from channel 1
figure; plot(y(1:1e5)); % sanity check
Disconnect(hDSO);
clear hDSO
s=[6 10 30 21 2 29 5]; % satellites that should be in the data set
% save the capture  
save GPS_long_3_X y s