function eg1OC
%EG1OC    Example 1 of optimal control tutorial.
%    This example is from D.E.Kirk's Optimal control theory: an introduction
%    example 5.1-1 on page 198 - 202

% State equations
syms x1 x2 p1 p2 u;
Dx1 = x2;
Dx2 = -x2 + u;

% Cost function inside the integral
syms g;
g = 0.5*u^2;

% Hamiltonian
syms p1 p2 H;
H = g + p1*Dx1 + p2*Dx2;

% Costate equations
Dp1 = -diff(H,x1);
Dp2 = -diff(H,x2);

% solve for control u
du = diff(H,u);
sol_u = solve(du, 'u');

% Substitute u to state equations
Dx2 = subs(Dx2, u, sol_u);

% convert symbolic objects to strings for using 'dsolve'
eq1 = strcat('Dx1=',char(Dx1));
eq2 = strcat('Dx2=',char(Dx2));
eq3 = strcat('Dp1=',char(Dp1));
eq4 = strcat('Dp2=',char(Dp2));

sol_h = dsolve(eq1,eq2,eq3,eq4);

%% use boundary conditions to determine the coefficients
%    case a: (a) x1(0)=x2(0)=0; x1(2) = 5; x2(2) = 2;
conA1 = 'x1(0) = 0';
conA2 = 'x2(0) = 0';
conA3 = 'x1(2) = 5';
conA4 = 'x2(2) = 2';
sol_a = dsolve(eq1,eq2,eq3,eq4,conA1,conA2,conA3,conA4);

% Compare the solutions from book and Matlab
sol_book = {@(t)(7.289*t-6.103+6.696*exp(-t)-0.593*exp(t)),...
            @(t)(7.289-6.696*exp(-t)-0.593*exp(t))};         
time = linspace(0,2,20);
s_book = [sol_book{1}(time); sol_book{2}(time)];

% plot both solutions
figure(1);
ezplot(sol_a.x1,[0 2]); hold on;
ezplot(sol_a.x2,[0 2]);
ezplot(-sol_a.p2,[0 2]);    % plot the control: u=-p2
plot(time, s_book,'*');
axis([0 2 -1.6 7]);
text(0.6,0.5,'x_1(t)');
text(0.4,2.5,'x_2(t)');
text(1.6,0.5,'u(t)');
xlabel('time');
ylabel('states');
title('Solutions comparison (case a)');
hold off;
print -djpeg90 -r300 eg1a.jpg

%% --------------------------
%    case b: (a) x1(0)=x2(0)=0; p1(2) = x1(2) - 5; p2(2) = x2(2) -2;
eq1b = char(subs(sol_h.x1,'t',0));
eq2b = char(subs(sol_h.x2,'t',0));
eq3b = strcat(char(subs(sol_h.p1,'t',2)),'=',char(subs(sol_h.x1,'t',2)),'-5');
eq4b = strcat(char(subs(sol_h.p2,'t',2)),'=',char(subs(sol_h.x2,'t',2)),'-2');

sol_b = solve(eq1b,eq2b,eq3b,eq4b);
% Substitute the coefficients
C1 = double(sol_b.C1);
C2 = double(sol_b.C2);
C3 = double(sol_b.C3);
C4 = double(sol_b.C4);
sol_b2 = struct('x1',{subs(sol_h.x1)},'x2',{subs(sol_h.x2)},'p1',...
                 {subs(sol_h.p1)},'p2',{subs(sol_h.p2)});
% -----------------------------------------------
% plot the result
clear sol_book time s_book;
sol_book = {@(t)(2.697*t-2.422+2.560*exp(-t)-0.137*exp(t)),...
            @(t)(2.697-2.560*exp(-t)-0.137*exp(t))};
time = linspace(0,2,20);
s_book = [sol_book{1}(time);sol_book{2}(time)];

figure(2);
ezplot(sol_b2.x1,[0 2]); hold on;
ezplot(sol_b2.x2,[0 2]);
ezplot(-sol_b2.p2,[0 2]);    % plot the control: u=-p2
plot(time, s_book,'*');
axis([0 2 -.5 3]);
text(1,.7,'x_1(t)');
text(0.4,1,'x_2(t)');
text(.2,2.5,'u(t)');
xlabel('time');
ylabel('states');
title('Solutions comparison (case b)');
hold off;
print -djpeg90 -r300 eg1b.jpg

%% --------------------------
%    case c: (a) x1(0)=x2(0)=0; x1(2)+5*x2(2) = 15; p2(2) = 5*p1(2);
eq1c = char(subs(sol_h.x1,'t',0));
eq2c = char(subs(sol_h.x2,'t',0));
eq3c = strcat(char(subs(sol_h.p2,'t',2)),'-(',char(subs(sol_h.p1,'t',2)),')*5');
eq4c = strcat(char(subs(sol_h.x1,'t',2)),'+(',char(subs(sol_h.x2,'t',2)),')*5-15');
sol_c = solve(eq1c,eq2c,eq3c,eq4c);
% Substitute the coefficients
C1 = double(sol_c.C1);
C2 = double(sol_c.C2);
C3 = double(sol_c.C3);
C4 = double(sol_c.C4);
sol_c2 = struct('x1',{subs(sol_h.x1)},'x2',{subs(sol_h.x2)},'p1',...
                 {subs(sol_h.p1)},'p2',{subs(sol_h.p2)});
%% ----
% plot the result
clear sol_book time s_book;
sol_book = {@(t)(0.894*t-1.379+1.136*exp(-t)+0.242*exp(t)),...
            @(t)(0.894-1.136*exp(-t)+0.242*exp(t))};
time = linspace(0,2,20);
s_book = [sol_book{1}(time);sol_book{2}(time)];

figure(3);
ezplot(sol_c2.x1,[0 2]); hold on;
ezplot(sol_c2.x2,[0 2]);
ezplot(-sol_c2.p2,[0 2]);    % plot the control: u=-p2
plot(time, s_book,'*');
axis([0 2 0 5]);
text(1.4,.9,'x_1(t)');
text(0.6,1,'x_2(t)');
text(.8,2.2,'u(t)');
xlabel('time');
ylabel('states');
title('Solutions comparison (case c)');
hold off;
print -djpeg90 -r300 eg1c.jpg
