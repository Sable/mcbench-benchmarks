function xdot=LV(t,x)

A = 3.7; k1 = 1.2; k2 = 1.5; k3 = 1.2;

xdot(1)=k1*A*x(1) - k2*x(1)*x(2);
xdot(2)=k2*x(1)*x(2) - k3*x(2);

xdot=xdot';
