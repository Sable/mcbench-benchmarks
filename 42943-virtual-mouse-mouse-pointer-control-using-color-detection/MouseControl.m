%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program Name : Mouse Pointer Control
% Author       : Arindam Bose
% Version      : 5.5
% Copyright    : © 2013, Arindam Bose, All rights reserved.
% Description  : This program controls the functions of mouse pointer
%                by detecting red, green and blue colored caps
% Thanks       : MATLAB Central Submission: Mouse pointer control by light
%                source by Utsav Barman (29777)
%
% MouseControl controls the functions of mouse pointer without
% incorporating the Mouse.
% Inputs: redThresh = Threshold for red color detection
%         greenThresh = Threshold for green color detection
%         blueThresh = Threshold for blue color detection
%         numFrame = Total number of frames duration
%         Set the default values below
% Adjust the value of thresholds for different environments
% Controls: Use 1(One) RED, 1(One) GREEN and 3(Three) BLUE Caps for
%           different fingers.
%           MOVE the RED finger everywhere to control the POINTER POSITION,
%           Show ONE BLUE finger to LEFT CLICK,
%           Show TWO BLUE finger to RIGHT CLICK,
%           Show THREE BLUE finger to DOUBLE CLICK,
%           MOVE the GREEN finger up and down to control the MOUSE SCROLL.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MouseControl(redThresh, greenThresh, blueThresh, numFrame)
warning('off','vision:transition:usesOldCoordinates');

%% Initialization
if nargin < 1
    redThresh = 0.22;  % Threshold for Red color detection
    greenThresh = 0.14; % Threshold for green color detection
    blueThresh = 0.18; % Threshold for blue color detection
    numFrame = 300; % Total number of frames duration
end

cam = imaqhwinfo; % Get Camera information
cameraName = char(cam.InstalledAdaptors(end));
cameraInfo = imaqhwinfo(cameraName);
cameraId = cameraInfo.DeviceInfo.DeviceID(end);
cameraFormat = char(cameraInfo.DeviceInfo.SupportedFormats(end));

jRobot = java.awt.Robot; % Initialize the JAVA robot
vidDevice = imaq.VideoDevice(cameraName, cameraId, cameraFormat, ... % Input Video from current adapter
                    'ReturnedColorSpace', 'RGB');

vidInfo = imaqhwinfo(vidDevice);  % Acquire video information
screenSize = get(0,'ScreenSize'); % Acquire system screensize
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Setup blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MaximumBlobArea', 3000, ...
                                'MinimumBlobArea', 100, ...
                                'MaximumCount', 3);
hshapeinsBox = vision.ShapeInserter('BorderColorSource', 'Input port', ... % Setup colored box handling
                                    'Fill', true, ...
                                    'FillColorSource', 'Input port', ...
                                    'Opacity', 0.4);
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Setup output video stream handling
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
nFrame = 0; % Initializing variables
lCount = 0; rCount = 0; dCount = 0;
sureEvent = 5;
iPos = vidInfo.MaxWidth/2;

%% Frame Processing Loop
while (nFrame < numFrame)
    rgbFrame = step(vidDevice); % Acquire single frame
    rgbFrame = flipdim(rgbFrame,2); % Flip the frame for userfriendliness
    diffFrameRed = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red components of the image
    binFrameRed = im2bw(diffFrameRed, redThresh); % Convert the image into binary image with the red objects as white
    [centroidRed, bboxRed] = step(hblob, binFrameRed); % Get the centroids and bounding boxes of the red blobs

    diffFrameGreen = imsubtract(rgbFrame(:,:,2), rgb2gray(rgbFrame)); % Get green components of the image
    binFrameGreen = im2bw(diffFrameGreen, greenThresh); % Convert the image into binary image with the green objects as white
    [centroidGreen, bboxGreen] = step(hblob, binFrameGreen); % Get the centroids and bounding boxes of the blue blobs
    
    diffFrameBlue = imsubtract(rgbFrame(:,:,3), rgb2gray(rgbFrame)); % Get blue components of the image
    binFrameBlue = im2bw(diffFrameBlue, blueThresh); % Convert the image into binary image with the blue objects as white
    [~, bboxBlue] = step(hblob, binFrameBlue); % Get the centroids and bounding boxes of the blue blobs
    
    if length(bboxRed(:,1)) == 1 % Mouse pointer movement routine
        jRobot.mouseMove(1.5*centroidRed(:,1)*screenSize(3)/vidInfo.MaxWidth, 1.5*centroidRed(:,2)*screenSize(4)/vidInfo.MaxHeight);
    end
    if ~isempty(bboxBlue(:,1)) % Left Click, Right Click, Double Click routine
        if length(bboxBlue(:,1)) == 1 % Left Click routine
            lCount = lCount + 1;
            if lCount == sureEvent % Make sure of the left click event
                jRobot.mousePress(16);
                pause(0.1);
                jRobot.mouseRelease(16);
            end
        elseif length(bboxBlue(:,1)) == 2 % Right Click routine
            rCount = rCount + 1;
            if rCount == sureEvent % Make sure of the right click event
                jRobot.mousePress(4);
                pause(0.1);
                jRobot.mouseRelease(4);
            end 
        elseif length(bboxBlue(:,1)) == 3 % Double Click routine
            dCount = dCount + 1;
            if dCount == sureEvent % Make sure of the double click event
                jRobot.mousePress(16);
                pause(0.1);
                jRobot.mouseRelease(16);
                pause(0.2);
                jRobot.mousePress(16);
                pause(0.1);
                jRobot.mouseRelease(16);
            end 
        end
    else
        lCount = 0; rCount = 0; dCount = 0; % Reset the sureEvent counter
    end
    if ~isempty(bboxGreen(:,1)) % Scroll event routine
        if (mean(centroidGreen(:,2)) - iPos) < -2
            jRobot.mouseWheel(-1);
        elseif (mean(centroidGreen(:,2)) - iPos) > 2
            jRobot.mouseWheel(1);
        end
        iPos = mean(centroidGreen(:,2));
    end
    vidIn = step(hshapeinsBox, rgbFrame, bboxRed,single([1 0 0])); % Show the red objects in output stream
    vidIn = step(hshapeinsBox, vidIn, bboxGreen,single([0 1 0])); % Show the green objects in output stream
    vidIn = step(hshapeinsBox, vidIn, bboxBlue,single([0 0 1])); % Show the blue objects in output stream
    step(hVideoIn, vidIn); % Output video stream
    nFrame = nFrame+1;
end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
clc;
end