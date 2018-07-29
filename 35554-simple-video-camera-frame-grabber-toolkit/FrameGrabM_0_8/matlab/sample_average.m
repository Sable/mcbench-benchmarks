% SAMPLE_AVERAGE uses FrameGrabM to grab a series of frames and averages
% them together to reduce the amount of noise that may appear in the image.
% This is especially useful in low-light situations.  This also shows a
% technique for preallocation of memory to ensure that consecutive frames
% are captured without gaps in time.
%
% Version 0.8 - 06 March 2012

% FRAMECONSEC is the number of consecutive frames to grab in each cycle:
FRAMECONSEC = 10;

% MYDEVICE is the capture device index that I want to use:
MYDEVICE = 1;

% MYFORMAT is the format index that I want to use for MYDEVICE:
MYFORMAT = 1;

% Initialize the capture framework:
fprintf('Initializing...\n');
fgrabm_init

% You can set the desired capture device and framework here:
fgrabm_setdefault(MYDEVICE);
fgrabm_setformat(MYFORMAT);

% Get the format information so we can preallocate memory:
fprintf('Allocating buffer...');
formatInfos = fgrabm_formats;
formatInfo = formatInfos(MYFORMAT);
capArray = zeros([formatInfo.height formatInfo.width 3 FRAMECONSEC], ...
    'uint8');

% We'll grab in the native format and do calculation later to avoid losing
% frames.
fprintf('Starting continuous capture...\n');
fgrabm_start;

% Wait for the device to warm up:
fprintf('Waiting for the capture device to warm up...\n');
pause(2);

% Grab the frames:
fprintf('Grabbing %d frames...\n', FRAMECONSEC);
for index = 1:FRAMECONSEC
    capArray(:, :, :, index) = fgrabm_grab();
end

% Shut down capturing:
fgrabm_shutdown

% Now average together the frames and normalize.  We will use a loop here
% and convert to floating point frame by frame so as to avoid precision
% loss.  Although we could cast the entire capArray, that would be more
% expensive than necessary.
fprintf('Calculating average...\n');
outArray = zeros([formatInfo.height formatInfo.width 3]);
for index = 1:FRAMECONSEC
    outArray = outArray + cast(capArray(:, :, :, index), 'double');
end
minVal = min(min(min(outArray)));
maxVal = max(max(max(outArray)));
outArray = (outArray - minVal) ./ (maxVal - minVal);

% Display the image:
fprintf('Displaying result...\n');
image(outArray);
