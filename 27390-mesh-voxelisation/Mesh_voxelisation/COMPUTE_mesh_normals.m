function [coordNORMALS,varargout] = COMPUTE_mesh_normals(meshdataIN,invertYN)
% COMPUTE_mesh_normals  Calculate the normals for each facet of a triangular mesh
%==========================================================================
% AUTHOR        Adam H. Aitkenhead
% CONTACT       adam.aitkenhead@physics.cr.man.ac.uk
% INSTITUTION   The Christie NHS Foundation Trust
% DATE          March 2010
% PURPOSE       Calculate the normal vectors for each facet of a triangular
%               mesh.  The ordering of the vertices
%               (clockwise/anticlockwise) is also checked for all facets if
%               this is requested as one of the outputs.
%
% USAGE         [coordNORMALS] = COMPUTE_mesh_normals(meshdataIN)
%       ..or..  [coordNORMALS,meshdataOUT] = COMPUTE_mesh_normals(meshdataIN,invertYN)
%
% INPUTS
%
%    meshdataIN   - (structure)  Structure containing the faces and
%                   vertices of the mesh, in the same format as that
%                   produced by the isosurface command.
%         ..or..  - (Nx3x3 array)  The vertex coordinates for each facet,
%                   with:  1 row for each facet
%                          3 columns for the x,y,z coordinates
%                          3 pages for the three vertices
%    invertYN     - (optional)  A flag to say whether the mesh is to be
%                   inverted or not.  Should be 'y' or 'n'.
%
% OUTPUTS
%
%    coordNORMALS - Nx3 array   - The normal vectors for each facet, with:
%                          1 row for each facet
%                          3 columns for the x,y,z components
%
%    meshdataOUT  - (optional)  - The mesh data with the ordering of the
%                   vertices (clockwise/anticlockwise) checked.  Uses the
%                   same format as <meshdataIN>.
%
% NOTES       - Computing <meshdataOUT> to check the ordering of the
%               vertices in each facet may be slow for large meshes.
%             - It may not be possible to compute <meshdataOUT> for
%               non-manifold meshes.
%==========================================================================

%==========================================================================
% VERSION  USER  CHANGES
% -------  ----  -------
% 100331   AHA   Original version
% 101129   AHA   Can now check the ordering of the facet vertices.
% 101130   AHA   <meshdataIN> can now be in either of two formats.
% 101201   AHA   Only check the vertex ordering if that is required as one
%                of the outputs, as it can be slow for large meshes.
% 101201   AHA   Add the flag invertYN and make it possible to invert the
%                mesh
% 111004   AHA   Housekeeping tidy-up
%==========================================================================

%======================================================
% Read the input parameters
%======================================================

if isstruct(meshdataIN)==1
  faces         = meshdataIN.faces;
  vertex        = meshdataIN.vertices;
  coordVERTICES = zeros(size(faces,1),3,3);
  for loopa = 1:size(faces,1)
    coordVERTICES(loopa,:,1) = vertex(faces(loopa,1),:);
    coordVERTICES(loopa,:,2) = vertex(faces(loopa,2),:);
    coordVERTICES(loopa,:,3) = vertex(faces(loopa,3),:);
  end
else
  coordVERTICES = meshdataIN;
end

%======================================================
% Invert the mesh if required
%======================================================

if exist('invertYN','var')==1 && isempty(invertYN)==0 && ischar(invertYN)==1 && ( strncmpi(invertYN,'y',1)==1 || strncmpi(invertYN,'i',1)==1 )
  coV           = zeros(size(coordVERTICES));
  coV(:,:,1)    = coordVERTICES(:,:,1);
  coV(:,:,2)    = coordVERTICES(:,:,3);
  coV(:,:,3)    = coordVERTICES(:,:,2);
  coordVERTICES = coV;
end

%======================
% Initialise array to hold the normal vectors
%======================

facetCOUNT   = size(coordVERTICES,1);
coordNORMALS = zeros(facetCOUNT,3);

%======================
% Check the vertex ordering for each facet
%======================

