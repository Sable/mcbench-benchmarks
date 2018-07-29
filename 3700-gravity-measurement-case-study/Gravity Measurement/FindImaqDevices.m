function devInfo = FindImaqDevices(desiredFormat)
%FINDIMAQDEVICES returns list of available image acquisition devices.
%   DEVINFO = FINDIMAQDEVICES returns a structure array with named fields.
%     .NAME is good for populating a GUI for user selection.
%     .CONSTRUCTOR aids programmatic connection to each device.
%     .ADAPTOR and .DEVICE help with nondefault object constructors.
%   The length of DEVINFO indicates how many devices detected.  
%   If no devices detected, DEVINFO is empty.
%
%   DEVINFO = FINDIMAQDEVICES(DESIREDFORMAT) allows specification of the
%   desired video format. This string is inserted into the constructor
%   field for each device. DESIREDFORMAT is not checked, so if you specify
%   an invalid format then evaluating the constructor(s) will error.
%
%   NOTE: This function calls IMAQRESET, which closes and deletes any
%   previously active videoinput objects.
%
%   See also FINDCAM, IMAQHWINFO, IMAQRESET.

% Copyright 2003-2010 The MathWorks, Inc.

error(nargchk(0,1,nargin))
error(nargoutchk(1,1,nargout))

%make sure recently added plug-n-play devices also detectable
imaqreset

%installed adaptors
hwInfo = imaqhwinfo;
adaptors = hwInfo.InstalledAdaptors;

%available devices
numDevices = 0;  %start with empty list
for i=1:length(adaptors)  %check each adaptor
  adaptorInfo = imaqhwinfo(adaptors{i});
  devices = adaptorInfo.DeviceIDs;
  %add each device to list
  for j=1:length(devices)
    numDevices = numDevices+1;
    deviceInfo = imaqhwinfo(adaptors{i},devices{j});
    devInfo(numDevices).name = deviceInfo.DeviceName;
    constructor = deviceInfo.ObjectConstructor;
    if nargin>0  %add format to object constructor
      constructor = [constructor(1:end-1) ', ''' desiredFormat ''')'];
    end
    devInfo(numDevices).constructor = constructor;
    devInfo(numDevices).adaptor = adaptors{i};
    devInfo(numDevices).device = devices{j};
  end  %for j = devices
end  %for i = adaptors

%return empty idicator if no devices detected
if numDevices==0
  devInfo=[];
end
