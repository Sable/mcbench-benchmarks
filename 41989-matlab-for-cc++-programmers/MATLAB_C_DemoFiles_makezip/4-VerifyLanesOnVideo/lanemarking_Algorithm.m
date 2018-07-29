function laneVertices = lanemarking_Algorithm(frameRGB)
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

%% Initialize Objects
persistent hColor;
persistent hBlob ;

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


