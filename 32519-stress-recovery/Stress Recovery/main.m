% Stress recovery in plane stress analysis of plates 
% Plane stress analysis of a thin plate under tension at its extremes
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save any
% if any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% Variable descriptions                                                                                                 
%   k = element matrix for stiffness
%   f = element vector
%   stiffness = system matrix                                             
%   force = system vector                                                 
%   displacement = system nodal displacement vector
%   coordinates = coordinate values of each node
%   nodes = nodal connectivity of each element
%   index = a vector containing system dofs associated with each element     
%   gausspoint = matrix containing sampling points for bending term
%   gaussweight = matrix containing weighting coefficients for bending term
%   bcdof = a vector containing dofs associated with boundary conditions     
%   bcval = a vector containing boundary condition values associated with    
%           the dofs in 'bcdof'                                              
%   B = matrix for kinematic equation for plane stress
%   D = matrix for material property for plane stress
%   stressGP = stress at the Gauss points
%----------------------------------------------------------------------------            

%--------------------------------------------------------------------------
%  input data 
%--------------------------------------------------------------------------
clear 
clc
disp('Please wait Programme is under Run')
%--------------------------------------------------------------------------
% Input data for nodal coordinate values
%--------------------------------------------------------------------------
load coordinates.dat ;
%--------------------------------------------------------------------------
% Input data for nodal connectivity for each element
%--------------------------------------------------------------------------
load nodes.dat ;

nel = length(nodes) ;                  % number of elements
nnel=4;                                % number of nodes per element
ndof=2;                                % number of dofs per node (UX,UY)
nnode = length(coordinates) ;          % total number of nodes in system
sdof=nnode*ndof;                       % total system dofs  
edof=nnel*ndof;                        % degrees of freedom per element

% Units are in SI system
a = 1 ;                           % Length of the plate (along X-axes)
b = 1 ;                           % Length of the plate (along Y-axes)
elementsalongX = 10 ;             % Number of elements along X-axes
elementsalongY = 10 ;             

E = 2.1*10^11;                      % Youngs modulus
nu = 0.3;                           % Poisson's ratio
t = 0.0254;                         % plate thickness
rho = 7840. ;                       % Density of the plate

nglx = 2; ngly = 2;         % 2x2 Gauss-Legendre quadrature 
nglxy=nglx*ngly;            % number of sampling points per element

%--------------------------------------------------------------------------
% Input data for boundary conditions
%--------------------------------------------------------------------------
% (0,0) and (1,0) are fixed

  bcdof = [ 1 2 241 242] ; 
  bcval = zeros(1,length(bcdof)) ;
%--------------------------------------------------------------------------
%  initialization of matrices and vectors
%--------------------------------------------------------------------------

force = zeros(sdof,1);                % system force vector
stiffness = zeros(sdof,sdof);         % system stiffness matrix
displacement = zeros(sdof,1);         % system displacement vector
eldepl = zeros(edof,1) ;              % element displacement vector
index = zeros(edof,1);                % index vector
B = zeros(3,edof);              % kinematic matrix for bending
D = zeros(3,3);                 % constitutive matrix for bending

%--------------------------------------------------------------------------
% force vector
%--------------------------------------------------------------------------
P = 1e5 ;       % Load
rightedge = find(coordinates(:,1)==a);
rightdof = 2*rightedge-ones(length(rightedge),1);
force(rightdof) = -P*b/(elementsalongY+1) ;
leftedge = find(coordinates(:,1)==0);
leftdof = 2*leftedge-ones(length(leftedge),1) ;
force(leftdof) = P*b/(elementsalongY+1) ;

%--------------------------------------------------------------------------
%  computation of element matrices and vectors and their assembly
%--------------------------------------------------------------------------
[Gausspoint,Gaussweight]=GaussQuadrature(nglx);     % sampling points & weights
D = E/(1-nu^2)*[1 nu 0 ; nu 1 0; 0 0 (1-nu)/2] ;    % Constituent Matrix for Plane stress

for iel=1:nel           % loop for the total number of elements

