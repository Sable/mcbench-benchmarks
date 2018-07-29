function [ptbifubest, anglemat, bw] = points_featureangle(bw, radius);

% This function call subfunctions to generate the feature data

se = strel('square', 5);
bw = bwmorph(imdilate(bw, se), 'thin', Inf);

[ptbifu, ptroot] = points_init(bw);
[ptbifubest, anglemat] = points_select(bw, ptbifu, radius, 3);