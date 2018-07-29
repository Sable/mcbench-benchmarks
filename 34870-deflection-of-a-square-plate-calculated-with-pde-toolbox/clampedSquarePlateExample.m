
%% Clamped, Square Isotropic Plate With a Uniform Pressure Load
% This example shows how to calculate the deflection of a structural
% plate acted on by a pressure loading
% using the Partial Differential Equation Toolbox(TM).
%

% Copyright 2012 The MathWorks, Inc.

%% PDE and Boundary Conditions For A Thin Plate
% The partial differential equation for a thin, isotropic plate with a
% pressure loading is
%
% $$\nabla^2(D\nabla^2 w) = -p$$
%
% where $D$ is the bending stiffness of the plate given by
%
% $$ D = \frac{Eh^3}{12(1 - \nu^2)} $$
%
% and $E$ is the modulus of elasticity, $\nu$ is Poisson's ratio,
% and $h$ is the plate thickness. The transverse deflection of the plate
% is $w$ and $p$ is the pressure load.
%
% The boundary conditions for the clamped boundaries are $w=0$ and
% $w' = 0$ where $w'$ is the derivative of $w$ in a direction
% normal to the boundary.
%
% The Partial Differential Equation Toolbox(TM) cannot directly
% solve the fourth order plate equation shown above but this can be
% converted to the following two second order partial differential
% equations.
%
% $$ \nabla^2 w = v $$
%
% $$ D \nabla^2 v = -p $$
%
% where $v$ is a new dependent variable. However, it is not obvious how to
% specify boundary conditions for this second order system. We cannot
% directly specify boundary conditions for both $w$ and $w'$.
% Instead, we directly prescribe $w'$ to be zero and use the following
% technique to define $v'$ in such a way to insure that $w$ also equals zero on
% the boundary. Stiff "springs"
% that apply a transverse shear force to the plate edge are distributed
% along the boundary. The shear force along the boundary due to these
% springs can be written $n \cdot D \nabla v = -k w$ where $n$ is the
% normal to the boundary and $k$ is the stiffness of the springs.
% The value of $k$ must be large enough that $w$ is approximately zero
% at all points on the boundary but not so large that numerical errors
% result because the stiffness matrix is ill-conditioned.
% This expression is a generalized Neumann boundary condition supported
% by Partial Differential Equation Toolbox(TM)
%
% In the Partial Differential Equation Toolbox(TM) definition for an
% elliptic system, the $w$ and $v$ dependent variables are u(1) and u(2).
% The two second order partial differential equations can be rewritten as
%
% $$ -\nabla^2 u_1 + u_2 = 0 $$
%
% $$ -D \nabla^2 u_2 = p $$
%
% which is the form supported by the toolbox. The input corresponding to this
% formulation is shown in the sections below.
%

%% Problem Parameters
E = 1.0e6; % modulus of elasticity
nu = .3; % Poisson's ratio
thick = .1; % plate thickness
len = 10.0; % side length for the square plate
hmax = len/20; % mesh size parameter
D = E*thick^3/(12*(1 - nu^2));
pres = 2; % external pressure

%% Geometry and Mesh
%
% For a single square, the geometry and mesh are easily defined
% as shown below.
gdmTrans = [3 4 0 len len 0 0 0 len len];
sf = 'S1';
nsmTrans = 'S1';
g = decsg(gdmTrans', sf, nsmTrans');
[p, e, t] = initmesh(g, 'Hmax', hmax);


%% Boundary Conditions
%
b = @boundaryFileClampedPlate;

type boundaryFileClampedPlate


%% Coefficient Definition
%
% The documentation for |assempde| shows the required formats
% for the a and c matrices in the section titled
% "PDE Coefficients for System Case". The most convenient form for c
% in this example is $n_c = 3N$ from the table where $N$ is the number
% of differential equations. In this example $N=2$.
% The $c$ tensor, in the form of an $N \times N$ matrix of $2 \times 2$ submatrices
% is shown below.
%
% $$
% \left[
% \begin{array}{cc|cc}
% c(1) & c(2) & \cdot & \cdot  \\
% \cdot & c(3) & \cdot & \cdot  \\ \hline
% \cdot & \cdot & c(4) & c(5)  \\
% \cdot & \cdot & \cdot & c(6)
% \end{array}  \right]
% $$
%
% The six-row by one-column c matrix is defined below.
% The entries in the full $2 \times 2$ a matrix and the $2 \times 1$ f vector
% follow directly from the definition of the
% two-equation system shown above.
%
c = [1; 0; 1; D; 0; D];
a = [0; 0; 1; 0];
f = [0; pres];

%% Finite Element and Analytical Solutions
%
% The solution is calculated using the |assempde| function and the
% transverse deflection is plotted using the |pdeplot| function. For
% comparison, the transverse deflection at the plate center is also
% calculated using an analytical solution to this problem.
%

u = assempde(b,p,e,t,c,a,f);
numNodes = size(p,2);
pdeplot(p, e, t, 'xydata', u(1:numNodes), 'contour', 'on');
title 'Transverse Deflection'

numNodes = size(p,2);
fprintf('Transverse deflection at plate center(PDE Toolbox)=%12.4e\n', min(u(1:numNodes,1)));
% compute analytical solution
wMax = -.0138*pres*len^4/(E*thick^3);
fprintf('Transverse deflection at plate center(analytical)=%12.4e\n', wMax);

displayEndOfDemoMessage(mfilename)


