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

%% Create Shape Inserter
% Create a |ShapeInserter| System object to draw 
% lanes on the original image.
hShapes = vision.ShapeInserter( ...
                'Shape', 'Lines', ...
                'BorderColor', 'Custom', ...
                'CustomBorderColor', [255 25 25 ], ...
                'Antialiasing', true);
            
%% Configure Video Players
hVidSource = vision.VideoPlayer('Name', 'Source'      );
hVidLanes  = vision.VideoPlayer('Name', 'Algorithm'   );
hVidMex    = vision.VideoPlayer('Name', 'Verification');

%% Setup Replay Loop
NumLoops = 1;
for loopIdx = 1:NumLoops

    % Loop through video frames
    while ~isDone(hvfr)
        % Read Frame
        frameRGB = step(hvfr);
        % and display
        step(hVidSource, frameRGB);

        % Call Lanemarking algorithm
        laneVerticesAlgorithm = lanemarking_Algorithm(frameRGB);
        
        laneImageAlgorithm = step(hShapes, frameRGB, laneVerticesAlgorithm);
        
        step(hVidLanes, laneImageAlgorithm);

        % Verify Mex function
        if exist('lanemarking_Algorithm_mex', 'file') == 3
            laneVerticesVerification = lanemarking_Algorithm_mex(frameRGB);
    
            laneImageVerification = step(hShapes, frameRGB, laneVerticesVerification);
               
            step(hVidMex, laneImageVerification);
        end
    % End While
    end
    
    reset(hvfr);
% end loop
end

%% Release resources
release(hvfr   );
release(hShapes);
