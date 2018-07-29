% Static Analysis of  plate
% Problem : To find the maximum bedning of plate when uniform transverse
% pressure is applied. 
% Two Boundary conditions are used, simply supported and clamped
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%--------------------------------------------------------------------------
%----------------------------------------------------------------------------
%
% Variable descriptions                                                      
%   ke = element stiffness matrix                                             
%   kb = element stiffness matrix for bending
%   ks = element stiffness matrix for shear 
%   f = element force vector
%   stiffness = system stiffness matrix                                             
%   force = system vector                                                 
%   displacement = system nodal displacement vector
%   coordinates = coordinate values of each node
%   nodes = nodal connectivity of each element
%   index = a vector containing system dofs associated with each element     
%   pointb = matrix containing sampling points for bending term
%   weightb = matrix containing weighting coefficients for bending term
%   points = matrix containing sampling points for shear term
%   weights = matrix containing weighting coefficients for shear term
%   bcdof = a vector containing dofs associated with boundary conditions     
%   bcval = a vector containing boundary condition values associated with    
%           the dofs in 'bcdof'                                              
%   B_pb = matrix for kinematic equation for bending
%   D_pb = matrix for material property for bending
%   B_ps = matrix for kinematic equation for shear
%   D_ps = matrix for material property for shear
%
%----------------------------------------------------------------------------            
clear 
clc
%
disp('Please wait Programme is under Run')
%--------------------------------------------------------------------------
%  Input data 
%--------------------------------------------------------------------------
load coordinates.dat ;
%--------------------------------------------------------------------------
% Input data for nodal connectivity for each element
%--------------------------------------------------------------------------
load nodes.dat ;

nel = length(nodes) ;                  % number of elements
nnel=4;                                % number of nodes per element
ndof=3;                                % number of dofs per node
nnode = length(coordinates) ;          % total number of nodes in system
sdof=nnode*ndof;                       % total system dofs  
edof=nnel*ndof;                        % degrees of freedom per element
%--------------------------------------------------------------------------
% Geometrical and material properties of plate
%--------------------------------------------------------------------------
a = 1 ;                           % Length of the plate (along X-axes)
b = 1 ;                           % Length of the plate (along Y-axes)
E = 10920;                        % elastic modulus
nu = 0.3;                         % Poisson's ratio
t = 0.1 ;                         % plate thickness
I = t^3/12 ;
%
PlotMesh(coordinates,nodes)
%--------------------------------------------------------------------------
% Order of Gauss Quadrature
%--------------------------------------------------------------------------
nglb=2;                     % 2x2 Gauss-Legendre quadrature for bending 
ngls=1;                     % 1x1 Gauss-Legendre quadrature for shear 

%--------------------------------------------------------------------------
% Initialization of matrices and vectors
%--------------------------------------------------------------------------
force = zeros(sdof,1) ;             % System Force Vector
stiffness=zeros(sdof,sdof);         % system stiffness matrix
index=zeros(edof,1);                % index vector
B_pb=zeros(3,edof);                 % kinematic matrix for bending
B_ps=zeros(2,edof);                 % kinematic matrix for shear

%--------------------------------------------------------------------------
% Transverse uniform pressure on plate
%--------------------------------------------------------------------------
P = -1.*10^0 ; 

%--------------------------------------------------------------------------
%  Computation of element matrices and vectors and their assembly
%--------------------------------------------------------------------------
%
%  For bending stiffness
%
[pointb,weightb]=GaussQuadrature('second');     % sampling points & weights
D_pb= I*E/(1-nu*nu)*[1  nu 0; nu  1  0; 0  0  (1-nu)/2];
                                           % bending material property
%
%  For shear stiffness
%
[points,weights] = GaussQuadrature('first');    % sampling points & weights
G = 0.5*E/(1.0+nu);                             % shear modulus
shcof = 5/6;                                    % shear correction factor
D_ps=G*shcof*t*[1 0; 0 1];                      % shear material property

for iel=1:nel                        % loop for the total number of elements

for i=1:nnel
node(i)=nodes(iel,i);               % extract connected node for (iel)-th element
xx(i)=coordinates(node(i),1);       % extract x value of the node
yy(i)=coordinates(node(i),2);       % extract y value of the node
end

