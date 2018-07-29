% Data file PILZ3
% Forced damped vibrations of a mechanical
% system with one degree of freedom, contained
% a reverse pendulum. 
  s     = 1; % degree of freedom
  L     = '2.5*qt1^2 - 1/2*c*q1^2 - 3.9*cos(10*q1)'; % Lagrangian
  QN{1} = '-k*qt1 + 10*sin(p*t)'; % generalized non potential force
  Tend  = 20;    % upper bound of integration
  qj0   = 0.05;  % initial coordinate
  qtj0  = 0;     % initial velocity
  eps   = 1e-10; % desirable accuracy
  np    = 3;     % number of parameters
  P{1}  = 'c';   % spring stiffness
  P{2}  = 'k';   % coefficient of damping
  P{3}  = 'p';   % disturbance frequency