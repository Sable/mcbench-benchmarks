% The ODE of the autocatalytic reaction.
% Copyright Springer 2013. Stephen Lynch.
function xdot=Chem(~,x)
global beta;
xdot(1)=(1-x(1))-beta*x(1)*(1.1-x(1))^2;
xdot=xdot(1);