% Data File ROTD
% Rotational motion of a body
  Jz   = 'Jz';   % moment of inertia of the body
  Mz   = '-k*w - c*f'; % torque
  f0   = 'f0';   % initial angle
  w0   = 'w0';   % initial angle velocity
  Tend = 20;     % upper bound of integration
  eps  = 1e-10;  % desirable accuracy
  np   = 3;      % number of parameters
  P{1} = 'Jz';   % moment of inertia
  P{2} = 'k';    % coefficient of resistance
  P{3} = 'c';    % spring stiffness