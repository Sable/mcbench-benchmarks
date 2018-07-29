function arr = fgrabm_grab(varargin)
%B = FGRABM_GRAB([device], [datatype], [fix]) FrameGrabM Grab frame
%   FGRABM_GRAB performs a frame grab on the given device (or the default
%   device if none specified) and returns the following:
%   For formats of type 'RGB24', an array with dimensions [rows][cols][3]
%      where the three last indices are the RGB components,
%   For formats of type 'RGB32', an array with dimensions [rows][cols][4],
%      unless fix = true; then the return is [rows][cols][3].  Fix is
%      defaulted to true.
%   For formats of type 'unknown', an array with dimensions [data].
%
%   Note that for 'RGB24' or fix = true (default), the output can be fed
%   to the IMAGE function to display the captured image.
%
%   By default, a UINT8 array is returned.  The following can be specified
%   for datatype: 'uint8', 'single', and 'double'.  For the first, the
%   range of pixel data is 0 to 255.  For the last two, the range of pixel
%   data is rescaled to be 0 to 1.
%
%   All parameters are optional, may be omitted, and only need to be
%   specified in the order given.
%
%   Note that to format the image data, the information returned from
%   FGRABM_FORMATS is used.  The querying and string processing on that
%   structure can be time-consuming.  To speed up the first FGRABM_GRAB
%   operation, call FGRABM_FORMATS or FGRABM_START beforehand to have the
%   information internally cached.
%
%   Note also that if this is called without first calling FGRABM_START,
%   the capture framework is started explicitly to capture one frame.  For
%   capture devices that require warming up, it is recommended to first
%   call FGRABM_START and then to wait using PAUSE before acquiring frames.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

datatype = 'uint8';
device = FGRABM.defaultDevice;
fix = true;
param = 1;
if nargin >= 1
    % Did the user specify a number as the first parameter?
    if isnumeric(varargin{1})
        device = varargin{1};
        param = 2;
    end
end    
if nargin >= param
    % Did the user specify a character string as the next parameter?
    if ischar(varargin{param})
        datatype = varargin{param};
        param = param + 1;
    end
end
if nargin >= param
    % Did the user specify a logical as the last parameter?
    if islogical(varargin{param})
        fix = varargin{param};
        param = param + 1;
    end
end
if nargin >= param
    % Some unclaimed parameters!
    error('Invalid parameter(s) specified.');
end

% Do a quick start/stop if we aren't started already.
oneOffFlag = ~FGRABM.class.getOperState(device);
if oneOffFlag
    FGRABM.class.start(device)
end

% Do the grab:
arr = FGRABM.class.grab(device); % Java returns signed bytes.

% Finish up start/stop if we're doing a one-off:
if oneOffFlag
    FGRABM.class.stop(device)
end

if ~isempty(arr)
    arr = typecast(arr, 'uint8');

    % Do we know the dimensions?
    if ~isfield(FGRABM, 'formats') || length(FGRABM.formats) < device
        fgrabm_formats(device);
    end
    format = FGRABM.class.getFormat(device);
    width = FGRABM.formats{device}(format).width;
    height = FGRABM.formats{device}(format).height;
    type = FGRABM.formats{device}(format).type;

    % Figure out if we need to reshape the bytestream to be IMAGE-compatible:
    secDim = 1;
    if strcmp(type, 'RGB24')
        secDim = 3;
    elseif strcmp(type, 'RGB32')
        secDim = 4;
    end
    if secDim > 1
        arr = reshape(flipud(reshape(arr, secDim, [])),secDim, width, height);
        if fix && secDim > 3
            % Chop off fourth color if we were RGB32:
            arr = arr(1:3, :, :);
        end
        arr = permute(arr, [3 2 1]);
    end

    % Change datatype:
    if strcmp(datatype, 'single') || strcmp(datatype, 'double')
        arr = cast(arr, datatype);
        arr = arr ./ 255;
    elseif ~strcmp(datatype, 'uint8')
        error('Invalid or unsupported datatype.');
    end
end
