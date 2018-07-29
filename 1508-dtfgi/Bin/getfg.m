%GETFG Query function for the Framegrabber.
%
%SYNTAX parvalue = getfg(devinfo, 'parname');
%
%DESCRIPTION This function will let the user get a 
%parameter of DT framegrabber device.
%
%INPUT The device information structure (devinfo) 
%of the opened framegrabber device and the parameter 
%name (parname) and if applicable the field name 
%(fieldname).
%
%REMARKS It will be verified if the first input 
%argument is a valid device information structure and 
%if the second input argument is a parameter name and 
%if the third input argument is a fieldname 
%(if applicable). If it's valid, it will try to get 
%the device id from the device information structure. 
%
%OUTPUT If the input isn't valid or the framegrabber 
%can't get the parameter value of the chosen parameter 
%name, some error message will be shown to the user. 
%If everything's ok, it will return the parameter value 
%(parvalue) of the chosen parameter name of the device.
%
%EXAMPLE To get the blacklevel which will be stored in 
%the variable bl, and assuming that the variable m 
%stores the device info of the current framegrabber, type:
%
%	bl = getfg(m,'blacklevel');


disp('Error: getfg not found.')