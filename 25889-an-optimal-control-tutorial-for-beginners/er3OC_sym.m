function er3OC_sym
%EG3OC_sym    Example 3 of optimal control tutorial.
%    This example is from D.S.Naidu, "Optimal contorl systems"
%    page 77-80, Example 2.14
%    Symbolic toolbox is used to get the analytical solution

sol = dsolve('Dx1 = x2, Dx2 = -p2, Dp1 = 0, Dp2 = -p1',...
           'x1(0) = 1, x2(0) = 2, x1(tf) = 3, p2(tf) = 0');
eq1 = subs(sol.x1) - 'x1tf';
eq2 = subs(sol.x2) - 'x2tf';
eq3 = subs(sol.p1) - 'p1tf';
eq4 = subs(sol.p2) - 'p2tf';
eq5 = sym('p1tf*x2tf - 0.5*p2tf^2');
%%
sol_2 = solve(eq1, eq2, eq3, eq4, eq5);
tf = sol_2.tf;
x1tf = sol_2.x1tf;
x2tf = sol_2.x2tf;

x1 = subs(sol.x1);
x2 = subs(sol.x2);
p1 = subs(sol.p1);
p2 = subs(sol.p2);

%%
sol_book = {@(t)((4/54).*t.^3-(2/3)*t.^2+2.*t+1),...
            @(t)((4/18).*t.^2-(4/3).*t+2)};
u = @(t)((4/9).*t-(4/3));
t = double(tf);
time = linspace(0,t,20);
s_book = [sol_book{1}(time);sol_book{2}(time)];
ut = u(time);

figure(1);
ezplot(x1,[0 t]); hold on;
ezplot(x2,[0 t]);
plot(time, s_book,'*');
plot(time, ut, 'k:');
axis([0 t -1.5 3]);
text(1.3,2.5,'x_1(t)');
text(1.3,1,'x_2(t)');
text(1.3,-.5,'u(t)');
xlabel('time');
ylabel('states');
title('Analytical solution');
hold off;
% print -djpeg90 -r300 eg3a.jpg

%% ------------------------------------------------------------------------
% % The same procedure applied on example problem 1 with tf unknown.
% % no explicit solution could be found
% sol = dsolve('Dx1 = x2, Dx2 = -x2 - p2, Dp1 = 0, Dp2 = p1 - p2',...
%            'x1(0) = 1, x2(0) = 2, x1(tf) = 5, x2(tf) = 2');
% eq1 = subs(sol.x1) - 'x1tf';
% eq2 = subs(sol.x2) - 'x2tf';
% eq3 = subs(sol.p1) - 'p1tf';
% eq4 = subs(sol.p2) - 'p2tf';
% eq5 = sym('p1tf*x2tf-p2tf*x2tf-0.5*p2tf^2');
% 
% sol_2 = solve(eq1, eq2, eq3, eq4, eq5);
% tf = sol_2.tf;
% x1tf = sol_2.x1tf;
% x2tf = sol_2.x2tf;
% clear t;
% x1 = subs(sol.x1);
% x2 = subs(sol.x2);
% p1 = subs(sol.p1);
% p2 = subs(sol.p2);