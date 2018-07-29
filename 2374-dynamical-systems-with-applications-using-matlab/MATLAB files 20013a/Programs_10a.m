% Chapter 10 - Limit Cycles.
% Programs_10a - Phase Portrait.
% Copyright Birkhauser 2013. Stephen Lynch.

% Limit cycle of a Fitzhugh-Nagumo system.
% This is a simple model of an integrate and fire neuron.
clear
hold on
C=2;alpha=0.1;epsilon=0.1;gamma=0.1;
sys = @(t,x) [C+x(1)*(x(1)-alpha)*(1-x(1))-x(2);epsilon*(x(1)-gamma*x(2))]; 
vectorfield(sys,-1:.2:2,1:.2:3);
[t,xs] = ode45(sys,[0 100],[.5 1]);
plot(xs(:,1),xs(:,2))      
hold off
axis([-1 2 1 3])
fsize=15;
set(gca,'XTick',-1:1:2,'FontSize',fsize)
set(gca,'YTick',1:1:3,'FontSize',fsize)
xlabel('x(t)','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)
hold off

% End of Programs_10a.