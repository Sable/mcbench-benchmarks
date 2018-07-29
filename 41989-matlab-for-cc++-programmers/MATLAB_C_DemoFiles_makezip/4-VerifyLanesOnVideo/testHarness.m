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
hVidSource = vision.VideoPlayer('Name', 'Source'      );
hVidLanes  = vision.VideoPlayer('Name', 'Verification');

%% Replay Loop
NumLoops = 1;
for loopIdx = 1:NumLoops

    % Loop through video frames
    while ~isDone(hvfr)
        % Read Frame and display
        frameRGB = step(hvfr);
        step(hVidSource, frameRGB);
        
        % Call algorithm
        laneVertices = lanemarking_Algorithm(frameRGB);
        
        % Display lanes
        displayLanes(frameRGB, laneVertices);
        
    % End While
    end
    
    reset(hvfr);
%% end loop
end

%% Release resources
release(hvfr   );
