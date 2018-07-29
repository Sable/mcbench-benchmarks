function labelmap = points_show(bw, pt, R, TagBw)

% This function displays the detected points using a rectangular grid

if (nargin == 3)
   TagBw = true; 
end

[M, N]= size(bw);
imdim = M*N + 1;

% Define a square area of (2R+1)*(2R+1)
% Note: a bug when in image border
Neighbor = [R*M+R:-1:R*M-R, (R-1)*M-R:-M:-(R-1)*M-R, -R*M-R:1:-R*M+R, -(R-1)*M+R:M:(R-1)*M+R];
Len = prod(size(Neighbor));

seeds = pt;
npix = prod(size(seeds));
labelmap = zeros(size(bw));

for k = 1:npix
    localidx = seeds(k);
    neighidx = localidx + Neighbor;
    for i=1:Len
        idx = neighidx(i);
        if (idx>0) & (idx<imdim)
            labelmap(idx) = k;
        end
    end
end

labelmap(seeds) = [1:npix]';

% if TagBw, transform labelmap to binary image,
if (TagBw)
    lablemap = (labelmap>0);
end