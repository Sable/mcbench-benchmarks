function lane_idx = findlanes(bbox, Major, Minor) %#codegen
% function lanes=findlanes(B,h, stats)
% Find the regions that look like lanes

% Copyright 2006-2013 MathWorks, Inc.

% Pre-allocate return vector
num_blobs = size(bbox, 1);
lane_idx = false(num_blobs, 1);

for k = 1:num_blobs
    metric = abs(Major(k)/Minor(k));
    
    bottom_of_blob = bbox(k, 2) + bbox(k, 4);
    
    if metric > 2 && all(bottom_of_blob > 100)
        lane_idx(k) = true;
    end
end

end
