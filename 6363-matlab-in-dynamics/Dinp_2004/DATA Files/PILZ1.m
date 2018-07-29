% Data file PILZ1
% Forced damped vibrations of a mechanical
% system with one degree of freedom, contained
% a reverse pendulum.
  Ek   = '3.6666*qt^2'; % Kinetic energy
  N    = '(10*sin(p*t)-c*q-k*qt+19.62*sin(10*q))*qt'; % power
  Tend = 10;    % upper bound of integration
  q0   = '0.1'; % initial coordinate
  qt0  = '0';   % initial velocity
  eps  = 1e-10; % desirable accuracy
  np   = 3;     % number of parameters
  P{1} = 'c';   % spring stiffness
  P{2} = 'k';   % coefficient of damping
  P{3} = 'p';   % disturbance frequency