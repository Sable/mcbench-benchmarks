%SETFG Set function for the Framegrabber.
%
%SYNTAX setfg(devinfo, 'parname', parvalue); OR
%		  setfg(devinfo);
%
%DESCRIPTION This function will let the user set 
%a parameter of DT framegrabber device.
%
%INPUT The device information structure (devinfo) 
%of the opened framegrabber device and the parameter 
%name (parname) of the parameter that has to be 
%set and the parameter value (parvalue) of that 
%parameter OR only the device information structure 
%(devinfo).
%
%REMARKS It will be verified if the first input 
%argument is a valid device information structure 
%and if the second input argument is a parameter 
%name. If it's valid, it will try to get the device 
%id from the device information structure. 
%
%OUTPUT If the input isn't valid or the framegrabber 
%can't be set with the chosen parameter value, some 
%error message will be shown to the user. If 
%everything's ok, it will set the chosen parameter of 
%the framegrabber device to the chosen parameter value. 
%
%EXAMPLE To set the frameheight to 400 pixels, and 
%assuming that the variable m stores the device info 
%of the current framegrabber, type:
%
%	setfg(m,'frameheight',400);
%
%For an overview of al settings, type:
%	setfg(m)
%
disp('Error: setfg not found')