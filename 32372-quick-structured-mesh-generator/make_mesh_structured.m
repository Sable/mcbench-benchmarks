
% by Tolga Birdal

% Create a structured mesh out of vertices and use the same technique for
% resizing the mesh.
%
% Description:
% This function creates a structured mesh out of ordered vertices.
% It's useful for dealing with depth maps and treating them as meshes.
% Kinect or ToF cameras would be an option.
% gen_structured_mesh is a C mex file doing the actual meshing.
% It doesnt' produce sorted vertex-face list, so if we really require
% sorting, we should do it separately (a sample which does the sorting is
% also included). To display the mesh, I make use of Dr. Vladimir 
% Bondarenk's drawMesh function.

% Usage: 
% The code itself includes the test function. Just run it without any
% parameters. 

% Copyright (c) 2011, Tolga Birdal <http://www.tbirdal.me>

function []=make_mesh_structured()

% generate a random 5x5 mesh vertices
% at this point we don't know what faces are
% this mesh contains no zeros. If there were zeros, they would be
% treated as a disconnection.
[MeshX, MeshY]=meshgrid(1:5,1:5);
MeshZ=rand(5,5); % notice that this is simply a structured mesh already
V=[MeshX(:), MeshY(:), MeshZ(:)];

% generate the faces in a structured manner
[V1,F1]=gen_structured_mesh (MeshZ); 
F1=F1+1; % shift to matlab indexing

% create and interpolate the mesh to be 10x10
[V2, F2]=create_structured_mesh_sorted(V, 100);

% display both meshes
figure, drawMesh(V1,F1,'wire');
figure, drawMesh(V2,F2,'wire');

end

% create an interpolated/sorted structured mesh, given the ordered vertices
% and the new dimension of the mesh. In other sense, it could also be
% viewed as a simiple mesh refinement.
% Notice that this sample requires a square mesh. sqrt(length(V)) should
% be an integer.
function [Vs, Fs]=create_structured_mesh_sorted(V, newDim)

% first interpolate the vertices
dim=sqrt(length(V));
samples=linspace(1,dim,newDim);
NV1=reshape(V(:,1), dim,dim)';
NV2=reshape(V(:,2), dim,dim)';
NV3=reshape(V(:,3), dim,dim)';
[X,Y]=meshgrid(samples,samples);
NV1=interp2(NV1,X,Y);
NV2=interp2(NV2,X,Y);
NV3=interp2(NV3,X,Y);

% now create the faces. mesh values have no importance here.
[VsT,FsT]=points_to_mesh_structured (ones(size(X))); FsT=FsT+1;
Fs=FsT;

% optionally sort the faces to be in order. this part is really optional.
[S I]=sort(VsT(:,2));
for i=1:2*length(samples)
    Fs((FsT==I(i)))=i;
end
Vs(:,1)=reshape(NV1', length(NV1)*length(NV1),1);
Vs(:,2)=reshape(NV2', length(NV2)*length(NV2),1);
Vs(:,3)=reshape(NV3', length(NV3)*length(NV3),1);

end

