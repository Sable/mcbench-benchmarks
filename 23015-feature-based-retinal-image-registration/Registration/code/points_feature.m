function [outlinktable, outfeaturemat, bw] = points_feature(bw, radius);

% This function call subfunctions to generate the feature data

se = strel('square', 5);
bw = bwmorph(imdilate(bw, se), 'thin', Inf);

[ptbifu, ptroot] = points_init(bw);
ptbifubest = points_select(bw, ptbifu, radius, 3);

pt1 = points_select(bw, ptroot, radius, 1);
pt2 = points_select(bw, ptbifu, radius, 4);
%ptmargbest = [pt1; pt2]; 
ptmargbest = []; %disable the terminal point 

[linktable, featuremat] = points_link(bw, ptbifubest, ptmargbest, radius);

% Only slect those with 3 branches
outlinktable = [];
outfeaturemat = [];
for k = 1:size(linktable, 1)
    if (linktable(k,2) == 3)
        outlinktable  = [outlinktable; linktable(k,:)];
        outfeaturemat = [outfeaturemat; featuremat(k,:)];
    end
end