function [f_out, facesFlipped] = unifyMeshNormals( varargin )
%UNIFYMESHNORMALS Aligns mesh normals to all point in a consistent direction.
%
% F_OUT = UNIFYMESHNORMALS(F,V) takes an N-by-3 array of faces F, and
% returns an equivalent set of faces F_OUT with all adjacent faces in F_OUT
% pointing in a consistent direction. Vertices V are also required in "in"
% or "out" face alignment is specified (see below).
%
% FV_OUT = UNIFYMESHNORMALS(FV) instead take a structure array with field
% "faces" (and "vertices"), returning that structure with adjacent faces
% aligned consistently as above.
%
% [F_OUT, FLIPPED] = UNIFYMESHNORMALS(...) also returns FLIPPED, an N-by-1
% logical mask showing which faces in F/FV were flipped during unification.
%
% [...] = UNIFYMESHNORMALS(...,'alignTo','in')
% [...] = UNIFYMESHNORMALS(...,'alignTo','out')
% [...] = UNIFYMESHNORMALS(...,'alignTo',FACE) allows the user to specify a
% single trusted FACE number which will remain unflipped, and all other
% faces will be aligned to it. FACE may also be the string 'in' or 'out'.
% 'in' will result in all faces aligned, with direction towards the center
% of the object. 'out' will result in directions pointing outwards.
%
%   Example:
%       tmpvol = zeros(20,20,20);       % Empty voxel volume
%       tmpvol(5:15,8:12,8:12) = 1;     % Turn some voxels on
%       tmpvol(8:12,5:15,8:12) = 1;
%       tmpvol(8:12,8:12,5:15) = 1;
%       fv = isosurface(tmpvol, 0.99);  % Create the patch object
%       % Display patch object normal directions
%       facets = fv.vertices';
%       facets = permute(reshape(facets(:,fv.faces'), 3, 3, []),[2 1 3]);
%       edgeVecs = facets([2 3 1],:,:) - facets(:,:,:);
%       allFacNorms = bsxfun(@times, edgeVecs(1,[2 3 1],:), edgeVecs(2,[3 1 2],:)) - ...
%           bsxfun(@times, edgeVecs(2,[2 3 1],:), edgeVecs(1,[3 1 2],:));
%       allFacNorms = bsxfun(@rdivide, allFacNorms, sqrt(sum(allFacNorms.^2,2)));
%       facNorms = num2cell(squeeze(allFacNorms)',1);
%       facCents = num2cell(squeeze(mean(facets,1))',1);
%       facEdgeSize = mean(reshape(sqrt(sum(edgeVecs.^2,2)),[],1,1));
%       figure
%       patch(fv,'FaceColor','g','FaceAlpha',0.2), hold on, quiver3(facCents{:},facNorms{:},facEdgeSize), view(3), axis image
%       title('All normals point IN')
%       % Turn over some random faces to point the wrong way
%       flippedFaces = rand(size(fv.faces,1),1)>0.75;
%       fv_turned = fv;
%       fv_turned.faces(flippedFaces,:) = fv_turned.faces(flippedFaces,[2 1 3]);
%       figure, patch(fv_turned,'FaceColor','flat','FaceVertexCData',double(flippedFaces))
%       colormap(summer), caxis([0 1]), view(3), axis image
%       % Fix them to all point the same way
%       [fv_fixed, fixedFaces] = unifyMeshNormals(fv_turned);
%       figure, patch(fv_fixed,'FaceColor','flat','FaceVertexCData',double(xor(flippedFaces,fixedFaces)))
%       colormap(summer), caxis([0 1]), view(3), axis image
%
%   See also SPLITFV, INPOLYHEDRON, STLWRITE

%   Copyright Sven Holcombe
%   $Date: 2013/07/3 $

%% Extract f and v

[f,v,options] = parseInputs(varargin{:});

% Get the list of all edges to all faces. Boundary edges will belong to
% only one face. Shared edges SHOULD have one face with the edge given in
% ascending order, one face with it given in descending order.
facesSz = size(f);
numFaces = size(f,1);
fromCols = 1:facesSz(2);
toCols = circshift(fromCols,[0 -1]);
edges = cat(3, f(:,fromCols), f(:,toCols));
% Work out which edges are ordered in ascending order
[~,tmpMinIdx] = min(edges,[],3);
edgeAscOrderMask = tmpMinIdx==1;
% Get edges in list form, and work out which edges partner with each other
edgesFlat = reshape(edges,[],2);
edgesFlat(~edgeAscOrderMask,:) = edgesFlat(~edgeAscOrderMask,[2 1]);
[~,~,edgeGrpNos] = unique(edgesFlat,'rows');
% Determine which edges are nicely partnered (asc/desc), and the face
% number that they link to.
edgeGrpIsUnified = false(size(edgeGrpNos));
numEdges = size(edgesFlat,1);
edgePartnerFaceNo = deal(nan(numEdges,1));
for i = 1:max(edgeGrpNos)
    mask = edgeGrpNos==i;
    edgeGrpIsUnified(mask) = nnz(mask)==2 && sum(edgeAscOrderMask(mask))==1;
    inds = find(mask);
    if length(inds)==2
        [edgePartnerFaceNo(inds),~] = ind2sub(facesSz, flipud(inds));
    end
end

%% Collect connected faces/edges
% March from the first face to each of its nicely (asc/desc) connected
% neighbour faces. Label each connected "set" of faces.
faceSets = zeros(numFaces,1,'uint32');
currentSet = 0;
facesLocked = false(numFaces,1);
edgesConsidered = false(numEdges,1);
currFaces = [];

while any(~facesLocked)
    % If we're not connected to anything, we must start a new set
    if isempty(currFaces)
        currFaces = find(~facesLocked,1);
        currentSet = currentSet + 1;
    end
    facesLocked(currFaces) = true;
    faceSets(currFaces) = currentSet;
    % Grab the edges of the current faces
    currEdgeInds = bsxfun(@plus, currFaces, 0:numFaces:numEdges-1);
    % Find which edges are nicely connected to unvisited faces
    currEdgeIndsToFollowMask = edgeGrpIsUnified(currEdgeInds) & ~edgesConsidered(currEdgeInds);
    % Show that we've visited all edges of the current faces
    edgesConsidered(currEdgeInds) = true;
    % Determine the new faces we would reach if we stepped via nice edges
    linkedFaces = edgePartnerFaceNo(currEdgeInds(currEdgeIndsToFollowMask));
    currFaces = linkedFaces(~isnan(linkedFaces) & ~facesLocked(linkedFaces));
end

%% Work out which sets need to be flipped and which stay the same
[setsTouched, setsToFlip] = deal(false(currentSet,1));
currentSets = [];

while any(~setsTouched)
    % If no current sets, pick the first one available. Any (next) sets
    % found touching it will need to be flipped
    if isempty(currentSets)
        currentSets = find(~setsTouched,1,'first');
        flipTheNextSet = true;
    end
    % We've now touched the current sets. Find these sets' faces.
    setsTouched(currentSets) = true;
    setsFaceInds = find(ismember(faceSets, currentSets));
    % Find edges that border these faces (includes edges from other sets)
    edgeIndsSharingBorder = find(ismember(edgePartnerFaceNo, setsFaceInds));
    % Find all the faces that share these edges
    [faceNosSharingBorder,~] = ind2sub(facesSz, edgeIndsSharingBorder);
    unqFaceNosSharingBorder = unique(faceNosSharingBorder);
    % Avoid flipping faces on any sets already touched
    unqFaceNosToFlipMask = ~setsTouched(faceSets(unqFaceNosSharingBorder));
    faceNosToFlip = unqFaceNosSharingBorder(unqFaceNosToFlipMask);
    % These will only be the border faces. Get the sets they belong to
    setNosToFlip = unique(faceSets(faceNosToFlip));
    % Flip those sets if we should. The first (root) set WON'T have been
    % flipped. Any touching it WILL get flipped. Any touching *those* will
    % already be in the same direction as the root set, so they WON'T be
    % flipped. The next WILL, WON'T, WILL, WON'T, etc.
    if flipTheNextSet
        setsToFlip(setNosToFlip) = true;
    end
    flipTheNextSet = ~flipTheNextSet;
    % Let the loop continue using the sets we just flipped as a source.
    currentSets = setNosToFlip;
end

%% Perform the actual flipping of all sets that require it
if isnumeric(options.alignTo)
    toFaceNo = options.alignTo;
else
    toFaceNo = 1;
end
facesFlipped = ismember(faceSets, find(setsToFlip));
if facesFlipped(toFaceNo)
    facesFlipped = ~facesFlipped;
end
f(facesFlipped,:) = f(facesFlipped,[2 1 3]);

%% Handle "in" or "out" aligned face normals
if options.inOutAlignment
    % Calculate vols of all tetrahedrons formed by face and mesh centroid
    tetvols = zeros(numFaces, 1);
    v = bsxfun(@minus, v, mean(v,1));    
    for i = 1:numFaces
        tetra = v(f(i, :), :);
        tetvols(i) = det(tetra) / 6;
    end
    totalvol = sum(tetvols);
    
    % If the volume is negative, it means we have faces pointed IN and vice
    % versa. If they asked for the opposite, we need to flip one more time.
    if      totalvol>0 && strcmpi(options.alignTo,'in') || ...
            totalvol<0 && strcmpi(options.alignTo,'out')
        f = f(:,[2 1 3]);
        facesFlipped = ~facesFlipped;
    end
end

%% Return either an FV struct or a faces array, depending on input type
if options.structureInput
    f_out = options.originalStructure;
    f_out.faces = f;
else
    f_out = f;
end

%% Supporting functions
function [faces, vertices, options] = parseInputs(varargin)
% Determine input type
if isstruct(varargin{1}) % unifyMeshNormals('file', FVstruct, ...)
    if ~all(isfield(varargin{1},{'vertices','faces'}))
        error( 'Input should be a faces/vertices structure' );
    end
    faces = varargin{1}.faces;
    vertices = varargin{1}.vertices;
    extraArgs = {'structureInput', true, 'originalStructure', varargin{1}};
    options = parseOptions(varargin{2:end}, extraArgs{:});
elseif isnumeric(varargin{1})
    firstNumInput = cellfun(@isnumeric,varargin);
    firstNumInput(find(~firstNumInput,1):end) = 0; % Only consider numerical input PRIOR to the first non-numeric
    numericInputCnt = nnz(firstNumInput);    
    options = parseOptions(varargin{numericInputCnt+1:end});
    switch numericInputCnt
        case 1 % unifyMeshNormals(FACES,...)
            faces = varargin{1};
            vertices = [];
        case 2 % unifyMeshNormals(FACES,VERTICES,...)
            faces = varargin{1};
            vertices = varargin{2};
        otherwise
            error('unifyMeshNormals:badinput', 'First two inputs should be faces/vertices or single structure input.');
    end
end
if options.inOutAlignment && isempty(vertices)
    error('unifyMeshNormals:badinput', 'Faces can only be aligned "in" or "out" if vertice input is also provided.');
end

function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('robust', true)
IP.addParamValue('alignTo', 1)
IP.addParamValue('structureInput', false)
IP.addParamValue('originalStructure', [])
IP.parse(varargin{:});
options = IP.Results;
options.inOutAlignment = ~isnumeric(options.alignTo);
if exist('triangulation','class')
    options.triangulation = @triangulation;
else
    options.triangulation = @TriRep;
end