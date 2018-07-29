% Chapter 13 - Three-Dimensional Autonomous Systems and Chaos.
% Programs_13a - 3-D Phase Portrait (Lorenz).
% Copyright Birkhauser 2013. Stephen Lynch.

% Lorenz=inline('[10*(x(2)-x(1));28*x(1)-x(2)-x(1)*x(3);x(1)*x(2)-(8/3)*x(3)]','t','x');
sigma=10;r=28;b=8/3;
Lorenz=@(t,x) [sigma*(x(2)-x(1));r*x(1)-x(2)-x(1)*x(3);x(1)*x(2)-b*x(3)]; 
options = odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,xa]=ode45(Lorenz,[0 100],[15,20,30],options);
plot3(xa(:,1),xa(:,2),xa(:,3))
title('The Lorenz Attractor')

fsize=15;
xlabel('x(t)','Fontsize',fsize);
ylabel('y(t)','Fontsize',fsize);
zlabel('z(t)','FontSize',fsize);

% End of Programs_13a.

