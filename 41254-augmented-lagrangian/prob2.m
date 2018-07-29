close all
clear all
clc
diary('results2.txt')

e = 5e-2;       %initialize error

a = -1;
b = .25;
c = log(0.5)+ 0.375;
Phi = @(t) (log(t+1).* (t> -0.5)) + (a*t.^2 + b*t + c).*(t<= -0.5);

%% problem 2a
f = @(x) 2*x(1) - 3*x(2);				%f(x)
G = @(x) [2; -3];						%Gradient of f(x)
H = @(x) [0, 0; 0, 0];					%Hessian of f(x)
g = @(x) x(1)^2 + x(2)^2 - 25;			%g(x)
Dg = @(x) [2*x(1); 2*x(2)];				%gradient of g(x)
Hg = {@(x) [2, 0; 0, 2]};				% Hessian of g(x)
x0 = [-2.8; 4.2];        				% set starting value
xt = [-10/sqrt(13); 15/sqrt(13)]; 		%true value
eta = 0.1;
k = 15;
disp('Problem 2a');
[x, itr] = ALH( x0, f, g, G, H, Dg, Hg, e, k, eta);

%% Problem 2b
f = @(x) x(1)^2 + 2*x(1)*x(2) + x(2)^2;			%f(x)
G = @(x) [2*x(1) + 2*x(2); 2*x(2) + 2*x(1)];    %Gradient of f(x)
H = @(x) [2, 2; 2, 2];                          %Hessian of f(x)
g = @(x) 3*x(1)^2 + x(2)^2 - 9;                 %g(x)
Dg = @(x) [6*x(1); 2*x(2)];                     %gradient of g(x)
Hg = {@(x) [6, 0; 0, 2]};               		% Hessian of g(x)
x0 = [-1.6; 1.6];                           % set starting value
xt = [-1.5; 1.5];                               %true value
k = 1;
eta = 0.1;
disp('Problem 2b');
[x, itr] = ALH( x0, f, g, G, H, Dg, Hg, e, k, eta);

%% Problem 2c
f = @(x) 3*x(1)^3 + 2*x(2)^3 + x(3)^3 + x(4)^3;                                           %f(x)
G = @(x) [9*x(1)^2; 6*x(2)^2; 3*x(3)^2; 3*x(4)^2];                                        %Gradient of f(x)
H = @(x) [18*x(1), 0, 0, 0; 0, 12*x(2)^2, 0, 0; 0, 0, 6*x(3), 0; 0, 0, 0, 6*x(4)];        %Hessian of f(x)
g = @(x) [x(1)^2 + x(2)^2 + x(3)^2 + x(4)^2 - 4; x(1) + x(2) + 2*x(3) + 3*x(4) - 1];      %g(x)
Dg = @(x) [2*x(1), 1; 2*x(2), 1; 2*x(3), 2; 2*x(4), 3];                                   %gradient of g(x)
Hg = {@(x) eye(4)*2; @(x) eye(4)*0};                                                      % Hessian of g(x)
x0 =[-1.8; 0.2; 0.4; 0.6];        %set starting value                                 % set starting value
xt1 = [-1.84931; 0.20806; 0.41612; 0.603003];                                              %true value
%0.557817,0.718959, 1.43792, - 1.05087
k = 200;
eta = 0.1;
disp('Problem 2c');
[x, itr] = ALH( x0, f, g, G, H, Dg, Hg, e, k, eta);
diary off