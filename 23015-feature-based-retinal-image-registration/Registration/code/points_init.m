function [ptbifu, ptroot] = points_init(bw)

% This function initializes the feature points from the binary image

[M, N]= size(bw);
imdim = M*N + 1;

Neighbor = [-M, 1, M, -1, -1-M, 1-M,  1+M, -1+M];
Len = prod(size(Neighbor));

seeds = find(bw == 1);
npix = prod(size(seeds));
countmap = zeros(size(bw));

for k =1:npix
    localidx = seeds(k);
    neighidx = localidx + Neighbor;
    for i=1:Len
        idx = neighidx(i);
        if (idx>0) & (idx<imdim) & (bw(idx) ==1)
            countmap(localidx) = countmap(localidx)+1;
        end
    end
end

% The bifurcation candidates may connect, but only the central is true
% bifurcation point
bw1 = (countmap>=3);
[labelmap, numlabel] = bwlabel(bw1, 8);
for i=1:numlabel
    candidates = find(labelmap==i);
    ptbifu(i) = candidates(fix((end+1)/2));
end

ptroot = find(countmap == 1);

ptbifu = ptbifu(:);
ptroot = ptroot(:);