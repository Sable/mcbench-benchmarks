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

%%
% Create a |ColorSpaceConverter| System object to
% convert the RGB image to an intensity image.
hColor = vision.ColorSpaceConverter( ...
               'Conversion', 'RGB to intensity');

%%
% Create Blob Detecter

hBlob = vision.BlobAnalysis(            ...
    'MinimumBlobAreaSource',     'Property', ...
    'MinimumBlobArea',           10        , ...
    'MajorAxisLengthOutputPort', true      , ...
    'MinorAxisLengthOutputPort', true      , ...
    'OrientationOutputPort',     true      , ...
    'CentroidOutputPort',        true      , ...
    'BoundingBoxOutputPort',     true      , ...
    'LabelMatrixOutputPort',     false     , ...
    'AreaOutputPort',            false     );

%% Create Shape Inserter
% Create a |ShapeInserter| System object to draw 
% lanes on the original image.
hShapes = vision.ShapeInserter( ...
                'Shape', 'Lines', ...
                'BorderColor', 'Custom', ...
                'CustomBorderColor', [0 255 0], ...
                'Antialiasing', true);
            
%% Configure Video Players
hVidSource = vision.VideoPlayer;
hVidBlobs  = vision.VideoPlayer;
hVidLanes  = vision.VideoPlayer;

%% Setup Replay Loop
NumLoops = 3;
for loopIdx = 1:NumLoops

    % Loop through video frames
    while ~isDone(hvfr)
        % Read Frame
        frameRGB = step(hvfr);
        % and display
        step(hVidSource, frameRGB);
        
        % Convert to Intensity
        frameGray = step(hColor, frameRGB);

        % Thresholding image using Otsu's method
        level = graythresh(frameGray) * intmax(class(frameGray));
        binary = frameGray > level;
        
        % Perform blob detection
        [centroid, bbox, Major, Minor, Orientation] = step(hBlob, binary);
        step(hVidBlobs, binary);

        % Find lanes
        laneIndex = findlanes(bbox, Major, Minor);
        
        numLanes = sum(laneIndex);

        % Mark Lanes on original image
        laneVertices = getLaneVerticies(bbox(laneIndex, :), Orientation(laneIndex));
        laneVertices = int32(laneVertices);
        
        laneImage = step(hShapes, frameRGB, laneVertices);
        step(hVidLanes, laneImage);
        
    % End While
    end
    
    reset(hvfr);
% end loop
end

%% Release resources
release(hvfr   );
release(hColor );
release(hBlob  );
release(hShapes);
