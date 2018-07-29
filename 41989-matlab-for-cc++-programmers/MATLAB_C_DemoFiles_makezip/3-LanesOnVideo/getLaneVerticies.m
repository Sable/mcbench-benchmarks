function laneVertices = getLaneVerticies(bbox, Orientation)

% Copyright 2012-2013 MathWorks, Inc.

numLines = size(bbox, 1);
laneVertices = zeros(numLines, 4);

for idx = 1:numLines
    x = bbox(idx, 1);
    y = bbox(idx, 2);
    w = bbox(idx, 3);
    h = bbox(idx, 4);
    
    if Orientation(idx) >= 0
%         laneVertices(idx, :) = [x y x+w y+h];
laneVertices(idx, :) = [x+w y x y+h];
    else
        laneVertices(idx, :) = [x+w y+h x y];
    end
end