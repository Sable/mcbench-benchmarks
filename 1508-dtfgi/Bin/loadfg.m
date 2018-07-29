%LOADFG Settings loader for the framegrabber
%
%SYNTAX loadfg(devinfo,filename);
%
%DESCRIPTION This function will let the user load 
%settings from a file. The user has to give the 
%framegrabbers device information structure as input 
%argument, as well as the filename (with full path). 
%Executing the openfg function has retrieved this 
%device information structure
%
%INPUT The device information structure (devinfo) of 
%an opened framegrabber device, the filename 
%(with full path).
%
%REMARKS It will be verified if the input is a valid 
%device information structure. If it's valid, it will 
%try to get the deviceid from the device information 
%structure. 
%
%OUTPUT If the input isn't valid, some error message 
%will be shown to the user. If everything's ok, it 
%will load the settings from the file into the 
%framegrabber. To see the new settings, use the getfg 
%function.
%
%EXAMPLE To load the settings from the file pulnix.ini 
%with path c:\camfiles and assuming that the variable m 
%stores the device info of the current framegrabber, type:
%
%	loadfg(m,'c\camfiles\pulnix.ini');

disp('Error: loadfg not found')
