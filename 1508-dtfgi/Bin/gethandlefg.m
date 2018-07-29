%GETHANDLEFG Framegrabber device gethandle function.
%
%SYNTAX devinfo = gethandlefg('alias')
%
%Description This function will return the handle of 
%the framegrabber device when you lost the handle to 
%the device.
%
%INPUT The alias (alias) of the framegrabber device.
%
%REMARKS It will be verified if the input is a string. 
%If it's valid string, the function will  return the 
%device information structure of the device.
%
%OUTPUT If the input isn't valid, some error message will 
%be shown to the user. If everything's ok, the function 
%will return the device information structure of the opened 
%framegrabber device with the given alias. 
%
%EXAMPLE To regain the handle to the framegrabber, type 
%in the Matlab Command Window : 
			
%m=gethandlefg('DT3155');

disp('Error: gethandlefg not found.')

