%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Example 2}
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
%
%%
%\section{Initial Value Problem}
%
% This file demonstrated the solution of initial value problems using the
% DOPBox and ODEBox toolbaxes. The example being considered here is:
%
% \begin{equation}
%    2\,x^2\,\ddot{y} - x\,\dot{y} - 2 y = 0
%    \hspace{5mm}
%    \text{with}
%    \hspace{5mm}
%    y(1) = 5
%   \hspace{5mm}
%   \text{and} 
%   \hspace{5mm}
%   \dot{y}(1) = 0
% \end{equation}
%
% The analytical solution to this problem is:
%
% \begin{equation}
%   y = x^2 + \frac{4}{\sqrt{x}}.
% \end{equation}
%
% This example has been taken from~\cite[pp. 394-395]{adams}. 
%
% This M-file demonstrated the new approach to solving this problem and
% compared the result with a classical runga-kutta solution as provided by
% MATLAB.
%
%
%%
%\section{Clear up the Workspace}
close all;
clear all;
setUpGraphics(12) ;
%%
% Define the equation and solution as a strings for documentation
%
Eq = '$$2\,x^2\,\ddot{y} - x\,\dot{y} - 2 y = 0$$, with, $$y(1) = 5$$ and $$\dot{y}(1) = 0$$' ;
Sol = '$$y = x^2 + \frac{4}{\sqrt{x}}$$' ;
%
%%
% \section{Define the Matrix Linear Differential Operator}
%
% Define the number of points used in the solution
%
noPts = 73 ;
%
% Define the interval and use linearly spaced nodes.
%
xMin = 1 ;
xMax = 10 ;
x = linspace( xMin, xMax, noPts )';
%
% Setup the differentiating matrix with support length 13
%
ls = 13;
D = dopDiffLocal( x, ls, ls );
%
% Define the matrix C of constraints, i.e. the initial conditions
%
C = zeros(noPts,2) ;
C(1,1) = 1 ;
C(:,2) = D(1,:)' ;
%
d = [ 5 ; 0 ] ;
%
% Compute the linear differential operator.
%
L = 2*diag(x.^2)*D*D - diag(x)*D - 2*eye(noPts) ;
%%
% \section{Compute the solutions}
%
% Solve the algebraic system of equations
%
y = odeLSE(L,[],C,d) ;
%%
% For comparison solve using the MATLAB ode45 method.
% Runge-Kutta Solution:
%
[xm,Y] = ode45(@eulerODE02,[xMin xMax],[5 0]);
%
ym = Y(:,1);
%%
% the analytical solution for comparison.
%
f = inline('x.^2 + (4./(sqrt(x)))') ;
%
ya = f(x);
%%
% \section{Plot the results}
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
legend('Analytical','New','Runge-Kutta','Location','Northwest');
xlabel('$$x$$');
ylabel('$$y$$');
grid on;
range = axis;
plot( range(1:2), [0,0],'k');
axis([0.5,10.5,0,110]);
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
% \caption{Comparison the residual error for the new method (top) and 
% for the Runga-Kutta method (Bottom). Note the residual is orders of magnitude smaller for the new method.}
%%
%\section{Save the figures to disk}
fileType = 'eps';
printFigure( fig1, 'ivpExp1Sol', fileType);
printFigure( fig2, 'ivpExp1Err', fileType);
%
%
%%
%% Define the Bibliography
%
% \bibliographystyle{IEEETran}
% \bibliography{odebib}


