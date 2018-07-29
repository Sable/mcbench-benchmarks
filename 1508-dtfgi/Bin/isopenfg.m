%ISOPENFG Framegrabber grabbing image function.
%
%SYNTAX isopenfg('alias')
%
%DESCRIPTION This function will let the user check whether 
%the framegrabber device has been opened or not. It will 
%return an integer acting like a boolean. 
%
%INPUT The alias (alias) of the framegrabber device.
%
%REMARKS It will be verified if the input is a string. 
%If it's valid, the function will return an integer.
%
%OUTPUT If the input isn't valid, some error message will be shown
%to the user. If everything's ok, the function will return
%an integer indicating the status of framegrabber device.
%If the function returns 1 the framegrabber has been opened,
%otherwise the function returns zero.
%
disp('Error: isopenfg not found.')