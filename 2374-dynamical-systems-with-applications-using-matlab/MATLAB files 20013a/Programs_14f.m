function xdot=Programs_14f(t,x)
% The Duffing System.
% Run Programs_14g
global Gamma;
xdot(1)=x(2);
xdot(2)=x(1)-0.1*x(2)-(x(1))^3+Gamma*cos(1.25*t);
xdot=[xdot(1);xdot(2)];