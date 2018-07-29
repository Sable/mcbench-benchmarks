function dydt = pend1(t,y)

% PEND1  A damped nonlinear pendulum model
%
% Date: 02.11.2006
% Author: Atakan Varol

dydt = [y(2); (sin(y(1)) - 0.3*y(2))];

end