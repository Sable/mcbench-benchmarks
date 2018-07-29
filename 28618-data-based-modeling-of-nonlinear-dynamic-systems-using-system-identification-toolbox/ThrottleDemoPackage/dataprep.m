%% DATA PREPARATION SCRIPT

%   Copyright 2009-2010 The MathWorks, Inc.

load ThrottleTestDataCond

% Select a portion of useful data sets. Downsample by a factor of 10. This
% ignores aliasing effects. In practice you may want to downsample using
% something like RESAMPLE (from Signal Processing Toolbox) or acquire data
% from actual experiment at a slower rate (assuming your data acquisition
% hardware comes with appropriate antialiasing filters). 
Input1 = PsuedoRandomNoise50PctInput(1:10:3000);
Output1 = PsuedoRandomNoise50PctPosition(1:10:3000);
Name1 = 'PsuedoRandomNoise50Pct';
Notes1 = 'Data obtained using pseudo-random noise input of maximum amplitude of 50% of maximum value';

Input2 = WOT1SecPulseInput(1:10:3000);
Output2 = WOT1SecPulsePosition(1:10:3000);
Name2 = 'WOT1SecPulse';
Notes2 = {'Data obtained by using a 1 sec long pulse that opens the throttle completely ("wide open throttle" measurement).',...
   'This is achieved by using a full strength input pulse.'};

Input3 = WOT_Pt12SecPulseInput(1:10:3000);
Output3 = WOT_Pt12SecPulsePosition(1:10:3000);
Name3 = 'Short Pulse';
Notes3 = 'Data obtained by using a short 0.12 second pulse of maximum strength.';

Input4 = PsuedoRandomNoiseInput(1:10:3000);
Output4 = PsuedoRandomNoisePosition(1:10:3000);
Name4 = 'Pseudo-random';
Notes4 = 'Data obtained by using a pseudo-random noise input';

Input5 = Pulse60PctInput(1:10:3000);
Output5 = Pulse60PctPosition(1:10:3000);
Name5 = 'lower amplitude pulse';
Notes5 = 'Data obtained by using a 1 sec long pulse whose maximum amplitude is 60% of maximum value.';

Ts = 0.01;
Time = (0:Ts:(length(Input1)-1)*Ts)';

% Package data up in IDDATA objects for use by System Identification
% Toolbox.
data1 = iddata(Output1, Input1, Ts, 'Tstart', 0, ...
   'InputName', 'Step Command', 'OutputName', 'Valve Angle', 'OutputUnit', 'Deg.');

data2 = iddata(Output2, Input2, Ts, 'Tstart', 0, ...
   'InputName', 'Step Command', 'OutputName', 'Valve Angle', 'OutputUnit', 'Deg.');

data3 = iddata(Output3, Input3, Ts, 'Tstart', 0, ...
   'InputName', 'Step Command', 'OutputName', 'Valve Angle', 'OutputUnit', 'Deg.');

data4 = iddata(Output4, Input4, Ts, 'Tstart', 0, ...
   'InputName', 'Step Command', 'OutputName', 'Valve Angle', 'OutputUnit', 'Deg.');

data5 = iddata(Output5, Input5, Ts, 'Tstart', 0, ...
   'InputName', 'Step Command', 'OutputName', 'Valve Angle', 'OutputUnit', 'Deg.');
