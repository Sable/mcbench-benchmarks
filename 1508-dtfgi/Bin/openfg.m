%OPENFG Framegrabber device open function.
%
%SYNTAX devinfo = openfg('alias')
%
%DESCRIPTION This function will let the user open a DT 
%framegrabber device. The user has to give the 
%framegrabbers alias as input argument. The user 
%already knows this alias. This function can also be used
%to get the device information structure of a device that
%was already opened.
%
%INPUT The alias (alias) of the framegrabber device.
%
%REMARKS It will be verified if the input is a valid string. 
%If it's valid, it will try to open the framegrabber device 
%with that specific alias. If more than one Framegrabber is 
%installed in the computer, it is necessary to give unique 
%aliases to these devices.
%
%OUTPUT If the input isn't valid or the framegrabber device 
%can't be opened for some reason, some error message will be 
%shown to the user. If everything's ok, this function will 
%return a structure with the device information (devinfo) of 
%the opened framegrabber device.
%
%EXAMPLE To open the framegrabber with alias 'DT3152' and 
%store the device info strucutre in the variable m, or, if 
%the device with alias 'DT3152' was already open, to store 
%the device info structure in the variable m, use:
%
%	m = openfg('DT3152');


disp('Error: openfg not found.')