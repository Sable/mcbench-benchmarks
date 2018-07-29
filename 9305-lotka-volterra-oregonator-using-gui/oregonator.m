function xdot=oregonator(t,x)

s=100;q=1E-6;f=1.1;w=3.835;

xdot(1)=s*(x(1)+x(2)-x(1)*x(2)-q*x(1)^2);
xdot(2)=1/s*(-x(2)-x(1)*x(2)+f*x(3));
xdot(3)=w*(x(1)-x(3));

xdot=xdot';
