function [isEOf, frame] = readAVIFile() %#codegen

% Copyright 2012 MathWorks, Inc.

persistent hReader;
isEOf = false;

if isempty(hReader)
    hReader = vision.VideoFileReader('viplanedeparture.avi', ...
        'VideoOutputDataType', 'uint8');
end

if ~isDone(hReader)
    frame = step(hReader);
else
    frame = zeros(240, 360, 3, 'uint8');
    isEOf = true;
    reset(hReader);
end

