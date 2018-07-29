function [coordinates,nodes] = MeshRectanglularPlate(L,B,Nx,Ny) 
% To Mesh a Plate using 4 noded Elements 
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%          http://sites.google.com/site/kolukulasivasrinivas/             |    
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Purpose:
%         To Mesh a square/Rectangular plate to use in FEM Analysis
% Synopsis :
%         [coordinates,nodes] = MeshPlate(L,B,Nx,Ny)
% Variable Description:
% Input :
%           L  - Length of the Plate along X-axes
%           B  - Breadth of the Plate along Y-axes
%           Nx - Number of Elements along X-axes
%           Ny - Number of Elements along Y-axes
% Output :
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [node X Y] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [node1 node2......]    
%--------------------------------------------------------------------------
nel = Nx*Ny ;        % Total Number of Elements in the Mesh
nnel = 4 ;           % Number of nodes per Element
% Number of points on the Length and Breadth
npx = Nx+1 ;
npy = Ny+1 ;
nnode = npx*npy ;      % Total Number of Nodes in the Mesh
% Discretizing the Length and Breadth of the plate
nx = linspace(0,L,npx) ;
ny = linspace(0,B,npy) ;
[xx yy] = meshgrid(nx,ny) ;
% To get the Nodal Connectivity Matrix
coordinates = [xx(:) yy(:)] ;
NodeNo = 1:nnode ;
nodes = zeros(nel,nnel) ;
% If elements along the X-axes and Y-axes are equal
if npx==npy
    NodeNo = reshape(NodeNo,npx,npy);
    nodes(:,1) = reshape(NodeNo(1:npx-1,1:npy-1),nel,1);
    nodes(:,2) = reshape(NodeNo(2:npx,1:npy-1),nel,1);
    nodes(:,3) = reshape(NodeNo(2:npx,2:npy),nel,1);
    nodes(:,4) = reshape(NodeNo(1:npx-1,2:npy),nel,1);
% If the elements along the axes are different
else%if npx>npy
    NodeNo = reshape(NodeNo,npy,npx);
    nodes(:,1) = reshape(NodeNo(1:npy-1,1:npx-1),nel,1);
    nodes(:,2) = reshape(NodeNo(2:npy,1:npx-1),nel,1);
    nodes(:,3) = reshape(NodeNo(2:npy,2:npx),nel,1);
    nodes(:,4) = reshape(NodeNo(1:npy-1,2:npx),nel,1);
end
%
% Plotting the Finite Element Mesh
% Initialization of the required matrices
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
% Extract X,Y coordinates for the (iel)-th element
  for iel = 1:nel
      X(:,iel) = coordinates(nodes(iel,:),1) ;
      Y(:,iel) = coordinates(nodes(iel,:),2) ;
  end
% Figure
fh = figure ;
set(fh,'name','Preprocessing for FEA','numbertitle','off','color','w') ;
patch(X,Y,'w')
title('Finite Element Mesh of Plate') ;
axis([0. L*1.01 0. B*1.01])
axis off ;
if L==B
    axis equal ;
end