% Data File EKIN1
% Oscillations of 
% a mathematical pendulum
  Ek   = '1/2*m*qt^2'; % Kinetic energy
  N    = '-(k*qt + 9.81*sin(q))*qt'; % power
  q0   = '0.1';  % initial coordinate
  qt0  = '5';    % initial velocity
  Tend = 20;     % upper bound of integration
  eps  = 1e-10;  % desirable accuracy
  np   = 2;      % number of parameters
  P{1} = 'm';    % mass of the pendulum
  P{2} = 'k';    % coefficient of resistance