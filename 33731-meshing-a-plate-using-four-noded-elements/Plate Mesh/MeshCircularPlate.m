function [coordinates,nodes] = MeshCircularPlate(Radius,theta,NR,NT) 
% To Mesh a Circular Plate with 4 and 3 noded Elements 
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
%         To Mesh a circular plate to use in FEM Analysis
% Variable Description:
% Input :
%           Radius - Radius of the Plate
%           theta - Angle of the sector to which Plate needed
%           NR - Number of Elements along Radius (Number of Rings)
%           NT - Number of Angular sectors 
% Output :
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [node X Y] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [node1 node2......]    
%
% NOTE : If the node number repeats take it as Triangular Element
%--------------------------------------------------------------------------
nel = NR*(NT-1) ;        % Total Number of Elements in the Mesh
nnel = 4 ;               % Number of nodes per Element
% Number of points on the Radius and Angluar discretization
npR = NR+1 ;
npT = NT ;
% Discretizing the Length and Breadth of the plate
nR = linspace(0,Radius,npR) ;
nT = linspace(0,theta,npT)*pi/180 ;
%nT = pi/180*(0:NT:theta) ;
[R T] = meshgrid(nR,nT) ;
% Convert grid to cartesian coordintes
 XX = R.*cos(T); 
 YY = R.*sin(T);
%  ZZ = zeros(size(XX)) ;
%  mesh(XX,YY,ZZ) ;
% To get the Nodal Connectivity Matrix
coordinates = [XX(:) YY(:)] ;
if nR(1)==0
    nnode = npR*npT-(NT-1) ;      % Total Number of Nodes in the Mesh
    NodeNo = [ones(1,NT-1),1:nnode] ;
    coordinates = coordinates(NT:end,:) ;
else
    nnode = npR*npT ;      % Total Number of Nodes in the Mesh
    NodeNo = 1:nnode ;
end
nodes = zeros(nel,nnel) ;
% If elements along the X-axes and Y-axes are equal
if npR==npT
    NodeNo = reshape(NodeNo,npT,npR);
    nodes(:,1) = reshape(NodeNo(1:npR-1,1:npT-1),nel,1);
    nodes(:,2) = reshape(NodeNo(2:npR,1:npT-1),nel,1);
    nodes(:,3) = reshape(NodeNo(2:npR,2:npT),nel,1);
    nodes(:,4) = reshape(NodeNo(1:npR-1,2:npT),nel,1);
% If the elements along the axes are different
else%if npR>npT
    NodeNo = reshape(NodeNo,npT,npR);
    nodes(:,1) = reshape(NodeNo(1:npT-1,1:npR-1),nel,1);
    nodes(:,2) = reshape(NodeNo(2:npT,1:npR-1),nel,1);
    nodes(:,3) = reshape(NodeNo(2:npT,2:npR),nel,1);
    nodes(:,4) = reshape(NodeNo(1:npT-1,2:npR),nel,1);
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
title('Finite Element Mesh of Circular Plate') ;
axis off ;
axis equal ;