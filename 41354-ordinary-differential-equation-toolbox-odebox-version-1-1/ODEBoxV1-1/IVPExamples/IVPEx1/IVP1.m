%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Example 1}
% 
% \author{Matthew Harker and Paul O'Leary\\
% Institute for Automation\\
% University of Leoben\\
% A-8700 Leoben,
% Austria\\
% URL: automation.unileoben.ac.at\\
% \\
% Original: January 9, 2013\\
% $\copyright$ 2013\\
% \\
% Last Modified: \today}
%%
%\section{Initial Value Problem}
%
% This file demonstrated the solution of initial value problems using the
% DOPBox and ODEBox toolbaxes. The example being considered here is:
%
% \begin{equation}
%    \ddot{y} + 6\,\dot{y} + 9 y = 0
%    \hspace{5mm}
%    \text{with}
%    \hspace{5mm}
%    y(0) = 10
%   \hspace{5mm}
%   \text{and} 
%   \hspace{5mm}
%   \dot{y}(0) = -75
% \end{equation}
%
% The analytical solution to this problem is:
%
% \begin{equation}
%   y(x) = 10 \, e^{-3\,x} - 45 \,x {e^{-3\,x}}.
% \end{equation}
%
% This example has been taken from~\cite{adams}. 
%
% This M-file demonstrated the new approach to solving this problem and
% compared the result with a classical runga-kutta solution as provided by
% MATLAB.
%
%%
% \section{Prepare the workspace}
%
close all;
clear all;
setUpGraphics(12) ;
%%
% Define the equation and solution as a strings for documentation
%
Eq = '$$\ddot{y} - 6\,\dot{y} - 9 y = 0$$, with, $$y(0) = 10$$ and $$\dot{y}(1) = -75$$' ;
Sol = '$$y(x) = 10 \, e^{-3\,x} - 45 \,x {e^{-3\,x}}$$';
%
%------------------------------------------------------------------
%%
% \section{Define the Matrix Linear Differential Operator}
%
% Define the number of points used in the solution
%
noPts = 85 ;
%
% Define the interval in which the problem is to be solved
%
xMin = 0 ;
xMax = 3 ;
%
% Use a nonlinear node placement. This ensures a higher density of nodes
% where the solution has a highed derivative.
%
x = linspace(0,1,noPts)';
x = 5 * x.^2;
%
% Setup the differentiating matrix, with support length 13.
%
ls = 13;
D = dopDiffLocal( x, ls, ls );
%
% Define the matrix C of constraints, i.e. the initial conditions
%
C = zeros(noPts,2) ;
%
C(1,1) = 1 ;
C(:,2) = D(1,:)' ;
%
d = [ 10 ; -75]  ;
%
% Compute the linear differential operator.
%
L = D*D + 6*D + 9*eye(noPts) ;
%%
%\section{Compute the Solutions}
%
% Solve the algebraic system of equations as a least squares problem. This
% is the actual computation of the solution of the differential equation.
%
y = odeLSE( L, [] , C, d );
%%
% For comparison solve using the MATLAB ode45 method.
% Runge-Kutta Solution:
%
[xm,Y] = ode45(@eulerODE01,[xMin xMax],d');
%
ym = Y(:,1);
%%
% Compute the Analytic Solution as an inline to compare the results
%
f = inline('10*exp(-3*t) - 45*t.*exp(-3*t)') ;
%
ya = f(x);
%%
% \section{Plot the Results}
%
% for plot purposes solve beyond the ends
%
xp = linspace(xMin-1/4,xMax+1/4,1000) ;
yp = f(xp);
%
% Present the solutions
%
setUpGraphics(12)
FigureSize=[1 1 10 6];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.13 0.15 0.86 0.82];
set(0,'DefaultaxesPosition',MyAxesPosition);
%
fig1 = figure;
plot( xp, yp, 'k' ) ;
hold on
plot( x, y, 'ko', 'MarkerFaceColor', 'w' ) ;
%
plot( xm, ym,'kv');
legend('Analytical','New','Runge-Kutta','Location','NorthEast');
xlabel('$$x$$');
ylabel('$$y$$');
grid on;
range = axis;
plot( range(1:2), [0,0],'k');
axis([-0.5,3.5,-5,15]);
plot( x, -4.5*ones(size(x)), 'k.');
%
%\caption{Comparison of the analytical solution, the new numberical 
% method and the Runga-Kutta solution.}
%%
%
setUpGraphics(12)
FigureSize=[1 1 10 6];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.13 0.13 0.86 0.82];
set(0,'DefaultaxesPosition',MyAxesPosition);
%
fig2 = figure;
subplot(2,1,1)
plot( x, y - ya, 'k', 'MarkerFaceColor', 'w' ) ;
hold on
plot( x, y - ya, 'k.', 'MarkerFaceColor', 'w' ) ;
range = axis;
plot( range(1:2), [0,0],'k');
ylabel('$$e_{L}$$');
grid on;
%title(Sol);
%
subplot(2,1,2)
plot( xm, ym - f(xm), 'k', 'MarkerFaceColor', 'w' ) ;
hold on
plot( xm, ym - f(xm), 'k.', 'MarkerFaceColor', 'w' ) ;
hold on;
range = axis;
plot( range(1:2), [0,0],'k');
xlabel('$$x$$');
ylabel('$$e_{RK}$$');
grid on;
%
% \caption{Comparison the residual error for the new method (top)  (Bottom)and 
% for the Runga-Kutta method. Note the residual is orders of magnitude smaller for the new method.}
%
%%
%\section{Save the figures to disk.}
%
fileType = 'eps';
printFigure( fig1, 'ivpExp3Sol', fileType);
printFigure( fig2, 'ivpExp3Err', fileType);
%
%% Define the Bibliography
%
% \bibliographystyle{IEEETran}
% \bibliography{odebib}
