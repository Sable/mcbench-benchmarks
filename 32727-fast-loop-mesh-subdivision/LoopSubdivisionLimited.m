function [mfRefinedMesh, mnTriangulation] = ...
   LoopSubdivisionLimited( mfMeshPoints, mnTriangulation, fMinResolution, ...
                           vbBoundaryEdges)

% LoopSubdivisionLimited - FUNCTION Perform one round of Loop mesh subdivision, with a resolution limit
%
% Usage: [mfRefinedMesh, mnTriangulation] = ...
%           LoopSubdivisionLimited( mfMeshPoints, mnTriangulation, fMinResolution, ...
%                                   <vbBoundaryEdges>)
%
% This function sub-divides surface meshes, using the Loop subdivision algorithm
% [1].  This algorithm is based on B-spline curve continuity, leading to good
% shape-maintaining smoothing of a surface.  The algorithm attempts to leave the
% boundary of the surface essentially undistorted.
%
% 'mfMeshPoints' is an Nx3 matrix, each row of which ['x' 'y' 'z'] defines a
% point in three-dimensional space.  'mnTriangulation' is a Mx3 matrix, each row
% of which  ['m' 'n' 'p'] defines a triangle existing on the surface, where 'm',
% 'n' and 'p' are indices into 'mfMeshPoints'.
%
% 'fMinResolution' defines the desired minimum length of an edge in the
% final subdivision.  Edges shorter than 'fMinResolution' will not be
% divided further.
%
% The optional argument 'vbBoundaryEdges' identifies which edges should be
% treated as boundary edges (and so should their locations should be attempted
% to be maintained by the algorithm).  This argument will be calculated by the
% algortihm, if it is not supplied.
%
% 'mfRefinedMesh' will be a Px3 matrix, each row of which specifies a vertex in
% the subdivided mesh.  'mnTringulation' will be a Rx3 matrix, each row of which
% specifies a surface triangle in the subdivided mesh.
%
% Algorithm from [1].
%
% ROOM FOR IMPROVEMENT
% * If you work out how to maintain the vertex and edge adjacency matrices
% through a full subdivision run, then great!  That would speed up subsequent
% runs a great deal, since a lot of the time is spent computing the edge
% adjacency matrix...
%
%
% References
% [1] Loop, C 1987. "Smooth subdivision surfaces based on triangles."  M.S.
%        Mathematics thesis, University of Utah.
%        http://research.microsoft.com/en-us/um/people/cloop/thesis.pdf

% Author: Dylan Muir <dylan@ini.phys.ethz.ch>
% Created: 30th November, 2009

% -- Check arguments

if (nargin < 2)
   disp('*** LoopSubdivisionLimited: Incorrect usage');
   help LoopSubdivisionLimited;
   return;
end

% - Ensure triangulation is all integers
mnTriangulation = round(mnTriangulation);

if ((min(mnTriangulation(:)) < 1) || (max(mnTriangulation(:)) > size(mfMeshPoints, 1)))
   disp('*** LoopSubdivisionLimited: Entries in ''mnTriangulation'' must all be indices for ''mfMeshPoints''.');
   return;
end


% -- Compute edge and adjacency matrices

% - Throw away points not used in the triangulation
vnUsedPoints = unique(mnTriangulation);
mfMeshPoints = mfMeshPoints(vnUsedPoints, :);

% - Renumber points in the triangulation
for (nNewPointNum = 1:numel(vnUsedPoints))
   mnTriangulation(mnTriangulation == vnUsedPoints(nNewPointNum)) = nNewPointNum;
end

% - Record sizes of mesh
nNumMeshPoints = size(mfMeshPoints, 1);
nNumTriangles = size(mnTriangulation, 1);


