function er4OC
%EG4OC    Example 4 of optimal control tutorial.
%    This example is from the following reference:
%    S.N.Avvakumov and Yu.N.Kiselev, "Boundary value problem for ordinary
%    differential equations with applications to optimal control". 
%    Example 5 on page 8

global mu;
mu = 0.5;
solinit = bvpinit(linspace(0,1,10),[2;2;0;-1],4);

sol = bvp4c(@ode,@bc,solinit);

figure(1)
lines = {'k-.','r--','b-'};
ut = sol.y(4,:)./sqrt(mu*sol.y(3,:).^2+sol.y(4,:).^2);
t = sol.parameters*sol.x;
plot(t,ut,lines{1});
% axis([-0.1 1.1 0 1.7]);
title('Smoothed control');
xlabel('t');
ylabel('u');
drawnow; hold on;

figure(2)
plot(sol.y(1,:),sol.y(2,:),lines{1});
% axis([-0.1 1.1 0 1.7]);
title('Admissible trajectories');
xlabel('x_1');
ylabel('x_2');
drawnow; hold on;

% the solution for one value of mu is used as guess for the next.
for i=2:3
  if i==2
      mu = 0.3;
  else
      mu = .1;
  end;
  % After creating function handles, the new value of mu 
  % will be used in nested functions.
  sol = bvp4c(@ode,@bc,sol);
  figure(2)
  plot(sol.y(1,:),sol.y(2,:),lines{i});
  drawnow;
  
  figure(1)
  ut = sol.y(4,:)./sqrt(mu*sol.y(3,:).^2+sol.y(4,:).^2);
  t = sol.parameters*sol.x;
  plot(t,ut,lines{i});
  drawnow;
  
end
figure(1); legend('mu = 0.5', 'mu = 0.3', 'mu = 0.1', ...
                  'Location', 'NorthWest'); hold off;
figure(2); legend('mu = 0.5', 'mu = 0.3', 'mu = 0.1', ...
                  'Location', 'NorthWest'); hold off;
              
% print -djpeg90 -f1 -r300 eg4_trajectory.jpg;
% print -djpeg90 -f2 -r300 eg4_control.jpg

% --------------------------------------------------------------------------
function dydt = ode(t,y,T)
global mu;
term = sqrt(mu*y(3)^2+y(4)^2);
dydt = T*[ y(2) + mu*y(3)/term
           y(4)/term
           0
           -y(3)];

% --------------------------------------------------------------------------
% boundary conditions, with 4 states and 1 parameters, 5 conditions are
% needed: x1(0) =2, x2(0) = 2; x1(1) = 0; x2(1) = 0; x3(1)^2+x4(1)^2 = 1;
function res = bc(ya,yb,T)
res = [ya(1)-2
       ya(2)-2
       yb(1)
       yb(2)
       yb(3)^2+yb(4)^2-1];