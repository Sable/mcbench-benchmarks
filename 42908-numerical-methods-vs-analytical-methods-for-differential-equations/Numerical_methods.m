%-------------------------------------------------------------------------%
% This code performs a comparision of the analytical and Numerical methods
% of a simple first order Differential equation of the form 
%  dy/dx = f(x,y), with an initial solution y(x_0) = y_0;
%-------------------------------------------------------------------------%

clc;
close all;
clear all;    

%-------------------------------------------------------------------------%
% Initialization

Ni = 10;      % Number of steps/ iteration 
h = 0.5;      % Step size/ grid size

x(1:Ni) = 0;      % x- common for all the methods
y1(1:Ni) = 0;     
y2(1:Ni) = 0;    
y3(1:Ni) = 0;  

% Initial conditions
x(1) = 2;           % x_0
y1(1) = 4;          % y_0 for Euler's method
y2(1) = 4;          % y_0 for Modified-Euler's method
y3(1) = 4;          % y_0 for Runge-Kutta 4 method

for i = 2:Ni          % Values of x to be used
    x(i) = x(i-1)+h;
end


% Analytical solution
y_analytical = (1+0.25*x.^2).^2;

%-------------------------------------------------------------------------%
% Euler Method

for i = 2:Ni 
    tic1 = tic;
    y1(i) = y1(i-1)+h*f1(x(i-1),y1(i-1));
    t1 = toc(tic1);

end

%-------------------------------------------------------------------------%
% Modified Euler Method

for i=2:Ni
    tic2 = tic;
    y2(i) = y2(i-1)+h*f1(x(i-1)+0.5*h,y2(i-1)+0.5*h*f1(x(i-1),y2(i-1)));
    t2 = toc(tic2);
end

%-------------------------------------------------------------------------%
% Runge-Kutta order 4

for i=2:Ni
    
   tic3 = tic;
   k1 = f1(x(i-1),y3(i-1)); 
   k2 = f1(x(i-1)+0.5*h,y3(i-1)+0.5*h*k1);
   k3 = f1(x(i-1)+0.5*h,y3(i-1)+0.5*h*k2);
   k4 = f1(x(i-1)+h,y3(i-1)+h*k3);   
   y3(i) = y3(i-1)+(k1+2*(k2+k3)+k4)*h/6;
   t3 = toc(tic3);

end
%-------------------------------------------------------------------------%

% Error 

E1 = y_analytical-y1;   % Error of Euler technique
E2 = y_analytical-y2;   % Error of Modified Euler technique
E3 = y_analytical-y3;   % Error of Runge-Kutta 4 technique


figure(1)
plot(x,y_analytical,'linewidth',2);
hold on
plot(x,y1,'r','linewidth',2);
hold on;
plot(x,y2,'k','linewidth',2);
hold on;
plot(x,y3,'g-.','linewidth',2);
legend('Analytical','Euler','Modified-Euler','RK-4');
grid on;
xlabel('x','fontsize',14);
ylabel('y(x)','fontsize',14);
title('Analytical vs Numerical Solutions','fontsize',14);
h1=gca;
set(h1,'fontsize',14);
fh1 = figure(1); 
set(fh1, 'color', 'white')

figure(2)
plot(x,E1,'r','linewidth',2);
hold on
plot(x,E2,'k','linewidth',2);
hold on;
plot(x,E3,'g','linewidth',2);
legend('Euler','Modified-Euler','RK-4');
grid on
xlabel('x','fontsize',14);
ylabel('y(x)','fontsize',14);
title('Errors of the Numerical Solutions','fontsize',14);
h2=gca;
set(h2,'fontsize',14);
fh2 = figure(2); 
set(fh2, 'color', 'white')


fprintf(' Time taken for the algorithms \n\n');
fprintf(' Eulers method = %f\n',t1);
fprintf(' Modified Eulers method = %f\n',t2);
fprintf(' RK 4 method = %f\n',t3);


%--------------------------------------------------------------------------
% REF: Peter V. O'Neil, Advanced Engg. Mathematics.
%--------------------------------------------------------------------------

