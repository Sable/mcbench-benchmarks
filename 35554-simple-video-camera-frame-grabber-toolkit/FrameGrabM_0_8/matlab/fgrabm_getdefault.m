function deviceIndex = fgrabm_getdefault()
%deviceIndex = FGRABM_GETDEFAULT FrameGrabM Get the default device
%   FGRABM_GETDEFAULT returns the default device ID.  The default device ID
%   is used to refer to the capture device represented by the respective
%   index of the structure array returned by FGRABM_DEVICES.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

deviceIndex = FGRABM.defaultDevice;
