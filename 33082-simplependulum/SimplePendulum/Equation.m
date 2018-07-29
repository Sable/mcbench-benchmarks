function xdot = Equation(~,x)
% Set the input values in order to pass onto ode45
%
n = length(x) ;
phi = x(1) ;
dtphi = x(2) ;
g = x(3) ; 
M = x(4) ; 
L = x(5) ;
C = x(6) ;
%
w0 = g/L;
eta = C/(M*L);


xdot=zeros(n,1);

xdot(1)=x(2);
xdot(2)=-(w0*sin(phi)+eta*dtphi);

