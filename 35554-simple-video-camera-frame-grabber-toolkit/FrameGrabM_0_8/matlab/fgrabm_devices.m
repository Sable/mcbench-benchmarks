function retList = fgrabm_devices
%FGRABM_DEVICES FrameGrabM Get list of video capture devices
%   FGRABM_DEVICES obtains a list of all of the detected video devices and
%   returns them as a structure array.  To use a particular device, refer
%   to the deviceIndex value.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

% Get the Java-based device list:
inList = struct(FGRABM.class.getDeviceList);

% Formulate our return: (Note that this is not entirely efficient...)
for index = length(inList):-1:1
    retList(index).description = char(inList{index}.description);
    retList(index).deviceID = char(inList{index}.deviceID);
    retList(index).deviceIndex = inList{index}.deviceIndex;
end
