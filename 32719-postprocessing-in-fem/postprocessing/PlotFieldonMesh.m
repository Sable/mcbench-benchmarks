function PlotFieldonMesh(coordinates,nodes,component)
%--------------------------------------------------------------------------
% Purpose:
%         To plot the profile of a component on mesh
% Synopsis :
%           ProfileonMesh(coordinates,nodes,component)
% Variable Description:
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [node X Y Z] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [elementNo node1 node2......]      
%           component - The components whose profile to be plotted
%           -----> components = a column vector in the order of node
%                               numbers
%
% NOTE : Please note that in coordinates ,displacements first column is 
%        node number and in nodes forst column is element number .
%--------------------------------------------------------------------------

dimension = size(coordinates(:,2:end),2) ;  % Dimension of the mesh
nel = length(nodes) ;                  % number of elements
nnode = length(coordinates) ;          % total number of nodes in system
nnel = size(nodes,2)-1;                % number of nodes per element
% 
% Initialization of the required matrices
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
Z = zeros(nnel,nel) ;
profile = zeros(nnel,nel) ;
%
if dimension == 3   % For 3D plots
    
for iel=1:nel   
     for i=1:nnel
     nd(i)=nodes(iel,i+1);         % extract connected node for (iel)-th element
     X(i,iel)=coordinates(nd(i),2);    % extract x value of the node
     Y(i,iel)=coordinates(nd(i),3);    % extract y value of the node
     Z(i,iel)=coordinates(nd(i),4) ;   % extract z value of the node
     end  
     profile(:,iel) = component(nd') ; % extract component value of the node 
end
    
% Plotting the FEM mesh and profile of the given component
     figure
     plot3(X,Y,Z,'k')
     fill3(X,Y,Z,profile)
     rotate3d on ;
     title('Profile of component on Mesh') ;         
     axis off ; 
     % Colorbar Setting
     SetColorbar
      
elseif dimension == 2           % For 2D plots

for iel=1:nel   
     for i=1:nnel
     nd(i)=nodes(iel,i+1);         % extract connected node for (iel)-th element
     X(i,iel)=coordinates(nd(i),2);    % extract x value of the node
     Y(i,iel)=coordinates(nd(i),3);    % extract y value of the node
     end   
     profile(:,iel) = component(nd') ;         % extract component value of the node 
end
    
% Plotting the FEM mesh and profile of the given component
     figure
     plot(X,Y,'k')
     fill(X,Y,profile)
     title('Profile of component on Mesh') ;         
     axis off ;
     % Colorbar Setting
     SetColorbar
 end

              
         
 
   
     
       
       

