% Data File MPEND
% Mathematical Pendulum
  L    = '1/2*m*qt^2 + 9.81*l*cos(q)'; % Lagrangian
  QN   = '-k*qt'; % generalized non potential force
  q0   = '0.5';   % initial coordinate
  qt0  = '10';    % initial velocity
  Tend = 20;      % upper bound of integration
  eps  = 1e-10;   % desirable accuracy
  np   = 3;       % number of parameters
  P{1} = 'm';     % mass of the particle
  P{2} = 'l';     % lenght of the pendulum
  P{3} = 'k';     % coefficient of resistance