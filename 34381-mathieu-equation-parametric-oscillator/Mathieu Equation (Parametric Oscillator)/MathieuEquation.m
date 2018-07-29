function xdot = MathieuEquation(t,x)
% Mathieu Equation is y''(z)+eta.y'(z)+(a-2qcos(2z))sin(y) = 0
% Written into two first order differential equations
% y'(z) = x 
% x'(z) = -eta.y'(z)-(a-2qcos(2z))sin(y)
%
n = length(x) ;
xdot=zeros(n,1);
theta = x(1) ;
Dtheta = x(2) ;
q = x(3) ;
a = x(4) ;
eta = x(5) ;
xdot(1) = Dtheta;
xdot(2) = -eta*Dtheta-(a-2*q*cos(2*t))*sin(theta);