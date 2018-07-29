% Data File DTX2
% Free damped vibrations
% of a particle
  m    = 'm';    % mass of the particle
  Fx   = '-k*v - c*x'; % projections of forces on x
  x0   = '0.1';  % initial coordinate
  v0   = '10';   % initial velocity
  Tend = 20;     % upper bound of integration
  eps  = 1e-10;  % desirable accuracy
  np   = 3;      % number of parameters
  P{1} = 'm';    % mass of the particle
  P{2} = 'k';    % coefficient of resistance
  P{3} = 'c';    % spring stiffness