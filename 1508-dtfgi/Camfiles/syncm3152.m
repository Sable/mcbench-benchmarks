function syncm3152(m,Verfreq,HorFreq,Phase)
% sets parameters of DT3152 according to
% http://cmp.felk.cvut.cz/cmp/hardware/pulnix.html#TM-9701analog
% to generate sync frequency for pulnix cameras

% input parameters check
if nargin < 4, 
	error('Not enough input arguments!');
end

if nargin > 4, 
	error('Too many input arguments!');
end

setfg(m, 'SyncMaster', 'Off')	%stop syncmaster mode to enable setting parameters
setfg(m, 'SyncValue','VerFreq', Verfreq)		%TM9701 30 Hz, TM1001 15 Hz
setfg(m, 'SyncValue','HorFreq', HorFreq)		%TM9701 15750 Hz
setfg(m, 'SyncValue','HPulseWidth', 4800)		%TM9701 [ns]
setfg(m, 'SyncValue','VPulseWidth', 190000)	%TM9701 [ns]
setfg(m, 'SyncValue','Phase', Phase)		%TM9701 !!!!inproper function of camera
														%when phase between Ver and Hor signal 
                                          %is in range about 5000 (means 50% or 180 degrees
                                          %working properly around 100 and 9999
setfg(m, 'SyncMaster', 'On')	%start syncmaster mode, signal will be generated
										%when next request for grabbing an image arrive to grabber                                          	