function testHarness

%% Lane Marking Identification
% One component of future luxury automobile safety
% systems is warning drivers that they are drifting
% between lanes.  To do this, it is first necessary
% to identify where the lanes are.  In this example,
% we will look at identifying the lanes from a image
% of a road. 
%
% Copyright 2007-2013 MathWorks, Inc. 
%

%% Setup
clear

%% Initialize Objects
% Video Reader

hvfr = vision.VideoFileReader('viplanedeparture.avi', ...
    'VideoOutputDataType', 'uint8');

%% Configure Video Players
hVidSource = vision.VideoPlayer('Name', 'Source Image');

%% Setup Replay Loop
NumLoops = 1;
for loopIdx = 1:NumLoops

    % Loop through video frames
    while ~isDone(hvfr)
        % Read Frame
        frameRGB = step(hvfr);
        % and display
        step(hVidSource, frameRGB);
        
        % Call Lane Marking Algorithm
        laneMarkingAlgorithmWithVisualization(frameRGB);
        
    % End While
    end
    
    reset(hvfr);
% end loop
end

%% Release resources
release(hvfr   );
