function [ spins, detectedPts, locations, pts, density ] = create_mesh_spin_features(vertex, faces, bins,scale_rat, cscale,opnormal)
% detects feature locations, and computes spin images for these points
%Input:
% vertex, faces - input mesh
% bins - spin image resolution (default: 5)
% scale_rat - a width constant for the SI support (default: 3)
% cscale - 1: use constant scale. 0 - scale invariant. (default: 1)
%Output:
% spins - the spin images (a row for each detected point)
% detectedPts - the indices of points detected by the DOG detector for each
%               level
% locations(:,1) - list of the detected points
% locations(:,2) - list of the scale levels
% locations(:,3) - the local density of each detected point
% pts - same as locations(:,1)
% density - density of each vertex of the mesh
if size (vertex,2) ~= 3 || size (faces,2) ~= 3
     error('incompetible vertex or faces array size');
end
    
spins = [];
if ~exist('opnormal','var')
    opnormal = 0;
end
if ~exist('cscale','var')
    cscale = 0;
end
if ~exist('scale_rat','var')
    scale_rat = 3;
end
if ~exist('bins','var')
    bins = 5;
end
% mesh.vertices = vertex;
% mesh.vertexNormals = compute_normal(vertex,faces)';
normals = compute_normal(vertex,faces)';
if (opnormal == 1)
    normals = -normals;
end
[detectedPts, density] = dog(vertex,faces, 20);
%detectedPts = detectedPts(2:end);
len = length(detectedPts);
pts=[];
ImageSize = bins;
for ll = 1:len
    if (~isempty(detectedPts{ll}))
        pts = [pts detectedPts{ll}];
        if cscale
            spinstmp{ll} = SpinImages(vertex, normals, detectedPts{ll}',cscale* scale_rat * ones(size(density)) / ImageSize, ImageSize);
        else
            spinstmp{ll} = SpinImages(vertex, normals, detectedPts{ll}', scale_rat*density * sqrt(ll) / ImageSize, ImageSize);
        end
        %spinstmp{ll} = SpinImages(vertex, normals, detectedPts{ll}', scale_rat*scale  / ImageSize, ImageSize);
    end
end

sp2 = length(spinstmp);
kind = 1;
ImageSize2 = ImageSize*ImageSize;
for ind2 = 1:sp2
    sp3 = length(spinstmp{ind2});
    for ind3 = 1:sp3
        spins(kind,:) = reshape(spinstmp{ind2}{ind3},1,ImageSize2);
        locations(kind,:) = [detectedPts{ind2}(ind3) ind2 density(detectedPts{ind2}(ind3))];
        kind = kind + 1;
    end
end
end

