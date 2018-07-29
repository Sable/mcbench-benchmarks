%%	Author:  Tianli Yu	https://netfiles.uiuc.edu/tyu/www/tianli/
%%	Date:	Monday Aug. 01 2005  11:58 pm
%%
%% GetMeshStructure: Get the structure of a triangular mesh from its Face-Vertex index array.
%%		This code only works on orientable surfaces.
%% Input Args:
%%      FacetListM 	-- The Face-Vertices index array (start from vertex index 1)
%%      vertnum     -- the total number of vertices
%%      verbose     -- Whether to output statistics of the mesh.
%% Output Args:
%%      VFVEListA   -- The Vertex to Face-VertexNeighbor-Edge list (a cell array that each cell is a matrix)
%%      EdgeFacetVertexListM -- The Edge to Face-Vertex list, matrix dim = edgeNum x 4 (2 faces and 2 vertices)
%%      FacetEdgeFacetListM  -- The Face to Edge-Face list, matrix dim = faceNum x 6 (3 faces and 3 edges)
%%      VertexDegreeV        -- The degree of each vertex, matrix dim = vertNum x 1

function [VFVEListA, EdgeFacetVertexListM, FacetEdgeFacetListM, VertexDegreeV] = GetMeshStructure(FacetListM, vertnum, verbose)

	if (~exist('verbose'))
		verbose = 'on';
	end
	
	buflength = 10;
	%% 
	facetnum = size(FacetListM, 1);

	disp('Building the auxulary mesh structure list ...');	
%% Initialize and pre-allocation for the Vertex-Facet-Vertex-Edge List
	%% should be an array of zero vector
	VFVEListA = cell(vertnum, 1);
	VertexDegreeV = zeros(vertnum, 1);
	%% some more work here!!!!!
	%% you should pre-allocate an array of several entry list, to prevent too many extend that matlab will automatically do.
	for ii = 1 : vertnum
		VFVEListA{ii} = zeros(buflength, 3);
	end

%% Facet scan, fill the Vertex-Facet-Vertex part
	%% note: the boundary vertex-vertex connection only added in one direction 
	%% since there is no facet on one side of the boundary
	%% need to fix it after edges are created
		
	%% scan all the facet and fill the corresponding vertex
	for ii = 1 : facetnum
		v1 = FacetListM(ii, 1);
		v2 = FacetListM(ii, 2);
		v3 = FacetListM(ii, 3);
		
		VertexDegreeV([v1;v2;v3]) = VertexDegreeV([v1;v2;v3]) + 1;
	
		VFVEListA{v1}(VertexDegreeV(v1), 1:2) = [ii, v2];
		VFVEListA{v2}(VertexDegreeV(v2), 1:2) = [ii, v3];
		VFVEListA{v3}(VertexDegreeV(v3), 1:2) = [ii, v1];
	end
	
	for ii = 1 : vertnum
		VFVEListA{ii} = VFVEListA{ii}(1:VertexDegreeV(ii), :);
	end
	
	%% fill the vertex - edge structure only after edges are created

