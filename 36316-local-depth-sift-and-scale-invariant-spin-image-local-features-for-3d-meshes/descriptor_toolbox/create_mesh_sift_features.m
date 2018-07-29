function [ spins, detectedPts, locations,pts,density ] = create_mesh_sift_features(vertex, faces, scale_rat, cscale, opnormals, ExcludeBoundery)
% detects feature locations, and computes ld sift for these points
%Input:
% vertex, faces - input mesh
% scale_rat - a width constant for the SI support (default: 5)
% cscale - 1: use constant scale. 0 - scale invariant. (default: 1)
%Output:
% spins - the sift descriptors (a row for each detected point)
% detectedPts - the indices of points detected by the DOG detector for each
%               level
% locations(:,1) - list of the detected points
% locations(:,2) - list of the scale levels
% locations(:,3) - the local density of each detected point
% pts - same as locations(:,1)
% density - density of each vertex of the mesh
spins = [];
if ~exist('scale_rat','var')
    scale_rat = 5;
end
if ~exist('cscale','var')
    cscale = 0;
end
if ~exist('opnormals','var')
    opnormals = 0;
end
if ~exist('ExcludeBoundery','var')
    ExcludeBoundery = 0;
end
%mesh.vertices = vertex;
%mesh.vertexNormals = compute_normal(vertex,faces)';
normals = compute_normal(vertex,faces)';
% if (opnormals)
%     normals = -normals;
% end
params.ExcludeBoundery = ExcludeBoundery;
[detectedPts, density] = dog(vertex,faces, 20, params);
len = length(detectedPts);
pts=[];
%options.curvature_smoothing = 10;
%[umin,Umax] = compute_curvature(vertex,faces,options);

for ll = 1:len
    if (~isempty(detectedPts{ll}))
        pts = [pts detectedPts{ll}];
        if cscale
            sifttemp{ll} = SiftFeatures(vertex, faces, normals, detectedPts{ll}', scale_rat * cscale * ones(size(density)));
        else
            sifttemp{ll} = SiftFeatures(vertex, faces, normals, detectedPts{ll}', scale_rat * density * sqrt(ll));
        end
         %sifttemp{ll} = SiftFeatures(vertex, faces, normals, Umax,detectedPts{ll}', scale_rat * scale);
    end
end
if opnormals
    for ll = 1:len
        if (~isempty(detectedPts{ll}))
            pts = [pts detectedPts{ll}];
            if cscale
                sifttemp2{ll} = SiftFeatures(vertex, faces, -normals, detectedPts{ll}', scale_rat * cscale * ones(size(density)));
            else
                sifttemp2{ll} = SiftFeatures(vertex, faces, -normals, detectedPts{ll}', scale_rat * density * sqrt(ll));
            end
             %sifttemp{ll} = SiftFeatures(vertex, faces, normals, Umax,detectedPts{ll}', scale_rat * scale);
        end
    end
end
sp2 = length(sifttemp);
kind = 1;
for ind2 = 1:sp2
    sp3 = size(sifttemp{ind2},2);
    for ind3 = 1:sp3
        locations(kind,:) = [detectedPts{ind2}(ind3) ind2 density(detectedPts{ind2}(ind3))];
        kind = kind + 1;
    end
end
if opnormals
    sp2 = length(sifttemp2);
    for ind2 = 1:sp2
        sp3 = size(sifttemp2{ind2},2);
        for ind3 = 1:sp3
            locations(kind,:) = [detectedPts{ind2}(ind3) ind2 density(detectedPts{ind2}(ind3))];
            kind = kind + 1;
        end
    end
end
spins = zeros(kind-1,128);
kind=1;
for ind2 = 1:sp2
    sp3 = size(sifttemp{ind2},2);
    for ind3 = 1:sp3
        spins(kind,:) = sifttemp{ind2}(:,ind3)';
        kind = kind + 1;
    end
end
if opnormals
    sp2 = length(sifttemp2);
    for ind2 = 1:sp2
        sp3 = size(sifttemp2{ind2},2);
        for ind3 = 1:sp3
            spins(kind,:) = sifttemp{ind2}(:,ind3)';
            kind = kind + 1;
        end
    end
end
end

