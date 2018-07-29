% Chapter 8 - Planar Systems.
% Program_8b - Phase Portrait (Fig. 8.8(a)).
% Copyright Birkhauser 2013. Stephen Lynch.

% Phase portrait of a linear system of ODE's.
% IMPORTANT - Program_8a is vectorfield.m.
clear;
% sys=inline('[2*x(1)+x(2);x(1)+2*x(2)]','t', 'x');
sys = @(t,x) [2*x(1)+x(2);x(1)+2*x(2)]; 
vectorfield(sys,-3:.25:3,-3:.25:3)
     hold on
     for x0=-3:1.5:3
         for y0=-3:1.5:3
            [ts,xs] = ode45(sys,[0 5],[x0 y0]);
            plot(xs(:,1),xs(:,2))
         end
     end
     for x0=-3:1.5:3
         for y0=-3:1.5:3
            [ts,xs] = ode45(sys,[0 -5],[x0 y0]);
            plot(xs(:,1),xs(:,2))
         end
     end
     hold off
axis([-3 3 -3 3])
fsize=15;
set(gca,'XTick',-3:1:3,'FontSize',fsize)
set(gca,'YTick',-3:1:3,'FontSize',fsize)
xlabel('x(t)','FontSize',fsize)
ylabel('y(t)','FontSize',fsize)
hold off

% End of Program_8b.