function laneVertices = lanemarking_Algorithm(frameRGB) %#codegen

% Copyright 2012-2013 MathWorks, Inc.

persistent hColor;
persistent hBlob;
persistent hThresh;

%%
% Create a |ColorSpaceConverter| System object to
% convert the RGB image to an intensity image.
if isempty(hColor)
    hColor = vision.ColorSpaceConverter( ...
                   'Conversion', 'RGB to intensity');
end

%%
% Create an |AutoThresholder| system object to 
% convert intensity image to black and white image
if isempty(hThresh)
    hThresh = vision.Autothresholder;
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
        binary = step(hThresh, frameGray);
%         level = graythresh(frameGray) * intmax(class(frameGray));
%         binary = frameGray > level;
        
        %% Perform blob detection
        [bbox, Major, Minor, Orientation] = step(hBlob, binary);

        %% Find lanes
        laneIndex = findlanes(bbox, Major, Minor);
        
        %% Mark Lanes on original image
        laneVertices = getLaneVerticies(bbox(laneIndex, :), Orientation(laneIndex));
        laneVertices = int32(laneVertices);
