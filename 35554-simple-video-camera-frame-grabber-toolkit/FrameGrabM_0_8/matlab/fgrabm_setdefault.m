function fgrabm_setdefault(device)
%FGRABM_SETDEFAULT(device) FrameGrabM Set the default device ID
%   FGRABM_SETDEFAULT allows the default capture device to be set
%   so that most function calls that take a device index as a parameter
%   don't need the parameter specified-- the default will be used in its
%   place.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

% In case someone starts this as a statement, the parameter is a string:
if ischar(device)
    device = str2double(device);
end

% Check that we are in the limit:
if (device < 1) || (device > FGRABM.class.getNumDevices)
    error(['The default device index ' num2str(device) ' is out of range.'])
end

FGRABM.defaultDevice = device;
