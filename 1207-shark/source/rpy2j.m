function J=rpy2J(rpy)

% J=rpy2J(rpy); computes generalised Jacobian matrix which 
% transforms ni into eta derivatives, given in input roll pitch
% and yaw angles.

sf = sin(rpy(1));
cf = cos(rpy(1));
tt = tan(rpy(2));
ct = cos(rpy(2));

J = [ rpy2R_eb(rpy)' zeros(3,3)
      zeros(3,3)     [1 sf*tt cf*tt; 0 cf -sf; 0 sf/ct cf/ct]  ];
