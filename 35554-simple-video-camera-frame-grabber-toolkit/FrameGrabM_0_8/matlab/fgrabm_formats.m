function retList = fgrabm_formats(varargin)
%FGRABM_FORMATS([device]) FrameGrabM Get list of capture formats for device
%   FGRABM_FORMATS obtains a list of all formats supported by the given
%   device (addressed as an index as given by FGRABM_DEVICES).  If no
%   device index is given, then the default device is used.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

if nargin == 0
    device = FGRABM.defaultDevice;
elseif nargin == 1
    device = varargin{1};
    % In case someone starts this as a statement, the parameter is a string:
    if ischar(device)
        device = str2double(device);
    end
else
    error('Too many parameters supplied.');
end

% Get the Java-based device list:
inList = struct(FGRABM.class.getFormatList(device));

% Formulate our return: (Note that this is not entirely efficient...)
for index = length(inList):-1:1
    retList(index).description = char(inList{index}.description);
    retList(index).type = char(inList{index}.type);
    retList(index).width = inList{index}.width;
    retList(index).height = inList{index}.height;
    retList(index).frameRate = inList{index}.frameRate;
    retList(index).formatIndex = inList{index}.formatIndex;
    retList(index).deviceIndex = inList{index}.deviceIndex;
end

% Save the list in our structure so that we can access it when grabbing:
FGRABM.formats{device} = retList;
