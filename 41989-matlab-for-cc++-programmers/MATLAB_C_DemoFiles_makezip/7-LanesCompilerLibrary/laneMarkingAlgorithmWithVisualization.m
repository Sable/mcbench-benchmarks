function laneMarkingAlgorithmWithVisualization(frameRGB)

persistent hColor;
persistent hBlob;
persistent hShapes;
persistent hVidLanes;

% Copyright 2007-2013 MathWorks, Inc.

%% 
warning('off', 'vision:transition:usesOldCoordinates');

%%
% Create a |ColorSpaceConverter| System object to
% convert the RGB image to an intensity image.
if isempty(hColor)
    hColor = vision.ColorSpaceConverter( ...
        'Conversion', 'RGB to intensity');
end

%%
% Create Blob Detecter
if isempty(hBlob)
    hBlob = vision.BlobAnalysis(            ...
        'MinimumBlobAreaSource',     'Property', ...
        'MinimumBlobArea',           10        , ...
        'MajorAxisLengthOutputPort', true      , ...
        'MinorAxisLengthOutputPort', true      , ...
        'OrientationOutputPort',     true      , ...
        'CentroidOutputPort',        false     , ...
        'BoundingBoxOutputPort',     true      , ...
        'LabelMatrixOutputPort',     false     , ...
        'AreaOutputPort',            false     );
end

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
    hVidLanes = vision.DeployableVideoPlayer('Name', 'Lanes Marked on Image');
end

        %% Convert to Intensity
        frameGray = step(hColor, frameRGB);

        %% Thresholding image using Otsu's method
        level = graythresh(frameGray) * intmax(class(frameGray));
        binary = frameGray > level;
        
        %% Perform blob detection
        [bbox, Major, Minor, Orientation] = step(hBlob, binary);

        %% Find lanes
        laneIndex = findlanes(bbox, Major, Minor);
        
        %% Mark Lanes on original image
        laneVertices = getLaneVerticies(bbox(laneIndex, :), Orientation(laneIndex));
        laneVertices = int32(laneVertices);
        
        laneImage = step(hShapes, frameRGB, laneVertices);
        step(hVidLanes, laneImage);
        
