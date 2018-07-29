function xx = Equation(t,x)
% Set the input values in order to pass onto ode45
%
n = length(x) ;
r = x(1) ;
rdot = x(2) ;
Phi = x(3) ;
Phidot = x(4) ;
g = x(5) ; 
M = x(6) ; 
L = x(7) ;
K = x(8) ;
%
wr = sqrt(K/M) ;      
wPhi = sqrt(g/(L+r));
%
xx=zeros(n,1);
%
xx(1)= rdot;
xx(2)= (r+L)*Phidot^2+g*cos(Phi)-wr^2*(r) ;
xx(3) = Phidot ;
xx(4) = -2*rdot*Phidot/(L+r)-wPhi^2*sin(Phi) ;

