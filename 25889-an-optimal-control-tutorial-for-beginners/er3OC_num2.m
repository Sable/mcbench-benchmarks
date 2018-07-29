function er3OC_num2
%EG3OC_num2    Example 3 of optimal control tutorial.
%    This example is from D.S.Naidu, "Optimal contorl systems"
%    page 77-80, Example 2.14
%    The problem is formulated as a BVP and solved with bvp4c numerically

solinit = bvpinit(linspace(0,1),[2;3;1;1],2);

sol = bvp4c(@ode, @bc, solinit);
y = sol.y;
time = sol.parameters*sol.x;
ut = -y(4,:);

figure(1);
plot(time,y([1 2],:)','-'); hold on;
plot(time, ut, 'k:');
axis([0 time(1,end) -1.5 3]);
text(1.3,2.5,'x_1(t)');
text(1.3,.9,'x_2(t)');
text(1.3,-.5,'u(t)');
xlabel('time');
ylabel('states');
title('Numerical solution');
hold off;

% -------------------------------------------------------------------------
% ODE's of augmented states
function dydt = ode(t,y,T)
dydt = T*[ y(2);-y(4);0;-y(3) ];

% -------------------------------------------------------------------------
% boundary conditions: x1(0)=1;x2(0)=2, x1(tf)=3, p2(tf)=0;
%                      p1(tf)*x2(tf)-0.5*p2(2)^2
function res = bc(ya,yb,T)
res = [ ya(1) - 1; ya(2) - 2; yb(1) - 3; yb(4);
        yb(3)*yb(2)-0.5*yb(4)^2];