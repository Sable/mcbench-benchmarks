function PlotMesh(coordinates,nodes)
%--------------------------------------------------------------------------
% Purpose:
%         To plot the Finite Element Method Mesh
% Synopsis :
%           PlotMesh(coordinates,nodes)
% Variable Description:
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [node X Y Z] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [elementNo node1 node2......]    
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

if dimension == 3   % For 3D plots
    
for iel=1:nel   
     for i=1:nnel
     nd(i)=nodes(iel,i+1);         % extract connected node for (iel)-th element
     X(i,iel)=coordinates(nd(i),2);    % extract x value of the node
     Y(i,iel)=coordinates(nd(i),3);    % extract y value of the node
     Z(i,iel)=coordinates(nd(i),4) ;   % extract z value of the node
     end  
end
    
% Plotting the FEM mesh, display Node numbers and Element numbers
     figure
     plot3(X,Y,Z,'k')
     fill3(X,Y,Z,'w')
     rotate3d ;
     title('Finite Element Mesh') ;
     axis off ;
     k = nodes(:,2:end);
     nd = k' ;
    for i = 1:nel
     text(X(:,i),Y(:,i),Z(:,i),int2str(nd(:,i)),....
              'fontsize',8,'color','k');
   
      text(sum(X(:,i))/4,sum(Y(:,i))/4,sum(Z(:,i))/4,int2str(i),.....
                'fontsize',10,'color','r') ;
    end    
    
elseif dimension == 2           % For 2D plots

for iel=1:nel   
     for i=1:nnel
     nd(i)=nodes(iel,i+1);         % extract connected node for (iel)-th element
     X(i,iel)=coordinates(nd(i),2);    % extract x value of the node
     Y(i,iel)=coordinates(nd(i),3);    % extract y value of the node
     end
end
    
% Plotting the FEM mesh, diaplay Node numbers and Element numbers
     figure
     plot(X,Y,'k')
     fill(X,Y,'w')
     
     title('Finite Element Mesh') ;
     axis off ;
     k = nodes(:,2:end);
     nd = k' ;
    for i = 1:nel
     text(X(:,i),Y(:,i),int2str(nd(:,i)),'fontsize',8,'color','k');
     text(sum(X(:,i))/4,sum(Y(:,i))/4,int2str(i),'fontsize',10,'color','r') ;
    end        
end