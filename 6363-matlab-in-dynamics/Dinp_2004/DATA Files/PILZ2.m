% Data file PILZ2
% Forced damped vibrations of a mechanical
% system with one degree of freedom, contained
% a reverse pendulum. 
  L    = '2.5*qt^2 - 1/2*c*q^2 - 3.9*cos(10*q)'; % Lagrangian
  QN   = '-k*qt + 10*sin(p*t)'; % generalized non potential force
  Tend = 10;     % upper bound of integration
  q0   = '0.05'; % initial coordinate
  qt0  = '0';    % initial velocity
  eps  = 1e-10;  % desirable accuracy
  np   = 3;      % number of parameters
  P{1} = 'c';    % spring stiffness
  P{2} = 'k';    % coefficient of dempfing
  P{3} = 'p';    % disturbance frequency