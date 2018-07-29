%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUMERICAL SOLUTION OF A PRANDTL-MEYER EXPANSION WAVE FLOW FIELD %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% By: Iván Padilla (ivan.padilla6@gmail.com) ; Alberto García (albertoomniaf1@gmail.com)
        
% This program is a numerical solver of the Prandtl-Meyer expansion wave
% problem. It is based on the method provided by Anderson in his book
% "Computational Fluid Dynamics", chapter 8. You may need to take a look at it
% in order to unsderstand the following code.

% Assumptions: inviscid, steady, two-dimensional flow field for a
% calloricaly perfect gas. This simulation is done using standard air at
% Mach 2

close all;
clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geometry and physical domain parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = 40; % Physical domain height [m]
Theta = 5.352*pi/180; % Expansion angle [rad]
L = 65; % Physical domain longitude [m]
E = 10; % Expansion point distance [m]


%%%%%%%%%%%%%%%%%%%%%
% Inflow conditions %
%%%%%%%%%%%%%%%%%%%%%

M_in = 2; % Inlet Mach number
P_in = 101325; % Inlet pressure (static) [Pa]
Rho_in = 1.225; % Inlet density [kg/m^3]
R_air = 287; % Air gas constant [J/kg*K]
Gamma = 1.4; % Specific heat ratio for perfect air 
T_in = P_in/(Rho_in*R_air); % Inlet temperature [K]
a_in = sqrt(Gamma*R_air*T_in); % Inlet sound speed [m/s]
v_in = 0; % Inlet y-component of velocity [m/s]
u_in = M_in*a_in; % Inlet x-component of velocity [m/s]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flow field variables initialization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Flow_field = struct('M',zeros(401,877),'u',zeros(401,877),'v',zeros(401,877),'T',zeros(401,877),'P',zeros(401,877),'Rho',zeros(401,877),'a',zeros(401,877),'M_angle',zeros(401,877));
% I have chosen this matrix size in order to preallocate them and increase
% performance. Anderson uses 41 steps in the vertical direction but I
% increased the number of points by a factor of 10 to increase precision.
% This code also works for a grid of 41x87

% Now we are able to fed in the initial data line (first vertical line)
Flow_field.M(:,1) = M_in;
Flow_field.u(:,1) = u_in;
Flow_field.v(:,1) = v_in;
Flow_field.T(:,1) = T_in;
Flow_field.P(:,1) = P_in;
Flow_field.Rho(:,1) = Rho_in;
Flow_field.a(:,1) = a_in;
Flow_field.M_angle(:,1) = asin(1/M_in); % Mach angle [rad]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flux/Divergence terms definition %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F = struct('F1',zeros(401,877),'F2',zeros(401,877),'F3',zeros(401,877),'F4',zeros(401,877));
G = struct('G1',zeros(401,877),'G2',zeros(401,877),'G3',zeros(401,877),'G4',zeros(401,877));

F.F1(:,1) = Rho_in*u_in; % From continuity: differentiated with respect to x
G.G1(:,1) = Rho_in*v_in; % From continuity: differentiated with respect to y
F.F2(:,1) = Rho_in*(u_in^2) + P_in; % From x-momentum (Euler): differentiated with respect to x
G.G2(:,1) = Rho_in*u_in*v_in; % From x-momentum (Euler): differentiated with respect to y
F.F3 = G.G2; % From y-momentum (Euler): differentiated with respect to x
G.G3(:,1) = Rho_in*(v_in^2) + P_in; % From y-momentum (Euler): differentiated with respect to y
F.F4(:,1) = (Gamma/(Gamma - 1))*P_in*u_in + Rho_in*u_in*(((u_in^2) + (v_in^2)))/2; % From energy: differentiated with respect to x
G.G4(:,1) = (Gamma/(Gamma - 1))*P_in*v_in + Rho_in*v_in*(((u_in^2) + (v_in^2)))/2; % From energy: differentiated with respect to y


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid transformation and parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A boundary fitted coordinate system is used. The transformation is given
% by the relation between the physical (x,y) and the computational
% (Xi,Eta) planes.

