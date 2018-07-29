% Control of a water tank temperature
% Case of Proportional-Integral Control
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

% Main program calls function PI_control 
% and plot results: sensor and tank temperatures and heat input to the water tank

tf = 150;

x0=[20 2500 20 0];

[t,x] = ode15s('PI_control',[0 tf],x0);

x1=x(:,1);
x2=x(:,2);
x3=x(:,3);

figure(1);
hold on
plot(t,x1,'r');
plot(t,x3,'b');
hold off

figure(2);
hold on;
plot(t,x2,'c');
hold off;
