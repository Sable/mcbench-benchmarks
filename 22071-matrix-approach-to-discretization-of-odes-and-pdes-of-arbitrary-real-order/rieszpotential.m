% Script for solving the integral equation
% with Riesz kernel:
%    \int_{-1}^{+1} y(\tau) |t-\tau|^{-\alpha} d\tau =
%            = pi/cos(alpha*pi/2)) ,
% which has the exact solution
%    y(t) = gamma(1-alpha)*(1-t^2)^{(\alpha -1 )/2}
%
% 

clear all

% Analytical solution:
t=-1:0.02:1;
nu=0.8;
y=gamma(1-nu)*(1-t.^2).^((nu -1 )/2)*(cos(nu*pi/2))/(pi);

% Prepare constants for the numerical solution:
alpha=-(1-nu);  % we need to write the equation using left- and right-sided fractional derivatives
h=0.005;        % step of discretization
N=2/h + 1;      % number of points in the interval [-1, 1]
B=zeros(N,N);   % preallocation of memory

% Make the main matrix R:
% the Riesz potential is a sum of left- and right-sided fractional derivatives:
R = ban(alpha, N, h) + fan(alpha, N, h);

% Make the right-hand side:
F=ones(N,1);

% (2) Solve the system RY=F:
Y=R\F;

% Plot both solutions for comparison:
% (1) Plot analytical solution:
plot(t,y,'b','linewidth',1)
hold on
% (2) Plot numerical solution:
T=-1:h:1;
plot(T(1:10:N),Y(1:10:N),'r*')
% (3) Arrange plots, title, legend, grid:
set(gca, 'ylim',[0.4 0.8])
grid on
title(['Integral equation with Riesz kernel:    ' ...
      '\int_{-1}^{1}|t-\tau|^{-\nu}y(\tau)d\tau=1'], ...
   'interpreter','tex')
legend('analytical solution', 'numerical solution')
hold off

