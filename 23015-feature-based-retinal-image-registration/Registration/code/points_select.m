function [ptbest, anglemat] = points_select(bw, pt, R, AngleNum)

% This function selects the optimal bifurcation points in the binary image
% R: the raius of search window for each candidates
% Numangle: the number of local point-branch angle within the region
% 1: terminal, 2: branch, 3: bifurcation 

seeds = pt;
npix = prod(size(seeds));

ptbest =[];
anglemat=[];
for k =1:npix
    anglevec = point_anglevec(bw, seeds(k), R); 
    if (prod(size(findangle(anglevec)))== AngleNum)
        ptbest=[ptbest; seeds(k)];
        anglemat=[anglemat;findangle(anglevec)/360];
    end
end