function xdot = Equation(t,x)
% Set the input values in order to pass onto ode45
%
n = length(x) ;
thita = x(1) ;          % Angular Position of the bead
dthita = x(2) ;         % Angular Velocity of the bead
g = x(3) ;              % Acceleration due to gravity
M = x(4) ;              % Mass of the bead
R = x(5) ;              % Radius of the hoop
V = x(6) ;              % Frictional coefficient of the bead on the hoop
w0 = x(7) ;             % Frequency of rotation of the bead
%
xdot=zeros(n,1);
xdot(1) = dthita;
xdot(2) = -sin(thita)*(g/R-w0^2*cos(thita))-V/M*dthita ;

