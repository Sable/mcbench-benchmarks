function displayLanes(frameRGB, laneVertices)
% Copyright 2013 MathWorks, Inc. 
persistent hShapes  ;
persistent hVidLanes;

%% Create Shape Inserter
% Create a |ShapeInserter| System object to draw 
% lanes on the original image.
if isempty(hShapes)
    hShapes = vision.ShapeInserter( ...
                    'Shape', 'Lines', ...
                    'BorderColor', 'Custom', ...
                    'CustomBorderColor', [0 255 0], ...
                    'Antialiasing', true);
end

%% Configure Video Players
if isempty(hVidLanes)
    hVidLanes  = vision.VideoPlayer('Name', 'Verification');
end

%% Ensure Video Player is visible
if ~isempty(hVidLanes)
    hVidLanes.show;
end

%% Insert lanes to image
laneImage = step(hShapes, frameRGB, laneVertices);
step(hVidLanes, laneImage);
