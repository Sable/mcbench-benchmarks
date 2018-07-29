% Chua_3D_Attractor - 3D Chaotic Attractor.
% Copyright Springer 2013 Stephen Lynch.
% Click on Rotate 3D to rotate the attractor.
Chua=@(t,x) [15*(x(2)-x(1)-(-(5/7)*x(1)+(1/2)*(-(8/7)-(-5/7))*(abs(x(1)+1)-abs(x(1)-1))));x(1)-x(2)+x(3);-25.58*x(2)];
options = odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,xb]=ode45(Chua,[0 100],[-1.6,0,1.6],options);
plot3(xb(:,1),xb(:,2),xb(:,3))
title('Chaotic Attractor')
fsize=15;
xlabel('x','FontSize',fsize)
ylabel('y','FontSize',fsize)
zlabel('z','FontSize',fsize)


