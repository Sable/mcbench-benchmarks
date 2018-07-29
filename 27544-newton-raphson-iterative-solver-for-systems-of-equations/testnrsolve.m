%Routine to test nrsolve with various systems of linear and non-linear
%equations.  Systems with 0, 1, and 2 solutions are investigated with
%variation of initial guesses.

%==========================================================================
%Solve an example problem of 3 equations, 3 unknowns and 1 solution:
%   2x + y + 3z = 1
%   2x + 6y + 8z = 3
%   6x + 8y + 18z = 5
clc
close all

fprintf('--------------------------------------------------------------\n')
fprintf('Example 1:\n')
fprintf('\nSolving linear system with 1 solution:\n')
fprintf('2x + y + 3z = 1\n')
fprintf('2x + 6y + 8z = 3\n')
fprintf('6x + 8y + 18z = 5\n')
fprintf('\n')

F = {'2*v1+v2+3*v3-1';'2*v1+6*v2+8*v3-3';'6*v1+8*v2+18*v3-5'};
dFdx={'2','1','3';'2','6','8';'6','8','18'};
xi=zeros(3,1);
tol=eps;
max_iter=1000;

fprintf('Initial guess = %s\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x,y,z] = [%s]\n',num2str(x','%7.2f'))
fprintf('\n')

[x_list,y_list]=meshgrid((0:0.05:0.6)');
z_list1=(1-2*x_list-y_list)/3;
z_list2=(3-2*x_list-6*y_list)/3;
z_list3=(5-6*x_list-8*y_list)/5;
figure('name','Example 1')
surf(x_list,y_list,z_list1,ones(size(z_list1,1)))
hold on
surf(x_list,y_list,z_list2,50*ones(size(z_list1,1)))
surf(x_list,y_list,z_list3,100*ones(size(z_list1,1)))
axis equal
plot3(x(1),x(2),x(3),'or')
xlabel('x')
ylabel('y')
zlabel('z')
fprintf('See Figure 1\n')
fprintf('--------------------------------------------------------------\n')
clear x_list y_list z_list*
%==========================================================================
%Attempt an example problem of 3 equations, 3 unknowns, and NO solution
%  x     + z = 1
%  x + y + z = 2
%  x – y + z = 1
fprintf('Example 2:\n')
fprintf('\nAttempting linear system with no solutions:\n')
fprintf('x     + z = 1\n')
fprintf('x + y + z = 2\n')
fprintf('x – y + z = 1\n')
fprintf('\n')

F = {'v1+v3-1';'v1+v2+v3-2';'v1-v2+v3-1'};
dFdx = {'1','0','1';'1','1','1';'1','-1','1'};
xi=zeros(3,1);
tol=eps;
max_iter=1000;

fprintf('Initial guess = %s\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x,y,z] = [%s]\n',num2str(x','%7.2f'))
fprintf('\n')
fprintf('--------------------------------------------------------------\n')
%==========================================================================
%Solve an example problem of 1 equation, 1 unknown and 2 solutions:
%   x^2 + x = 10
fprintf('Example 3:\n')
fprintf('\nSolving non-linear system with 1 solution:\n')
fprintf('x^2 + x = 10\n')
fprintf('\n')

F = {'v1^2+v1-10'};
dFdx={'2*v1+1'};
xi=0;
tol=eps;
max_iter=1000;

figure('name','Example 3')
x_list=(-5:0.001:5)';
plot(x_list,x_list.^2+x_list-10,'-b')
xlabel('x')
ylabel('F')
hold on
plot(x_list,zeros(size(x_list,1),1),'-g')
grid on

fprintf('Initial guess = %s\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x] = %s\n',num2str(x','%7.2f'))
fprintf('\n')
plot(x,0,'or')

xi=-5;
fprintf('Initial guess = %s\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x] = %s\n',num2str(x','%7.2f'))
fprintf('\n')
plot(x,0,'or')
fprintf('See Figure 2\n')
fprintf('--------------------------------------------------------------\n')

%==========================================================================
%Attempt an example problem of 2 equations, 2 unknowns, non-linear, with 2
%solutions
%(A circle with a line drawn through it, see figure)
%  y = -x - 3
%  x^2 + y^2 = 17
fprintf('Example 4:\n')
fprintf('\nSolving non-linear system with 2 solutions:\n')
fprintf('y = -x - 3\n')
fprintf('x^2 + y^2 = 17\n')
fprintf('\n')

F={'v1+v2+3';'v1^2+v2^2-17'};
dFdx={'1','1';'2*v1','2*v2'};
xi=[0;0];
tol=eps;
max_iter=1000;

figure('name','Example 4')
x_list=(-5:0.001:2)';
y=(-x_list)-3;
plot(x_list,y,'-b')
xlabel('x')
ylabel('y')
axis equal
hold on
r=sqrt(17);
x_list=r*cos((0:0.01:2*pi)');
y_list=r*sin((0:0.01:2*pi)');
plot(x_list,y_list,'-g')
xlim([-5,5])
ylim([-5,5])
set(gca,'xtick',(-5:1:5)')
set(gca,'ytick',(-5:1:5)')
grid on

fprintf('Bad guess = [%s]\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x,y] = [%s]\n\n',num2str(x','%7.2f'))

xi=[0;-5];
fprintf('Good guess = [%s]\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x,y] = [%s]\n\n',num2str(x','%7.2f'))
plot(x(1),x(2),'or')

xi=[-5;0];
fprintf('Another good guess = [%s]\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x,y] = [%s]\n',num2str(x','%7.2f'))
fprintf('\n')
fprintf('See Figure 3\n')
fprintf('--------------------------------------------------------------\n')
plot(x(1),x(2),'or')


%Attempt an example problem of 1 equation, 1 unknown, non-linear, with
%built-in Matlab function use and definition of extra constants.
%
%  betainc(x,20,2)=0.9

fprintf('Example 5:\n')
fprintf('\nSolving non-linear system with 1 solution using built-in Matlab functions\n')
fprintf('betainc and beta as well as passing constants c1 and c2 into nrsolve:\n')
fprintf('betainc(x,20,2)=0.6\n')
fprintf('\n')

F={'betainc(v1,c1,c2)-0.6'};
dFdx={'((1-v1)^(c2-1)*v1^(c1))/beta(c1,c2)'};
xi=0.87;
tol=eps;
max_iter=1000;
c1=20;
c2=2;

fprintf('Initial guess = [%s]\n',num2str(xi','%7.2f'))
x = nrsolve(F,dFdx,xi,tol,max_iter,c1,c2);

if ~isnan(x)
    fprintf('Success!\n')
else
    fprintf('No luck!\n')
end
fprintf('[x] = %s\n\n',num2str(x','%7.6f'))
fprintf('\n')
fprintf('See Figure 4\n')

figure('name','Example 5: Incomplete Beta Function')
x_list=(0.5:0.001:1)';
F_list=betainc(x_list,20,2)-0.6;
plot(x_list,F_list,'-b')
hold on
plot(x_list,zeros(size(x_list,1)),'-g')
plot(x,0,'or')
xlabel('x')
ylabel('F')
ylim([-1,0.5])
set(gca,'ytick',(-1:0.1:0.5)')
grid on

fprintf('--------------------------------------------------------------\n')

clear F dFdx xi x tol max_iter r x_list y_list F_list c1 c2 y
