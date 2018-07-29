%CLOSEFG Framegrabber device close function.
%
%SYNTAX closefg(devinfo) or closefg('alias');
%
%DESCRIPTION This function will let the user close 
%an opened DT framegrabber device. The user has to 
%give the framegrabbers device information structure 
%as input argument OR the alias of the framegrabber
%device. 
%
%INPUT The device information structure (devinfo) 
%of an opened framegrabber device OR the alias (alias)
%of the opened framegrabber device.
%
%REMARKS It will be verified if the input is a valid 
%device information structure or string. If it's valid, 
%it will try to get the deviceid from the device information 
%structure. 
%
%OUTPUT If the input isn't valid or the framegrabber 
%can't be closed for some reason, some error message 
%will be shown to the user. If everything's ok, it 
%will close the opened framegrabber device.
%
%EXAMPLE To close a framegrabber with its device id 
%stored in the variable m, and 'DT3155 as the alias
%type in the Matlab Command Window : 
% 
%	EXAMPLE 1: 		closefg(m);
%	EXAMPLE 2:		closefg('DT3155');  
% 

disp('Error: closefg not found.')

