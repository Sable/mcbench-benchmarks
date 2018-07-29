% Chapter 10 - Limit Cycles.
% Programs_10b - Phase Portrait (Fig. 10.2).
% Copyright Birkhauser 2013. Stephen Lynch.

% Limit cycle of a van der Pol system.
% IMPORTANT - Programs_10a.m is vectorfield.m.
clear
hold on
% sys=inline('[x(2);-x(1)-5*x(2)*((x(1))^2-1)]','t', 'x');
sys = @(t,x) [x(2);-x(1)-5*x(2)*((x(1))^2-1)]; 
vectorfield(sys,-3:.3:3,-10:1.3:10);
[t,xs] = ode45(sys,[0 30],[2 1]);
plot(xs(:,1),xs(:,2))      
hold off
axis([-3 3 -10 10])
fsize=15;
set(gca,'XTick',-3:1:3,'FontSize',fsize)
set(gca,'YTick',-10:5:10,'FontSize',fsize)
xlabel('x(t)','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)
hold off

% End of Programs_10b.