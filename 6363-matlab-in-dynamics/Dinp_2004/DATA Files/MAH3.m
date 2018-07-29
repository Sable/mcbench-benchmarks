% Data File MAH3
% Triple Pendulum
  s = 3; % degree of freedom
%  L a g r a n g i a n   of the system
  L = [' l1^2/6*(m1 + 3*m2 + 3*m3)*qt1^2 + '        , ...
       ' l2^2/6*(m2 + 3*m3)*qt2^2 + '               , ...
       ' l3^2/6*m3*qt3^2 + '                        , ...
       ' 1/2*(m2+2*m3)*l1*l2*cos(q1-q2)*qt1*qt2 + ' , ...
       ' 1/2*m3*l1*l3*cos(q1-q3)*qt1*qt3 + '        , ...
       ' 1/2*m3*l2*l3*cos(q2-q3)*qt2*qt3 + '        , ...
       ' 9.81*l1*(m1/2 + m2 + m3)*cos(q1) + '          , ...
       ' 9.81*l2*(m2/2 + m3)*cos(q2) + '               , ...
       ' 9.81*l3*m3/2*cos(q3) '              ];
  QN{1} = '-k1*qt1'; % Generalized
  QN{2} = '-k2*qt2'; % non potential
  QN{3} = '-k3*qt3'; % forces
  qj0   = [0, 0, 0]; % Initial coordinates
  qtj0  = [5, 0, 0]; % Initial velocities
  Tend  = 20;        % Upper bound of integration
  eps   = 1e-10;     % Desirable accuracy
  np    = 9;         % Number of parameters
  P{1}  = 'm1';      % Masses of 
  P{2}  = 'm2';      % the rods 1, 2, 3
  P{3}  = 'm3';
  P{4}  = 'l1';      % Lenghts of
  P{5}  = 'l2';      % the rods 1, 2, 3
  P{6}  = 'l3';
  P{7}  = 'k1';      % Coefficients of 
  P{8}  = 'k2';      % damping
  P{9}  = 'k3';