% FGRABM_TEST is a short diagnostic for FrameGrabM to verify proper
% functionality.  If FrameGrabM is properly installed, you should see
% information on the default capture device and format appear on the
% console and see a captured frame appear in an image window.  If there is
% a malfunction, an exception should be generated with an explanatory
% message.
%
% Version 0.8 - 06 March 2012

% Initialize the capture framework:
fprintf('Initializing...\n');
fgrabm_init

% Show information on the default capture device:
fprintf('Querying capture devices and showing the first one...\n');
deviceInfos = fgrabm_devices;
deviceInfo = deviceInfos(1)

% Show information on the first format for that device:
fprintf('Querying formats for the default capture device...\n');
formatInfos = fgrabm_formats;
formatInfo = formatInfos(1)

% Start the capture device:
fprintf('Starting continuous capture...\n');
fgrabm_start;

% Wait for the device to warm up:
fprintf('Waiting for the capture device to warm up...\n');
pause(2);

% Grab a frame:
fprintf('Grabbing frame...\n');
myImage = fgrabm_grab();

% Stop and shut down the capture framework:
fprintf('Stopping capture...\n');
fgrabm_stop;
fprintf('Shutting down...\n');
fgrabm_shutdown; % (Shutdown would have stopped the capture, too.)

% Display the image:
fprintf('Displaying frame.\n');
image(myImage);