if nargout==2
  startfacet  = 1;
  edgepointA  = 1;
  checkedlist = false(facetCOUNT,1);
  waitinglist = false(facetCOUNT,1);

  while min(checkedlist)==0
    
    checkedlist(startfacet) = 1;

    edgepointB = edgepointA + 1;
    if edgepointB==4
      edgepointB = 1;
    end
    
    %Find points which match edgepointA
    sameX = coordVERTICES(:,1,:)==coordVERTICES(startfacet,1,edgepointA);
    sameY = coordVERTICES(:,2,:)==coordVERTICES(startfacet,2,edgepointA);
    sameZ = coordVERTICES(:,3,:)==coordVERTICES(startfacet,3,edgepointA);
    [tempa,tempb] = find(sameX & sameY & sameZ);
    matchpointA = [tempa,tempb];
    matchpointA = matchpointA(matchpointA(:,1)~=startfacet,:);
  
    %Find points which match edgepointB
    sameX = coordVERTICES(:,1,:)==coordVERTICES(startfacet,1,edgepointB);
    sameY = coordVERTICES(:,2,:)==coordVERTICES(startfacet,2,edgepointB);
    sameZ = coordVERTICES(:,3,:)==coordVERTICES(startfacet,3,edgepointB);
    [tempa,tempb] = find(sameX & sameY & sameZ);
    matchpointB = [tempa,tempb];
    matchpointB = matchpointB(matchpointB(:,1)~=startfacet,:);
  
    %Find edges which match both edgepointA and edgepointB -> giving the adjacent edge
    [memberA,memberB] = ismember(matchpointA(:,1),matchpointB(:,1));
    matchfacet = matchpointA(memberA,1);
  
    if numel(matchfacet)~=1
      if exist('warningdone','var')==0
        warning('Mesh is non-manifold.')
        warningdone = 1;
      end
    else
      matchpointA = matchpointA(memberA,2);
      matchpointB = matchpointB(memberB(memberA),2);
      
      if checkedlist(matchfacet)==0 && waitinglist(matchfacet)==0
        %Ensure the adjacent edge is traveled in the opposite direction to the original edge  
        if matchpointB-matchpointA==1 || matchpointB-matchpointA==-2
          %Direction needs to be flipped
          [ coordVERTICES(matchfacet,:,matchpointA) , coordVERTICES(matchfacet,:,matchpointB) ] = deal( coordVERTICES(matchfacet,:,matchpointB) , coordVERTICES(matchfacet,:,matchpointA) );
        end
      end
    end
  
    waitinglist(matchfacet) = 1;
    
    if edgepointA<3
      edgepointA = edgepointA + 1;
    elseif edgepointA==3
      edgepointA = 1;
      checkedlist(startfacet) = 1;
      startfacet = find(waitinglist==1 & checkedlist==0,1,'first');
    end
  
  end
end

%======================
% Compute the normal vector for each facet
%======================

for loopFACE = 1:facetCOUNT
  
  %Find the coordinates for each vertex.
  cornerA = coordVERTICES(loopFACE,1:3,1);
  cornerB = coordVERTICES(loopFACE,1:3,2);
  cornerC = coordVERTICES(loopFACE,1:3,3);
  
  %Compute the vectors AB and AC
  AB = cornerB-cornerA;
  AC = cornerC-cornerA;
    
  %Determine the cross product AB x AC
  ABxAC = cross(AB,AC);
    
  %Normalise to give a unit vector
  ABxAC = ABxAC / norm(ABxAC);
  coordNORMALS(loopFACE,1:3) = ABxAC;
  
end %loopFACE

%======================================================
% Prepare the output parameters
%======================================================

if nargout==2
  if isstruct(meshdataIN)==1
    [faces,vertices] = CONVERT_meshformat(coordVERTICES);
    meshdataOUT = struct('vertices',vertices,'faces',faces);
  else
    meshdataOUT = coordVERTICES;
  end
  varargout(1) = {meshdataOUT};
end


%======================================================
end %function


