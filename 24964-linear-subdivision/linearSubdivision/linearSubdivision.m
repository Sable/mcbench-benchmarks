function [newVertices, newFaces] =  linearSubdivision(vertices, faces)
% Linear subdivision for triangle meshes
%
%  Dimensions:
%    vertices: 3xnVertices
%    faces:    3xnFaces
%  
%  Author: Jesus Mena

	global edgeVertex;
    global newIndexOfVertices;
	newFaces = [];
	newVertices = vertices;

	nVertices = size(vertices,2);
	nFaces    = size(faces,2);
	edgeVertex= zeros(nVertices, nVertices);
	newIndexOfVertices = nVertices;

    % ------------------------------------------------------------------------ %
	% create a matrix of edge-vertices and a new triangulation (newFaces).
    % 
    % * edgeVertex(x,y): index of the new vertex between (x,y)
    %
    %  0riginal vertices: va, vb, vc.
    %  New vertices: vp, vq, vr.
    %
    %      vb                   vb             
    %     / \                  /  \ 
    %    /   \                vp--vq
    %   /     \              / \  / \
    % va ----- vc   ->     va-- vr --vc 
	%
    
	for i=1:nFaces
		[vaIndex, vbIndex, vcIndex] = deal(faces(1,i), faces(2,i), faces(3,i));
		
		vpIndex = addEdgeVertex(vaIndex, vbIndex);
		vqIndex = addEdgeVertex(vbIndex, vcIndex);
		vrIndex = addEdgeVertex(vaIndex, vcIndex);
		
		fourFaces = [vaIndex,vpIndex,vrIndex; vpIndex,vbIndex,vqIndex; vrIndex,vqIndex,vcIndex; vrIndex,vpIndex,vqIndex]';
		newFaces  = [newFaces, fourFaces]; 
    end;
    	
    % ------------------------------------------------------------------------ %
	% positions of the new vertices
	for v1=1:nVertices-1
		for v2=v1:nVertices
			vNIndex = edgeVertex(v1,v2);
            if (vNIndex~=0)
 				newVertices(:,vNIndex) = 1/2*(vertices(:,v1)+vertices(:,v2));
            end;
        end;
    end;
 	
end

% ---------------------------------------------------------------------------- %
function vNIndex = addEdgeVertex(v1Index, v2Index)
	global edgeVertex;
	global newIndexOfVertices;

	if (v1Index>v2Index) % setting: v1 <= v2
		vTmp = v1Index;
		v1Index = v2Index;
		v2Index = vTmp;
	end;
	
	if (edgeVertex(v1Index, v2Index)==0)  % new vertex
		newIndexOfVertices = newIndexOfVertices+1;
		edgeVertex(v1Index, v2Index) = newIndexOfVertices;
	end;

	vNIndex = edgeVertex(v1Index, v2Index);

    return;
end