% - Collect all edges
mnAllEdges = vertcat([mnTriangulation(:, 1:2)   (1:nNumTriangles)'], ...
                     [mnTriangulation(:, 2:3)   (1:nNumTriangles)'], ...
                     [mnTriangulation(:, [3 1]) (1:nNumTriangles)']);

mnAllEdges(:, 1:2) = sort(mnAllEdges(:, 1:2), 2);
                  
% - Collect the edges list
[mnEdges, nul, vnUniqueEdgesIndices] = unique(mnAllEdges(:, 1:2), 'rows'); %#ok<ASGLU>

% - Record number of edges
nNumEdges = size(mnEdges, 1);

% - Compute the vertex adjacency matrix
fprintf(1, '\r--- LoopSubdivisionLimited: Computing vertex adjacency...                     ');

% - Create adjacency matrix as a sparse logical matrix
mbVertexAdjacency = sparse([mnEdges(:, 1); mnEdges(:, 2)], ...
   [mnEdges(:, 2); mnEdges(:, 1)], true, ...
   nNumMeshPoints, nNumMeshPoints);


% -- Record edge lengths
vfEdgeDists = mfMeshPoints(mnEdges(:, 1), :) - mfMeshPoints(mnEdges(:, 2), :);
vfEdgeDists = vfEdgeDists.^2;
vfEdgeDists = sqrt(sum(vfEdgeDists, 2));

% - Only divide edges that are longer than the minimum resolution
vbDividedEdge = vfEdgeDists > fMinResolution;

% - Should we divide any edges?
if (~any(vbDividedEdge))
   % - No, so just return the existing mesh
   mfRefinedMesh = mfMeshPoints;
   fprintf(1, '\r--- LoopSubdivisionLimited: Done.                                       ');
   return;
end

% - Compute the edge/vertex adjacency matrix for divided edges
fprintf(1, '\r--- LoopSubdivisionLimited: Computing edge adjacency...                     ');

% - Create adjacency matrix as a sparse logical matrix
mbEdgeTriAdjacency = sparse(vnUniqueEdgesIndices, mnAllEdges(:, 3), true, nNumEdges, nNumTriangles);


% - Assign boundary edges, if not supplied as an argument
if (~exist('vbBoundaryEdges', 'var') || isempty(vbBoundaryEdges))
   vbPermittedBoundaryEdges = true(nNumEdges, 1);
else
   vbPermittedBoundaryEdges = vbBoundaryEdges;
end

% - Pre-allocate adjacency lists
vnDividedEdges = find(vbDividedEdge);
nNumDividedEdges = numel(vnDividedEdges);
cellAdjacentVerticesList = cell(nNumDividedEdges, 1);
cellAdjacentTrianglesList = cell(nNumDividedEdges, 1);

% - Calculate boundary vertices
vbBoundaryEdgesCalc = (sum(mbEdgeTriAdjacency, 2) == 1);

parfor (nDivEdgeIndex = 1:nNumDividedEdges)
   nEdgeIndex = vnDividedEdges(nDivEdgeIndex);
   
   % - Find the triangles associated with this edge
   vbAdjacentTris = mbEdgeTriAdjacency(nEdgeIndex, :); %#ok<PFBNS>

   % - Check for a boundary edge
   if (vbBoundaryEdgesCalc(nEdgeIndex) && (vbPermittedBoundaryEdges(nEdgeIndex))) %#ok<PFBNS>
      % - Adjacency is only with those points comprising this edge
      vnAdjacentVertices = mnEdges(nEdgeIndex, :); %#ok<PFBNS>

   else
      % - Find all the points comprising those triangles
      vnAdjacentVertices = mnTriangulation(vbAdjacentTris, :); %#ok<PFBNS>
      vnAdjacentVertices = vnAdjacentVertices(:);
   end

   % - Record adjacency
   cellAdjacentVerticesList{nDivEdgeIndex} = ...
      [repmat(nEdgeIndex, numel(vnAdjacentVertices), 1) vnAdjacentVertices(:)];

   cellAdjacentTrianglesList{nDivEdgeIndex} = ...
      [repmat(nEdgeIndex, nnz(vbAdjacentTris), 1) find(vbAdjacentTris)'];
end

% - Complete the edge/triangle adjacency matrix for divided triangles
vbDividedTris = any(mbEdgeTriAdjacency(vbDividedEdge, :), 1)';
vnDividedTris = find(vbDividedTris);
nNumDividedTris = numel(vnDividedTris);

cellDividedTrisAdjacency = cell(nNumDividedTris, 1);

% - Find adjacency for divided triangles
parfor (nDivTriIndex = 1:nNumDividedTris) %#ok<FORPF>
   nTriIndex = vnDividedTris(nDivTriIndex);
   
   vbAllEdgeIndices = mnAllEdges(:, 3) == nTriIndex; %#ok<PFBNS>
   vnAdjacentEdges = vnUniqueEdgesIndices(vbAllEdgeIndices); %#ok<PFBNS>
   
   cellDividedTrisAdjacency{nDivTriIndex} = [vnAdjacentEdges repmat(nTriIndex, numel(vnAdjacentEdges), 1)];
end


% - Construct adjacency matrices
%   Note: Must use logical(sparse(...)), since repeated indices are not
%   supported for logical arrays
mnAdjacentVertices = vertcat(cellAdjacentVerticesList{:});
mbEdgeVertexAdjacency = logical(sparse(mnAdjacentVertices(:, 1), mnAdjacentVertices(:, 2), 1, nNumEdges, nNumMeshPoints));

mnAdjacentTris = vertcat(cellAdjacentTrianglesList{:}, cellDividedTrisAdjacency{:});
mbEdgeTriAdjacency = logical(sparse(mnAdjacentTris(:, 1), mnAdjacentTris(:, 2), 1, nNumEdges, nNumTriangles));

% - Assign boundary edges
if (~exist('vbBoundaryEdges', 'var') || isempty(vbBoundaryEdges))
   vbBoundaryEdges = vbBoundaryEdgesCalc & vbPermittedBoundaryEdges;
end

% - Compute boundary vertices
vnBoundaryVertices = mnEdges(vbBoundaryEdges, :);
vnBoundaryVertices = vnBoundaryVertices(:);
vbBoundaryVertex = logical(sparse(vnBoundaryVertices, 1, 1, nNumMeshPoints, 1));


% -- Perform a round of Loop subdivision over edges

fprintf(1, '\r--- LoopSubdivisionLimited: Performing edge subdivision...                     ');

% - Pre-allocate new vertex matrix and new edges matrix
%   Each edge splits into two, and each triangle adds three new edges

mfParVertices = nan(nNumDividedEdges, 3);

parfor (nDivEdgeIndex = 1:nNumDividedEdges)
   nEdgeIndex = vnDividedEdges(nDivEdgeIndex);
   
   % - Is this a boundary edge?
   if (vbBoundaryEdges(nEdgeIndex)) %#ok<PFBNS>
      % - Get the adjacent points for this edge
      mfAdjacentPoints = mfMeshPoints(mbEdgeVertexAdjacency(nEdgeIndex, :), :); %#ok<PFBNS,PFBNS>

      % - The new vertex is simply the mean of the two adjacent vertices
      mfParVertices(nDivEdgeIndex, :) = mean(mfAdjacentPoints, 1);
      
   else
      % - The new vertex depends on all points adjacent to this edge
      vnAdjacentPoints = find(mbEdgeVertexAdjacency(nEdgeIndex, :));
      mfAdjacentPoints = mfMeshPoints(vnAdjacentPoints, :); 

      % - Find which points are actually connected to this edge
      vnEdgePoints = mnEdges(nEdgeIndex, :); %#ok<PFBNS>
      
      vfWeights = 1/8 * ones(numel(vnAdjacentPoints), 1);
      vfWeights(ismember(vnAdjacentPoints, vnEdgePoints)) = 3/8;
      
      % - The new vertex is the weighted sum of the adjacent vertices
      mfParVertices(nDivEdgeIndex, :) = sum(mfAdjacentPoints .* (nonzeros(vfWeights) * [1 1 1]), 1);
   end
end

% - Record numbering for the new vertices
vnNewVertexNumbers = nan(nNumEdges, 1);
vnNewVertexNumbers(vnDividedEdges) = 1:nNumDividedEdges;
mfNewVertices = mfParVertices;

% mfNewVertices = nan(nNumEdges, 3);
% mfNewVertices(vnDividedEdges, :) = mfParVertices;



% -- Compute the new triangles caused by splitting the existing edges

fprintf(1, '\r--- LoopSubdivisionLimited: Calculating new triangles...                     ');

% - Pre-allocate new triangles matrix
cellNewTriangles = cell(nNumDividedTris, 1);

parfor (nDivTriIndex = 1:nNumDividedTris)
   nTriIndex = vnDividedTris(nDivTriIndex);
   
   % - Find the edge indices and edge vertices for this triangle
   vbEdgeIndices = mbEdgeTriAdjacency(:, nTriIndex); %#ok<PFBNS>
   vnEdgeIndices = find(vbEdgeIndices);
   mnEdgeVertices = mnEdges(vbEdgeIndices, :); %#ok<PFBNS>
   vnTriVertices = mnTriangulation(nTriIndex, :); %#ok<PFBNS>

   % - Find divided edges
   vbWhichEdgesDiv = vbDividedEdge(vnEdgeIndices); %#ok<PFBNS>
   nNumDividedEdges = nnz(vbWhichEdgesDiv);

   % - Pre-allocate shared vertex array
   vbSharedVertex = false(nNumMeshPoints, 1);
   
   % - The number of new triangles to generate
   switch (nNumDividedEdges)
      case 1
         % - Build new triangles
         %   Two new triangles are composed of two existing vertices and the
         %   single added vertex
         mnNewTriangles = nan(2, 3);
         
         % - Find the ID of the inserted vertex
         % - Find the new vertices created by the divided edges
         nNewVertexIndex = nNumMeshPoints + vnNewVertexNumbers(vnEdgeIndices(vbWhichEdgesDiv))'; %#ok<PFBNS>
         
         % - Find the ID of the vertex of the existing triangle shared by the
         % non-divided edge
         vbSharedVertex(:) = false;
         vbSharedVertex(mnEdgeVertices) = true;
         vbSharedVertex(mnEdgeVertices(vbWhichEdgesDiv, :)) = false;
         nSharedVertexIndex = find(vbSharedVertex);
         mbIsSharedVertex = mnEdgeVertices == nSharedVertexIndex;
         
         % - Make a vector of vertices, where the first element is the shared
         % (non-divided) vertex
         vnVertices = [nSharedVertexIndex unique(mnEdgeVertices(~mbIsSharedVertex))'];

         % - Make two new triangles, consisting of the shared vertex, the new
         % vertex and one of the other two vertices
         mnNewTriangles(1, :) = [nSharedVertexIndex vnVertices(2) nNewVertexIndex];
         mnNewTriangles(2, :) = [nSharedVertexIndex vnVertices(3) nNewVertexIndex];
         
      case 2
         % - Build new triangles
         %   Three new triangles are required
         mnNewTriangles = nan(3, 3);
         
         % - Find the ID of the vertex shared by the two divided edges
         vbSharedVertex(:) = false;
         vbSharedVertex(mnEdgeVertices) = true;
         vbSharedVertex(mnEdgeVertices(~vbWhichEdgesDiv, :)) = false;
         nSharedVertexIndex = find(vbSharedVertex);
         mbIsSharedVertex = mnEdgeVertices == nSharedVertexIndex;

         % - Make a vector of vertices, where the first element is the shared
         % vertex
         vnVertices = [nSharedVertexIndex unique(mnEdgeVertices(~mbIsSharedVertex))'];
         
         % - Find the new vertices created by the divided edges
         vnNewVertexIndices = nNumMeshPoints + vnNewVertexNumbers(vnEdgeIndices(vbWhichEdgesDiv))';

         % - One new triangle is composed of the two new vertices and the shared
         % vertex
         mnNewTriangles(1, :) = [nSharedVertexIndex vnNewVertexIndices];
         
         % - Work out which way to split the other slab into two triangles
         mfNewVertexPoints = mfNewVertices(vnNewVertexNumbers(vnEdgeIndices(vbWhichEdgesDiv)), :); %#ok<PFBNS>
         mfOtherVertexPoints = mfMeshPoints(vnVertices(2:3), :); %#ok<PFBNS>
         vfDists = sum((mfNewVertexPoints([1 2], :) - mfOtherVertexPoints([2 1], :)).^2, 2);
         
         if (vfDists(1) <= vfDists(2))
            % - Split between new vertex 1 and old vertex 3
            mnNewTriangles(2, :) = [vnNewVertexIndices vnVertices(3)];
            mnNewTriangles(3, :) = [vnNewVertexIndices(1) vnVertices(2:3)];
         else
            % - Split between new vertex 2 and old vertex 2
            mnNewTriangles(2, :) = [vnNewVertexIndices vnVertices(2)];
            mnNewTriangles(3, :) = [vnNewVertexIndices(2) vnVertices(2:3)];
         end

      case 3
         % - Build new triangles
         %   Three new triangles are composed of one existing vertex and two added
         %   vertices.  The fourth new triangle is composed of three added vertices
         mnNewTriangles = nan(4, 3);

         % - Add the three corner triangles
         for (nTriVertexIndex = 1:3)
            [vnEdges, nul] = find(mnEdgeVertices == vnTriVertices(nTriVertexIndex)); %#ok,NASGU>

            mnNewTriangles(nTriVertexIndex, :) = ...
               [vnTriVertices(nTriVertexIndex) nNumMeshPoints + vnNewVertexNumbers(vnEdgeIndices(vnEdges))'];
         end

         % - Add the central triangle
         mnNewTriangles(4, :) = nNumMeshPoints + vnNewVertexNumbers(vnEdgeIndices(:));
   end
   
   % - Record the triangles added by this division
   cellNewTriangles{nDivTriIndex} = mnNewTriangles;
end

% - Collect all new triangles
mnNewTriangles = vertcat(cellNewTriangles{:});

% - Determine which existing triangles to discard and which should remain
mnKeepTriangles = mnTriangulation(~vbDividedTris, :);


% -- Perform a round of Loop updates over old vertices

fprintf(1, '\r--- LoopSubdivisionLimited: Updating existing vertex locations...                     ');

% - Pre-allocate updated vertices matrix
mfUpdatedVertices = nan(nNumMeshPoints, 3);

parfor (nVertexIndex = 1:nNumMeshPoints)
   % - Find pre-existing adjacent vertices
   mfAdjacentPoints = mfMeshPoints(mbVertexAdjacency(nVertexIndex, :), :); %#ok<PFBNS>
   nNumAdjacentPoints = size(mfAdjacentPoints, 1);
   
   % - Check for a boundary vertex
   if (vbBoundaryVertex(nVertexIndex))
      % - Find the edges along the boundary from this vertex
      vbThisBoundary = any((mnEdges == nVertexIndex), 2) & vbBoundaryEdges;
      
      % - Find the adjacent vertices along the boundary
      vnAdjacentVertices = mnEdges(vbThisBoundary, :);
      vbAdjacentVertices = logical(sparse(vnAdjacentVertices, 1, 1, nNumMeshPoints, 1));
      mfAdjacentVertices = mfMeshPoints(vbAdjacentVertices, :);
      
      % - The updated vertex location is the weighted average of the adjacent
      % boundary vertices
      vfWeights = 1/8 * vbAdjacentVertices;
      vfWeights(nVertexIndex) = 3/4;
      vfWeights = nonzeros(vfWeights);
      vfWeights = vfWeights ./ sum(vfWeights);
      mfUpdatedVertices(nVertexIndex, :) = sum(repmat(vfWeights, 1, 3) .* mfAdjacentVertices, 1);
      
   else
      % - This is an internal vertex

      % - Beta = 3/(8*n) for n > 3; Beta = 3/16 for n == 3
      if (nNumAdjacentPoints > 3)
         fBeta = 3 / (8 * nNumAdjacentPoints);
      else
         fBeta = 3 / 16;
      end

      % - Perform weighted average of adjacent vertices
      mfUpdatedVertices(nVertexIndex, :) = sum(vertcat(  mfMeshPoints(nVertexIndex, :) * (1-nNumAdjacentPoints*fBeta), ...
                                                         mfAdjacentPoints * fBeta), 1);
   end
end


% -- Update vertex and triangulation matrices

% - Assign new vertices and triangles
mfRefinedMesh = vertcat(mfUpdatedVertices, mfNewVertices);
mnTriangulation = vertcat(mnKeepTriangles, mnNewTriangles);

% -- Done!
fprintf(1, '\r--- LoopSubdivisionLimited: Done.                                         \n');

% --- END of LoopSubdivisionLimited.m ---
