% Data File DMAHN
% Elliptical Pendulum
s = 2;               % degree of freedom
L = ['1/2*(m1+m2)*qt1^2 + 1/2*m2*l^2*qt2^2 + ',...
     'm2*l*qt1*qt2*cos(q2) - 1/2*c*q1^2 + ',...
     '9.81*m2*l*cos(q2)'];  % Lagrangian
QN{1} = '-alfa*qt1'; % Generalized
QN{2} = '-k*qt2';    % non potential forces
qj0   = [0.02, 0];   % Initial coordinates
qtj0  = [0.1, 0];    % Initial velocities
Tend  = 2;           % Upper bound of integration
eps   = 1e-10;       % Desirable accuracy
np    = 6;           % Number of parameters
P{1}  = 'm1';        % Mass of the slider
P{2}  = 'm2';        % Mass of the rod
P{3}  = 'l';         % Lenght of the rod
P{4}  = 'c';         % Spring stiffness
P{5}  = 'alfa';      % Coefficient of damping of the slider
P{6}  = 'k';         % Coefficient of damping of the rod