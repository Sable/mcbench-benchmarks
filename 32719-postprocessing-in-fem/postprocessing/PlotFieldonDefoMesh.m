function PlotFieldonDefoMesh(coordinates,nodes,factor,depl,component) 
%--------------------------------------------------------------------------
% Purpose:
%         To plot the profile of a component on deformed mesh
% Synopsis :
%           ProfileonDefoMesh(coordinates,nodes,component)
% Variable Description:
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [node X Y Z] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [elementNo node1 node2......]    
%           factor - Amplification factor (Change accordingly, trial)
%           depl -  Nodal displacements
%           -----> depl = [UX UY UZ]
%           component - The components whose profile to be plotted
%           -----> components = a column vector in the order of node
%                               numbers
%
% NOTE : Please note that in coordinates ,displacements first column is 
%        node number and in nodes forst column is element number .
%--------------------------------------------------------------------------

dimension = size(coordinates(:,2:end),2) ;  % Dimension of the mesh
nel = length(nodes) ;                       % number of elements
nnode = length(coordinates) ;               % total number of nodes in system
nnel = size(nodes,2)-1;                     % number of nodes per element
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
     ux = depl(:,1) ;
     uy = depl(:,2) ;
     uz = depl(:,3) ;
  
     UX(:,iel) = ux(nd') ;         % extract displacement value's of the node 
     UY(:,iel) = uy(nd') ;
     UZ(:,iel) = uz(nd') ;
     profile(:,iel) = component(nd') ;  
end

% Plotting the profile of a property on the deformed mesh  
  defoX = X+factor*UX ;
  defoY = Y+factor*UY ;
  defoZ = Z+factor*UZ ;
  figure
  plot3(defoX,defoY,defoZ,'k')
  fill3(defoX,defoY,defoZ,profile)
  title('Profile of component on deformed Mesh') ;       
  rotate3d on ;
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
     ux = depl(:,1) ;
     uy = depl(:,2) ;
  
     UX(:,iel) = ux(nd') ;
     UY(:,iel) = uy(nd') ;
     profile(:,iel) = component(nd') ;      
end
     
 % Plotting the profile of a property on the deformed mesh        
   defoX = X+factor*UX ;
   defoY = Y+factor*UY ;  
   figure
   plot(defoX,defoY,'k')
   fill(defoX,defoY,profile)
   title('Profile of UX on deformed Mesh') ;      
   axis off ;
   % Colorbar Setting
   SetColorbar
 end

           
         
 
   
     
       
       

