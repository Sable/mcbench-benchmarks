function eg2OC_BVP
%EG2OC_BVP    Example 2 of optimal control tutorial.
%    This example is from D.E.Kirk's Optimal control theory: an introduction
%    example 6.2-2 on page 338-339
%    The problem is reformulated as a boundary value problem (BVP)
%    and solved with bvp4c solver

% Initial guess for the solution
solinit = bvpinit(linspace(0,0.78,50), [0 0 0.5 0.5]);
options = bvpset('Stats','on','RelTol',1e-1);
global R;
R = 0.1;
sol = bvp4c(@BVP_ode, @BVP_bc, solinit, options);
t = sol.x;
y = sol.y;

% Calculate u(t) from x1,x2,p1,p2
ut = (y(3,:).*(y(1,:) + 1/4))/(2*0.1);
n = length(t);
% Calculate the cost
J = 0.78*(y(1,:)*y(1,:)' + y(2,:)*y(2,:)' + ut*ut'*0.1)/n;

figure(1);
plot(t, y(1:2,:)','-');hold on;
plot(t,ut', 'r:')
text(.2,0.08,'x_1(t)');
text(.3,-.1,'x_2(t)');
text(.2,.4, 'u(t)');
s = strcat('Final cost is: J=',num2str(J));
text(.4,1,s);
xlabel('time');
ylabel('states');
hold off;
print -djpeg90 -r300 eg2_bvp.jpg

%------------------------------------------------
% ODE's for states and costates
function dydt = BVP_ode(t,y)
global R;
t1 = y(1)+.25;
t2 = y(2)+.5;
t3 = exp(25*y(1)/(y(2)+2));
t4 = 50/(y(1)+2)^2;
u =  y(3)*t1/(2*R);

dydt = [-2*t1+t2*t3-t2*u
        0.5-y(2)-t2*t3
        -2*y(1)+2*y(3)-y(3)*t2*t4*t3+y(3)*u+y(4)*t2*t4*t3
        -2*y(2)-y(3)*t3+y(4)*(1+t3)];

% -----------------------------------------------
% The boundary conditions:
% x1(0) = 0.05, x2(0) = 0, tf = 0.78, p1(tf) = 0, p2(tf) = 0;
function res = BVP_bc(ya,yb)
res = [ ya(1) - 0.05
        ya(2) - 0
        yb(3) - 0
        yb(4) - 0 ];
