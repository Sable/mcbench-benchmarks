% Data File LAN
% Free linear vibrations of a system
% with one degree of freedom
s     = 1; % degree of freedom
L     = '1/2*(a*qt1^2 - c*q1^2)'; % Lagrangian
QN{1} = '-b*qt1'; % generalized non potential force
qj0   = 'q0';     % initial coordinate
qtj0  = 'qt0';    % initial velocity
Tend  = 20;       % upper bound of integration
eps   = 1e-10;    % desirable accuracy
np    = 3;        % number of parameters
P{1}  = 'a';      % generalized coefficient of inertia
P{2}  = 'b';      % generalized coefficient of resistance
P{3}  = 'c';      % generalized coefficient of stiffness
