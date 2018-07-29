function PlotFieldonDefoMesh(coordinates,nodes,depl,component) 
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
%         To plot the profile of a component on deformed mesh
% Synopsis :
%           ProfileonDefoMesh(coordinates,nodes,component)
% Variable Description:
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [X Y] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [node1 node2......]    
%           depl -  Nodal displacements
%           -----> depl = [UZ]
%           component - The components whose profile to be plotted
%           -----> components = a column vector in the order of node
%                               numbers
%--------------------------------------------------------------------------

nel = length(nodes) ;                       % number of elements
nnode = length(coordinates) ;               % total number of nodes in system
nnel = size(nodes,2);                     % number of nodes per element
% 
% Initialization of the required matrices
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
Z = zeros(nnel,nel) ;
profile = zeros(nnel,nel) ;
%
for iel=1:nel   
     for i=1:nnel
     nd(i)=nodes(iel,i);         % extract connected node for (iel)-th element
     X(i,iel)=coordinates(nd(i),1);    % extract x value of the node
     Y(i,iel)=coordinates(nd(i),2);    % extract y value of the node
     end   
     Z(:,iel) = depl(nd') ;
     profile(:,iel) = component(nd') ;
end
     
 % Plotting the profile of a property on the deformed mesh
   fh = figure ;
   set(fh,'name','Postprocessing','numbertitle','off') ;
   fill3(X,Y,Z,profile) 
   axis off ;
   % Colorbar Setting
   SetColorbar
 end

           
         
 
   
     
       
       