i = 1; % Grid horitzontal position (matrix column)
j = 1; % Grid vertical position (matrix row)
Grid = struct('x',zeros(1,877),'y',zeros(401,877),'y_t',zeros(401,1),'y_s',zeros(1,877),'h',zeros(1,877),'m1',zeros(401,877),'m2',zeros(401,877),'delta_y_t',0.0025);
% x is the horitzontal coordinate position in both the physical and the
% computational planes. So x = Xi
% y is the vertical coordinate position in the physical plane
% y_t is the vertical coordinate position in the computational (transformed) plane (Eta value)
% y_s is the transformation parameter that represents the wall expansion
% geometry
% h is the transformation parameter that represents the vertical distance
% between the wall and the upper boundary
% m1 is the metric representing the derivative of Eta to x in the
% transformation
% m2 is the metric representing the derivative of Eta to y in the
% transformation

for j = 2:401 % Here we compute the vertical component (Eta) of the grid in the computational plane
    Grid.y_t(j) = Grid.y_t(j-1) + Grid.delta_y_t; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Numerical solution using MacCormack's predictor-corrector technique %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization of variables needed for the technique

% Predicted values (all variables finishing with "_p"
F_p = struct('F1_p',zeros(401,877),'F2_p',zeros(401,877),'F3_p',zeros(401,877),'F4_p',zeros(401,877));
G_p = struct('G1_p',zeros(401,877),'G2_p',zeros(401,877),'G3_p',zeros(401,877),'G4_p',zeros(401,877));
dF_x = struct('dF1_x',zeros(401,1),'dF2_x',zeros(401,1),'dF3_x',zeros(401,1),'dF4_x',zeros(401,1));
dF_p_x = struct('dF1_p_x',zeros(401,1),'dF2_p_x',zeros(401,1),'dF3_p_x',zeros(401,1),'dF4_p_x',zeros(401,1));
P_p = zeros(401,1); % Needed for artificial viscosity in the corrector step

while (Grid.x(i) <= L)
    % First of all compute the grid transformation for the current (i)
    % position:
    Grid = compute_transformation(i,Grid,H,E,Theta);
    
    % Compute the downstream step size (delta_x):
    delta_x = compute_step_size(Theta,i,Grid.y,Flow_field.M_angle);
    
    % Apply predictor step and obtain the derivatives of F with respect to
    % x and the predicted values of F in i+1:
    [dF_x,F_p] = predictor_step(i,F,G,Grid,F_p,dF_x,Flow_field.P,delta_x);
    
    % Obtain the predicted G and P values in i+1:
    [P_p,G_p] = compute_predicted_G(F_p,G_p,P_p,Gamma,i);
    
    % Now we are able to apply corrector step in oder to obtain the desired values
    % of F at the next downstream point i+1:
    F = corrector_step(i,F,F_p,G_p,P_p,dF_x,dF_p_x,Grid,delta_x);
    
    % The last step is to decode the flow field variables at i+1 and
    % compute the new G values. This function also includes the application
    % of Abbett's boundary condition for j = 1:
    [Flow_field,G] = decode_flow_field(i,F,G,Flow_field,Grid,Gamma,R_air,Theta,E);
    
    % Finally advance to the next downstream position
    Grid.x(i+1) = Grid.x(i) + delta_x;
    i = i + 1;
    clc;
    fprintf('Step %d of 877\n',i);
end

Grid = compute_transformation(i,Grid,H,E,Theta); % To compute the grid transformation at the last point (i = 877)

disp('Finished!');

mesh(Grid.y,Flow_field.M); % Mesh function plots in 3D, but this has no sense in this simulation. Move the axes to view it in 2d.
xlabel('Downstream position (i)');
zlabel('y (m)');
title('Mach Number');
colorbar;