%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Example 3}
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
%    \dddot{y} + 3 \ddot{y} + 3 \dot{y} + y = 30 e^{-x}
%    \hspace{5mm}
%    \text{with}
%    \hspace{5mm}
%    y(0) = 3,
%   \hspace{3mm}
%   \dot{y}(0) = - 3
%   \hspace{3mm}
%   \text{and} 
%   \hspace{3mm}
%   \ddot{y}(0) = -47
% \end{equation}
%
% The analytical solution to this problem is:
%
% \begin{equation}
%   y(x) = (3 - 25 x^2 + 5 x^3 ) e^{-x},
% \end{equation}
%
% for $0 \leq x \leq 8$. This example has been taken 
% from~\cite{adams}. 
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
Eq = '$$\ddot{y} + 3 \ddot{y} + 3 \dot{y} + y = 30 e^{-x}$$, with, $$y(0) = 3$$, $$ \dot{y}(0) - 3$$ and $$\ddot{y}(0) = -47$$' ;
Sol = '$$y(x) = (3 - 25 x^2) e^{-x} + 5 x^3 e^{-x}$$' ;
%
%%
% \section{Define the Matrix Linear Differential Operator}
%
% Define the number of points used in the solution
%
noPts = 73 ;
%
% Define the interval
%
xMin = 0 ;
xMax = 8 ;
%
params = [xMin, xMax, noPts ];
%%
%\section{Using the \lstinline{odeSolveIVP} tool}
%
% Use the odeSolveIVP tool to compute the solution
%
[y, x, vals] = odeSolveIVP( [1;3;3;1] , '30*exp(-x)', [ 3 ; -3; -47 ] , params, 13);
%
% For comparison solve using the MATLAB ode45 method.
% Runge-Kutta Solution:
%
[xm,Y] = ode45(@eulerODE03,[xMin xMax],[3 -3 -47]);
%
ym = Y(:,1);
%
% The Analytic Solution
%
f = inline('(3 - 25 * x.^2).* exp(-x) + 5 * (x.^3).*exp(-x)') ;
%
ya = f(x);

%%
% \section{Plot the Results}
%
% for plot purposes solve beyond the ends
%
xp = linspace(xMin,xMax,1000) ;
yp = f(xp);
%
% Present the solutions
%
fig1 = figure;
plot( xp, yp, 'k' ) ;
hold on
plot( x, y, 'ko', 'MarkerFaceColor', 'w' ) ;
%
plot( xm, ym,'kv');
legend('Analytical','New','Runge-Kutta','Location','SouthEast');
xlabel('$$x$$');
ylabel('$$y$$');
grid on;
range = axis;
plot( range(1:2), [0,0],'k');
%
%\caption{Comparison of the analytical solution, the new numberical 
% method and the Runga-Kutta solution.}
%%
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
%% Define the Bibliography
%
% \bibliographystyle{IEEETran}
% \bibliography{odebib}
