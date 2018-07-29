% Chapter 14 - Poincare Maps and Nonautonomous Systems in the Plane.
% Programs_14c - Phase portraits for nonautonomous systems.
% Copyright Birkhauser 2013. Stephen Lynch.

% Phase portrait for the Duffing system.

deq=@(t,x) [x(2);x(1)-0.3*x(2)-(x(1))^3+0.5*cos(1.25*t)]; 
options=odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,xx]=ode45(deq,[0 200],[1,0],options);

plot(xx(:,1),xx(:,2))

fsize=15;
axis([-2 2 -2 2])
xlabel('x','FontSize',fsize)
ylabel('y','FontSize',fsize)

% End of Programs_14c.