%% Edge scan, fill the Edge-Facet-Vertex structure, as well as the Facet-Edge-Facet structure

	%% should take into account those boundary edges
	%EdgeFacetVertexListM = zeros(sum(VertexDegreeV) / 2, 4);
	EdgeFacetVertexListM = zeros(sum(VertexDegreeV), 4);
	
	FacetEdgeFacetListM = zeros(facetnum, 6);

	FacetVIndexSumV = sum(FacetListM, 2);
		
	edgeNum = 0;
		
	%% create the edges, fillin the vertices & first facet.
	for ii = 1 : vertnum
		for jj = 1 : VertexDegreeV(ii)
			nVertexIndex = VFVEListA{ii}(jj, 2);
			if ( nVertexIndex > ii)
				edgeNum = edgeNum + 1;
					
				facetIndex = VFVEListA{ii}(jj, 1);
				EdgeFacetVertexListM(edgeNum, :) = [facetIndex, 0, ii, nVertexIndex];
					
				edgePos = find(FacetListM(facetIndex, :) == (FacetVIndexSumV(facetIndex) - ii - nVertexIndex));
				FacetEdgeFacetListM(facetIndex, edgePos) = edgeNum;
				%% Facet-Facet will be filled in the next round, boundary Facet
				%% will default to be zero
				
				% Vertex-Edge info is also filled here, only
				% for those VFVEListA{ii}(jj, 2) > ii, the reverse side edge,
				% however, still need to be filled in
				% the next for loop
				VFVEListA{ii}(jj, 3) = edgeNum;
				index = find(VFVEListA{nVertexIndex}(:, 2) == ii);
				if (isempty(index))
					%VFVEListA{nVertexIndex}(VertexDegreeV(nVertexIndex)+1, :) = [0, ii, edgeNum];
					VFVEListA{nVertexIndex} = [VFVEListA{nVertexIndex}; 0, ii, edgeNum];
					VertexDegreeV(nVertexIndex) = VertexDegreeV(nVertexIndex) + 1;
				else
					VFVEListA{nVertexIndex}(index, 3) = edgeNum;
				end
			end
		end		
	end
		
	%% second round, fillin the second facet
	for ii = 1 : vertnum
		for jj = 1 : VertexDegreeV(ii)
			nVertexIndex = VFVEListA{ii}(jj, 2);
			if ( nVertexIndex < ii)
				index = find(VFVEListA{nVertexIndex}(:, 2) == ii);
											
				if (~isempty(index))
					edgeIndex = VFVEListA{nVertexIndex}(index(1), 3);
					facetIndex = VFVEListA{ii}(jj, 1);
					EdgeFacetVertexListM(edgeIndex, 2) = facetIndex;

					if (facetIndex > 0)
						edgePos = find(FacetListM(facetIndex, :) == (FacetVIndexSumV(facetIndex) - ii - nVertexIndex));
						% debug
						%edgeIndex						
						FacetEdgeFacetListM(facetIndex, edgePos) = edgeIndex;						
						
						nFacetIndex = EdgeFacetVertexListM(edgeIndex, 1);
						FacetEdgeFacetListM(facetIndex, edgePos + 3) = nFacetIndex;
					
						nFacetEdgePos = find(FacetListM(nFacetIndex, :) == (FacetVIndexSumV(nFacetIndex) - ii - nVertexIndex));
						FacetEdgeFacetListM(nFacetIndex, nFacetEdgePos + 3) = facetIndex;
					end
				else
					%% here to deal with those boundary edges (with only one
					%% facet)
					edgeNum = edgeNum + 1;
					facetIndex = VFVEListA{ii}(jj, 1);
					EdgeFacetVertexListM(edgeNum, :) = [facetIndex, 0, nVertexIndex, ii];
						
					edgePos = find(FacetListM(facetIndex, :) == (FacetVIndexSumV(facetIndex) - ii - nVertexIndex));
					FacetEdgeFacetListM(facetIndex, edgePos) = edgeNum;
					
					%% boundary Facet will default have zero as neighbors
					VFVEListA{ii}(jj, 3) = edgeNum;
					index = find(VFVEListA{nVertexIndex}(:, 2) == ii);
					if (isempty(index))
						%VFVEListA{nVertexIndex}(VertexDegreeV(nVertexIndex)+1, :) = [0, ii, edgeNum];
						VFVEListA{nVertexIndex} = [VFVEListA{nVertexIndex}; 0, ii, edgeNum];
						VertexDegreeV(nVertexIndex) = VertexDegreeV(nVertexIndex) + 1;
					else
						VFVEListA{nVertexIndex}(index, 3) = edgeNum;
					end
				end
			end
		end		
	end
		
	%% remove the redudent pre-allocated Edge memory
	EdgeFacetVertexListM = EdgeFacetVertexListM(1:edgeNum, :);
		
	%% display debug statistics
	if (strcmp(verbose, 'on'))
		fprintf(1, 'Facet Count: %d\n', facetnum);
		fprintf(1, 'Vertex Count: %d\n', vertnum);
		fprintf(1, 'Edge Count: %d\n', edgeNum);
		fprintf(1, 'Boundary Edge: %d\n', sum(EdgeFacetVertexListM(:,2) == 0));
		fprintf(1, 'Max Vertex Degree: %d\n', max(VertexDegreeV));
	end
	
	
