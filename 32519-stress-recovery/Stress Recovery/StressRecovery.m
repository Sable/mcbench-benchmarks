function [vonmises,allstressGP,allstressEXP,allstressPR,stressG] = .....
                StressRecovery(D,displacement) 
%--------------------------------------------------------------------------
%   Purpose:
%           To determine the stress values at the Gauss points
%   Synopsis:
%           allstressGP = StressRecovery(D,displacement)
%
%   Variable Description:
%           allstressGP - stress values at the Gauss Points
%           D - Constitutive elastic material matrix
%           displacement - dof's obtained from plane stress analysis
%           
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Input data
%--------------------------------------------------------------------------
load nodes.dat ;
load coordinates.dat ;

nel = length(nodes) ;                  % number of elements
nnel=4;                                % number of nodes per element
ndof=2;                                % number of dofs per node (UX,UY)
nnode = length(coordinates) ;          % total number of nodes in system
sdof=nnode*ndof;                       % total system dofs  
edof=nnel*ndof;                        % degrees of freedom per element
          
nglx = 2; ngly = 2;         % 2x2 Gauss-Legendre quadrature 
nglxy=nglx*ngly;            % number of sampling points per element

[Gausspoint,Gaussweight]=GaussQuadrature(nglx);     % sampling points & weights

%--------------------------------------------------------------------------
% Initialization of stress matrices
%--------------------------------------------------------------------------
allstressGP = zeros(nnel*nel,3) ;   % Stress at the Gauss points
vonmises = zeros(nnel*nel,1) ;      % Von Mises stress values
allstressEXP = zeros(nnel*nel,3) ;  % Nodal stresses obtained using Extrapolation
allstressPR = zeros(nnel*nel,3) ;   % Nodal stresses obtained using Patch Recovery
stressG = zeros(nel,3) ;            % Stress at the middle point of the element


%--------------------------------------------------------------------------
% Element stress Computation
%--------------------------------------------------------------------------

for ielp = 1:nel                    % Loop for total number of elements
for i = 1:nnel
    nd(i) = nodes(ielp,i);
    xx(i) = coordinates(nd(i),1) ;
    yy(i) = coordinates(nd(i),2) ;
end
%
% Numerical Integration
%
intp = 0 ;
for intx=1:nglx
xi = Gausspoint(intx,1);                  % sampling point in x-axis
for inty=1:ngly
    eta = Gausspoint(inty,1);                  % sampling point in y-axis
    
    intp = intp + 1 ;
    [shape,dhdr,dhds] = shapefunctions(xi,eta);     % compute shape functions and
                                    % derivatives at sampling point

    jacobian = Jacobian(nnel,dhdr,dhds,xx,yy);  % compute Jacobian

    invjacob=inv(jacobian);                 % inverse of Jacobian matrix

    [dhdx,dhdy]=shapefunctionderivatives(nnel,dhdr,dhds,invjacob); 
                        % derivatives w.r.t. physical coordinate

    B=fekineps(nnel,dhdx,dhdy);          % kinematic matrix for stiffness

    index=elementdof(nd,nnel,ndof);% extract system dofs associated with element
%
% Extract element displacement vector
%
%for i = 1:edof
    eldepl = displacement(index);
%end
%
estrain = B*eldepl ;              % Compute Strains
estress = D*estrain ;             % Compute Stresses
%
for i = 1:3
    stressGP(intp,i) = estress(i) ;       % Store for each sampiling point
end
location = [ielp,intx,inty];            % Print location for stress
stressGP(intp,:) ;                        % Print stress values
% 
end
end                                     % End of integration loop
% Calculating the Von Mises stress
vmis = VonmisesStresses(stressGP) ;
% Extrapolating stress at Gaussian points to get nodal stress values
stress_Nexp = Extrapolation(stressGP);
% Element Nodal stresses using Patch Recovery
[stress_Npr,gravity] = PatchRecovery(xx,yy,stressGP) ;
stressG(ielp,:) = gravity ;
% Storing the stress values in element node number wise 
position = 4*(ielp-1)+(1:4);
vonmises(position,1) = vmis ;
allstressGP(position,:)=stressGP;
allstressEXP(position,:) = stress_Nexp ;
allstressPR(position,:) = stress_Npr ;
end                                     % End loop for total number of elements
