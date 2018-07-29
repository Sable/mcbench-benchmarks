%RESETFG Framegrabber device reset function.
%
%SYNTAX resetfg(devinfo);
%
%DESCRIPTION This function will let the user reset an 
%opened DT framegrabber device. The user has to give 
%the framegrabbers device information structure as 
%input argument. Executing the openfg function has 
%retrieved this device information structure
%
%INPUT The device information structure (devinfo) of 
%an opened framegrabber device.
%
%REMARKS It will be verified if the input is a valid 
%device information structure. If it's valid, it will 
%try to get the deviceid from the device information 
%structure. 
%
%OUTPUT If the input isn't valid, some error message 
%will be shown to the user. If everything's ok, it will 
%reset the opened framegrabber device.
%
%EXAMPLE To reset a framegrabber with its device id 
%stored in the variable m ,type in the Matlab Command Window : 
%			
%		resetfg(m);


disp('Error: resetfg not found.')

