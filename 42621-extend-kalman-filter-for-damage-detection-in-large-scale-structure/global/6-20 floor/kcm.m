function [stiff,damp,xkp, xap,xbp]=kcm(n,xk)
k(1:n-1)=xk(2*n+1:3*n-1);  % Stiffness parameters
alfa=xk(3*n);
beta=xk(3*n+1);
x=xk(1:n);  % Displacement 
xp=xk(n+1:2*n);  %Velocity 
m2(1:6)=10^6*1.1;
mass2=diag(m2);

stiff=[k(1),    -k(1),        0,      0,      0,      0;
	  -k(1),k(1)+k(2),    -k(2),      0,      0,      0;
		  0,    -k(2),k(2)+k(3),  -k(3),      0,      0;
		  0,0,-k(3),k(3)+k(4),-k(4),0;
		0,0,0,-k(4),k(4)+k(5),-k(5);
        0,0,0,0,-k(5),-k(5)];
	
xkp1=[x(1)-x(2),0,0,0,0;
    -x(1)+x(2),x(2)-x(3),0,0,0;
    0,-x(2)+x(3),x(3)-x(4),0,0;
    0,0,-x(3)+x(4),x(4)-x(5),0;
    0,0,0,-x(4)+x(5),x(5)-x(6);
    0,0,0,0,x(5)-x(6);];

    
xkp2=[xk(1)-xk(2),0,0,0,0;
    -xk(1)+xk(2),xk(2)-xk(3),0,0,0;
    0,-xk(2)+xk(3),xk(3)-xk(4),0,0;
    0,0,-xk(3)+xk(4),xk(4)-xk(5),0;
    0,0,0,-xk(4)+xk(5),xk(5)-xk(6);
    0,0,0,0,xk(5)-xk(6);];

xkp=xkp1+beta*xkp2;
xap=mass2*xp;
xbp=stiff*xp;
damp=alfa*mass2+beta*stiff;