for i=1:nnel
nd(i)=nodes(iel,i);         % extract connected node for (iel)-th element
xx(i)=coordinates(nd(i),1);    % extract x value of the node
yy(i)=coordinates(nd(i),2);    % extract y value of the node
end

k = zeros(edof,edof);        % initialization of stiffness matrix

%--------------------------------------------------------------------------
%  numerical integration for stiffness matrix
%--------------------------------------------------------------------------

for intx=1:nglx
xi = Gausspoint(intx,1);                  % sampling point in x-axis
wtx = Gaussweight(intx,1);               % weight in x-axis
for inty=1:ngly
eta = Gausspoint(inty,1);                  % sampling point in y-axis
wty = Gaussweight(inty,1) ;              % weight in y-axis

[shape,dhdr,dhds] = shapefunctions(xi,eta);     % compute shape functions and
                                    % derivatives at sampling point
jacobian = Jacobian(nnel,dhdr,dhds,xx,yy);  % compute Jacobian

detjacob=det(jacobian);                 % determinant of Jacobian
invjacob=inv(jacobian);                 % inverse of Jacobian matrix

[dhdx,dhdy]=shapefunctionderivatives(nnel,dhdr,dhds,invjacob); % derivatives w.r.t.
                                               % physical coordinate

B=fekineps(nnel,dhdx,dhdy);          % kinematic matrix for stiffness

%--------------------------------------------------------------------------
%  compute element stiffness matrix
%--------------------------------------------------------------------------

k = k+B'*D*B*wtx*wty*detjacob;
 
end
end                      % end of numerical integration loop for bending term


index = elementdof(nd,nnel,ndof); % extract system dofs associated with element

stiffness = assemble(stiffness,k,index);    % assemble element stiffness matrices 

end

%--------------------------------------------------------------------------
%   apply boundary conditions
%--------------------------------------------------------------------------

[stiffness,force] = constraints(stiffness,force,bcdof,bcval);

%--------------------------------------------------------------------------
% Solve the matrix equation 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Solve the matrix equation 
%--------------------------------------------------------------------------
displacement = stiffness\force ;

%--------------------------------------------------------------------------
% Stress Recovery 
%--------------------------------------------------------------------------
% Calculaing the stress at the Gauss points
[vonmises,stressGP,stressEXP,stressPR,stressG] = StressRecovery(D,displacement);

% Calculating the Element nodal stresses

% Nodal Averaging 
type = 'average' ;
% type = 'sum' ;
stressEXPavg = NodalAveraging(stressEXP,type);
stressPRavg = NodalAveraging(stressPR,type) ;

%#### OUTPUTS ####


display('=======SYSTEM MAIN PROPERTIES (isotropic material)=======');
fprintf('       Elasticity  constant  % .2e N/m**2 \n',E);
fprintf('       Poission ratio        % .5f         \n',nu);
fprintf('       thickness of plate    % .5f m       \n',t);
fprintf('       length of plate       % .5f m       \n',a);
fprintf('       breadth of plate      % .5f m       \n',b);
fprintf(' \n ')

display('======SYSTEM GEOMETRICALY PROPERTIES======');
fprintf('        System total element no   % .f \n  ',nel);
fprintf('      System total nodes        % .f \n  ',nnode);
fprintf('      System degree of freedom  % .f \n  ',sdof);

fprintf(' \n ')
% Output of displacements
mytable(displacement,1);

% Output of Stresses at Gauss points
display('======STRESS VALUES AT THE GAUSS POINTS=======')
mytable(stressGP,3);

% Output Von Mises stress
mytable(vonmises,2) ;

% Output of element nodal stresses
display('====ELEMENT NODAL STRESS USING EXTRAPOLATION====')
mytable(stressEXP,3) ;
display('====ELEMENT NODAL STRESS USING PATCH RECOVERY====')
mytable(stressPR,3) ;

% Output of Nodal averaged stresses
display('====NODAL AVERAGED STRESSES OF EXTRAPOLATION====')
mytable(stressEXPavg,4);
display('====NODAL AVERAGED STRESSES OF PATCH RECOVERY====')
mytable(stressPRavg,4);