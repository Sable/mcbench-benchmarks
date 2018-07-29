% SAMPLE_TWOCAMS starts capture processes for two cameras and displays
% frames from each.  This sample code requires that two valid capture
% devices be connected to the computer.
%
% Version 0.8 - 06 March 2012

% MYDEVICE1 is the first capture device index that I want to use:
MYDEVICE1 = 1;

% MYFORMAT1 is the format index that I want to use for MYDEVICE1:
MYFORMAT1 = 1;

% MYDEVICE2 is the second capture device index that I want to use:
MYDEVICE2 = 2;

% MYFORMAT2 is the format index that I want to use for MYDEVICE2:
MYFORMAT2 = 1;

% Initialize the capture framework:
fprintf('Initializing...\n');
fgrabm_init

% Set up formats:
fprintf('Setting formats...\n');
fgrabm_setformat(MYDEVICE1, MYFORMAT1);
fgrabm_setformat(MYDEVICE2, MYFORMAT2);

% Begin capturing on both devices:
fprintf('Starting continuous captures...\n');
fgrabm_start(MYDEVICE1);
fgrabm_start(MYDEVICE2);

% Wait for the devices to warm up:
fprintf('Waiting for the capture devices to warm up...\n');
pause(2);

% Grab frames:
fprintf('Grabbing frames...\n');
myImage1 = fgrabm_grab(MYDEVICE1);
myImage2 = fgrabm_grab(MYDEVICE2);

% Stop and shut down the capture framework:
fprintf('Shutting down...\n');
fgrabm_shutdown;

% Display the images:
fprintf('Displaying frames.\n');
image(myImage1);
figure;
image(myImage2);