ke = zeros(edof,edof);              % initialization of element stiffness matrix 
kb = zeros(edof,edof);              % initialization of bending matrix 
ks = zeros(edof,edof);              % initialization of shear matrix 
f = zeros(edof,1) ;                 % initialization of force vector                   
%--------------------------------------------------------------------------
%  Numerical integration for bending term
%--------------------------------------------------------------------------
for intx=1:nglb
xi=pointb(intx,1);                     % sampling point in x-axis
wtx=weightb(intx,1);                   % weight in x-axis
for inty=1:nglb
eta=pointb(inty,2);                    % sampling point in y-axis
wty=weightb(inty,2) ;                  % weight in y-axis

[shape,dhdr,dhds]=Shapefunctions(xi,eta);    
    % compute shape functions and derivatives at sampling point

[detjacobian,invjacobian]=Jacobian(nnel,dhdr,dhds,xx,yy);  % compute Jacobian

[dhdx,dhdy]=ShapefunctionDerivatives(nnel,dhdr,dhds,invjacobian);
                                     % derivatives w.r.t. physical coordinate
B_pb=PlateBending(nnel,dhdx,dhdy);    % bending kinematic matrix

%--------------------------------------------------------------------------
%  compute bending element matrix
%--------------------------------------------------------------------------

kb=kb+B_pb'*D_pb*B_pb*wtx*wty*detjacobian;

end
end                      % end of numerical integration loop for bending term

%--------------------------------------------------------------------------
%  numerical integration for shear term
%--------------------------------------------------------------------------

for intx=1:ngls
xi=points(intx,1);                  % sampling point in x-axis
wtx=weights(intx,1);               % weight in x-axis
for inty=1:ngls
eta=points(inty,2);                  % sampling point in y-axis
wty=weights(inty,2) ;              % weight in y-axis

[shape,dhdr,dhds]=Shapefunctions(xi,eta);   
        % compute shape functions and derivatives at sampling point

[detjacobian,invjacobian]=Jacobian(nnel,dhdr,dhds,xx,yy);  % compute Jacobian

[dhdx,dhdy]=ShapefunctionDerivatives(nnel,dhdr,dhds,invjacobian); 
            % derivatives w.r.t. physical coordinate

fe = Force(nnel,shape,P) ;             % Force vector
B_ps=PlateShear(nnel,dhdx,dhdy,shape);        % shear kinematic matrix

%--------------------------------------------------------------------------
%  compute shear element matrix
%--------------------------------------------------------------------------
                
ks=ks+B_ps'*D_ps*B_ps*wtx*wty*detjacobian;
f = f+fe*wtx*wty*detjacobian ;

end
end                      % end of numerical integration loop for shear term

%--------------------------------------------------------------------------
%  compute element matrix
%--------------------------------------------------------------------------

ke = kb+ks ;

index=elementdof(node,nnel,ndof);% extract system dofs associated with element

[stiffness,force]=assemble(stiffness,force,ke,f,index);      
                           % assemble element stiffness and force matrices 
end
%--------------------------------------------------------------------------
% Boundary conditions
%--------------------------------------------------------------------------
typeBC = 'ss-ss-ss-ss' ;        % Boundary Condition type
% typeBC = 'c-c-c-c'   ;
bcdof = BoundaryCondition(typeBC,coordinates) ;
bcval = zeros(1,length(bcdof)) ;

[stiffness,force] = constraints(stiffness,force,bcdof,bcval);

%--------------------------------------------------------------------------
% Solution
%--------------------------------------------------------------------------
displacement = stiffness\force ;
%--------------------------------------------------------------------------
% Output of displacements
%--------------------------------------------------------------------------

[w,titax,titay] = mytable(nnode,displacement,sdof) ;

%--------------------------------------------------------------------------
% Deformed Shape
%--------------------------------------------------------------------------
x = coordinates(:,1) ;
y = coordinates(:,2) ;
f3 = figure ;
set(f3,'name','Postprocessing','numbertitle','off') ;
plot3(x,y,w,'.') ;
title('plate deformation') ;

% Maximum transverse displacement
format long 
D1 = E*t^3/12/(1-nu^2) ;
minw = min(w)*D1/(P*a^4) 

%--------------------------------------------------------------------------
% Contour Plots
%--------------------------------------------------------------------------
PlotFieldonMesh(coordinates,nodes,w)
title('Profile of UZ/w on plate')
%
PlotFieldonDefoMesh(coordinates,nodes,w,w)
title('Profile of UZ on deformed Mesh') ;    