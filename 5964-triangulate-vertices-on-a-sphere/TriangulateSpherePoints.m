%% Triangulate a set of points on the unit sphere using idea of stereographical projection
%% http://mathforum.org/epigone/sci.math.num-analysis/hahswimpcrim/32DD70B8.8DC@research.att.com
%%	Author:  Tianli Yu	https://netfiles.uiuc.edu/tyu/www/tianli/
%%	Date:	Monday Aug. 01 2005  11:58 pm
%%
%% Steps:
%% 	1. use the first vertex as projection center, project all the points onto a plane
%%	2. call delaunay triangulation to triangulate those points on the plane
%%	3. fill the hole by connecting the first vertex to the convex hull of the other vertices in the plane
%%
%%	Proof: not yet
%%
%%	Input
%%		VertexM : n x 3 matrix, each row is the 3D coordinates a vertex, assume to have unit norm
%%	Output
%%		FacetM:	m x 3 matrix, each row is the 3 indices (pointers to VertexM) of the facet's vertices
%%
%% Test code:
%%		VertexM = rand(800, 3) - 0.5;
%%		VNormV = (sum(VertexM .^ 2, 2)) .^ .5;
%%		VertexM = VertexM ./ repmat(VNormV, 1, 3);
%%		FacetM = TriangulateSpherePoints(VertexM);
%%		figure;
%%		patch('vertices', VertexM, 'faces', FacetM, 'FaceColor', [1, 1, 0], 'EdgeColor', [1 .2 .2]);
%%		axis equal;
%%
%% Update: The original algorithm might missing one triangle that connected to the first vertex,
%%  the update use a seperate GetMeshStructure function in stead of the convhull to get the all the vertices
%%  on the bounding polygon.

function FacetM = TriangulateSpherePoints(VertexM)

	vertnum = size(VertexM, 1);
	
%% Step 1: projection
	%% select the first vertex as the projection center
	centerRV = VertexM(1, :);
	
	%% build a rotation matrix that rotate the first point to (0, 0, -1)
	R3RV = - centerRV;
	if (centerRV(3) ~= 0)
		R2RV = [0, -R3RV(3), R3RV(2)];
		R2RV = R2RV / norm(R2RV');
	else
		R2RV = [-R3RV(2), R3RV(1), 0];
		R2RV = R2RV / norm(R2RV');
	end
	
	R1RV = cross(R3RV, R2RV, 2);
	RotateM = [R1RV; R2RV; R3RV];

	%% the rotated vertex list	
	RotVM = VertexM(2:vertnum, :) * RotateM';
	
	%% here use the projection center of (0, 0, -1), project all points to z = 0
	%% solve the simple ray-plane intersection equation
	tV = -ones(vertnum-1, 1) ./ (RotVM(:, 3) + 1);
	xV = RotVM(:, 1) .* tV;
	yV = RotVM(:, 2) .* tV;
	
%% Step 2: triangulate the projected points
	FacetM = delaunay(xV, yV);

	%% reorient the facet surfaces
	%% make all the surface normal consistantly point to +z direction
	VM = [xV, yV, zeros(vertnum-1, 1)];
	
	Vec1M = VM(FacetM(:, 1), :) - VM(FacetM(:, 2), :);
	Vec2M = VM(FacetM(:, 3), :) - VM(FacetM(:, 2), :);
	SurfaceNormalM = cross(Vec1M, Vec2M, 2);

	reversedFacetIndexV = find(SurfaceNormalM(:,3) < 0);
	FacetM(reversedFacetIndexV, :) = fliplr(FacetM(reversedFacetIndexV, :));

%% Step 3: triangulate the last several missed triangles, by connecting the projection
%% center to all the convex hull vertices.

	%% use getMeshStructure5 to get the boundary edge/vertices
	FacetM = FacetM + 1;
	[VFVEListA, EdgeFacetVertexListM, FacetEdgeFacetListM, VertexDegreeV] = GetMeshStructure(FacetM, vertnum, 'off');
	
	BoundaryEdgeIndexV = find(EdgeFacetVertexListM(:, 2) == 0);	
	%% create propertly oriented surface using each edge	
		
	boundNum = length(BoundaryEdgeIndexV);
	HoleFM = zeros(boundNum, 3);
	for edgei = 1 : boundNum
		%% get the orientation from the edge's neighbouring patch
		edgeIndex = BoundaryEdgeIndexV(edgei);
		neighborFIndex = EdgeFacetVertexListM(edgeIndex, 1);
		v1pos = find(FacetM(neighborFIndex, :) == EdgeFacetVertexListM(edgeIndex, 3));
		v2pos = mod(v1pos, 3) + 1;
		if (FacetM(neighborFIndex, v2pos) == EdgeFacetVertexListM(edgeIndex, 4))
			HoleFM(edgei, :) = [1, FacetM(neighborFIndex, v2pos), FacetM(neighborFIndex, v1pos)];
		else
			HoleFM(edgei, :) = [1, FacetM(neighborFIndex, v1pos), EdgeFacetVertexListM(edgeIndex, 4)];
		end	
	end	

	FacetM = fliplr([FacetM; HoleFM]);
	
