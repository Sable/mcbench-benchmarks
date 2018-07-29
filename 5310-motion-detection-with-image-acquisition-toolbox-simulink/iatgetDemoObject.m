function obj = iatgetDemoObject
% IATGETDEMOOBJECT Returns the object used by the motion detection demo.
%
%    IATGETDEMOOBJECT finds the VIDEOINPUT object used by the motion detection
%    demo and returns it.
%
%    See also VIDEOINPUT.

% DT 4/2004
% Copyright 2004 The MathWorks, Inc.

% Look for existing objects created by the demo.
obj = imaqfind('Tag', 'Motion Detection Object');

if isempty(obj)
    obj = localCreateObj;
    stop(obj)
    % Clear the callbacks.
    obj.TimerFcn = '';
    obj.FramesAcquiredFcn = '';
    obj.StartFcn = '';
    obj.StopFcn = '';
    obj.TriggerFcn = '';

    % Configure the object for manual trigger so that GETSNAPSHOT returns
    % quicker.
    triggerconfig(obj, 'Manual');

    % Configure the object to return YCbCr data which the demo requires.
    set(obj, 'ReturnedColorSpace', 'YCbCr');

    % Save the video resolution in the base workspace.
    videoRes = obj.ROIPosition;
    assignin('base', 'videoRes', [videoRes(4) videoRes(3)]);
else
    obj = obj{1};
    
    % Save the video resolution in the base workspace.
    videoRes = obj.ROIPosition;
    assignin('base', 'videoRes', [videoRes(4) videoRes(3)]);
end

function obj = localCreateObj
% localCreateObj searches for the first supported device with a
% default format.  Once found, it creates an object for that device and
% returns the object to the calling function.  Some devices do not have
% default formats and can not be used since the demo doesn't provide a
% method of specifying camera files.

% Determine the available adaptors.
info = imaqhwinfo;

adaptorName = [];
adaptorID = [];
adaptorIndex = 1;

% Search through all of the installed adaptors until an available adaptor
% with hardware that has a default format is found.
while (isempty(adaptorName) && isempty(adaptorID))
    
    if (adaptorIndex > length(info.InstalledAdaptors))
        error('imaq:motiondetection:nohardware', 'No hardware compatible with the motion detection demo was found.');
    end
    
    % Get information on the current adaptor.
    curAdaptor = info.InstalledAdaptors{adaptorIndex};
    adaptorInfo = imaqhwinfo(curAdaptor);
    
    % For the current adaptor, search through each installed device looking
    % for a device that has a default format.
    idIndex = 1;
    while (isempty(adaptorID) && (idIndex <= length(adaptorInfo.DeviceIDs)))
        curID = adaptorInfo.DeviceIDs{idIndex};
        if ~isempty(adaptorInfo.DeviceInfo(idIndex).DefaultFormat)
            adaptorName = curAdaptor;
            adaptorID = curID;
        end
        
        % If the current device doesn't have a default format check the
        % next one.
        idIndex = idIndex + 1;
    end
    
    % Check the next adaptor.
    adaptorIndex = adaptorIndex + 1;
end

% Create the object.
obj = videoinput(adaptorName, adaptorID);

% Configure the object's tag so that it can be found later by using
% IMAQFIND.
set(obj, 'Tag', 'Motion Detection Object');

% End of localCreateObj
