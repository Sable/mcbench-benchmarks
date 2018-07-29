%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Getting Started with the odeSolveIVP Tool}
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
% This is the documentation for the \lstinline{odeSolveIVP.m} file. This is
% a tool for the solution of initial value problems. It offers a very
% simple interface to solving such problems. Two different examples are
% documented here to show the different possible calls to the tool. The
% examples which have been selected are from Kreyszig~\cite{Kreyszig2010} 
% and Adams~\cite{Adams}, since this
% give the analytical results enabling a comparison with the numerical
% solutions.
%
%%
% \section{Tidy up the Workspace}
clear all;
close all;
setUpGraphics;
%
%%
% \section{IVP Example 1}
%
% The equation being considered here is:
% %
% \begin{equation}
%   \dddot{y} + 3 \, \ddot{y} + 3 \, \dot{y} + y = 30 \, \mathrm{e}^{-x},
% \end{equation}
% %
% with the initial conditions
% %
% \begin{equation}
%   y(0) = 3,
%   \hspace{2mm}
%   \dot{y}(0) = -3,
%   \hspace{2mm}
%   \text{and}
%   \hspace{2mm}
%   \ddot{y}(0) = -47.
% \end{equation}
% %
% The analytical solution to this equation is,
% %
% \begin{equation}
%   (3 - 25 \, x^2 + 5 \, x^3)  \, \mathrm{e}^{-x}
% \end{equation}
%
% this example is from~\cite[Chapter 2]{Kreyszig2010}.
%%
% \subsection{Define the paramates for $x$.}
% 
% Define the minimum, maximum x values and the number of points desired for
% the solution.
%
xMin = 0 ;
xMax = 10 ;
noPts = 73 ;
%%
% Setup the paramater vector
%
params = [xMin, xMax, noPts ];
%%
% \subsection{Call the \lstinline{odeSolveIVP}}
%
% A vector cof constant coefficients are used for this example equation.
%
[y, x, vals] = odeSolveIVP( [1;3;3;1] , '30*exp(-x)', [ 3 ; -3; -47 ] , params, 13);
%%
% Defining a MATLAB inline function for the analytical solution.
%
f = inline('(3 - 25 * x.^2).* exp(-x) + 5 * (x.^3).*exp(-x)') ;
%%
% \subsection{Plot the Results}
%
% The inline analytical solution is computed during plotting.
%
fig1 = figure;
plot( x, f(x), 'k');
hold on;
plot( x, y, 'ro');
grid on;
xlabel('$$x$$');
ylabel('$$y(x)$$');
legend('Analytic','Numerical','Location','SouthEast');
%
%\caption{Comparison of the analytical and the numerical solution for the first example.}
%%
% \section{IVP Example 2}
%
% The equation being considered here is:
% %
% \begin{equation}
%   x^2 \ddot{y} - 3 \, x\, \dot{y} + 13 y = 0,
% \end{equation}
% %
% with the initial conditions
% %
% \begin{equation}
%   y(0) = 5,
%   \hspace{2mm}
%   \text{and}
%   \hspace{2mm}
%   \dot{y}(0) = 0,
% \end{equation}
% %
% The analytical solution to this equation is,
% %
% \begin{equation}
%   5 \, x^2 \, \cos(3 \log(x)) - (10/3) \, x^2 \, \sin(3 \log(x))
% \end{equation}
%
% this example if from~\cite{Adams}.
%%
% \subsection{Define the paramates for $x$.}
% 
% Define the minimum, maximum x values and the number of points desired for
% the solution.
%
noPts = 73 ;
xMin = 1 ;
xMax = 5 ;
%%
% Generate the vector of x values for which the equation should be solved.
% We are now artifically generating a nonuniformly spaced set of pointe to
% compute the solution. This is done to demonstrate the possibility of
% working with arbitrary nodes.
%
z = linspace( 0, 1, noPts )';
z = z.^2;
%
x = xMin + z * (xMax - xMin);
%
%%
% \subsection{Call the \lstinline{odeSolveIVP}}
%
% This is an equation with variable coefficients, i.e., the coefficients
% are functions of $x$. the functions are defines as strings which can be
% computed to inline functions. the notation [] is used to indicate that 
% its is a homogeneous equation, i.e., the forcing function is identically 
% zero. This call is with x as a vector of points where the solution should 
% be computed.
%
[y, x, vals] = odeSolveIVP( {'x.^2';'-3*x';'13'} , [], [ 5 ; 0 ] , x, 13);
%% 
% The inline for the analytical solution is, this is only needed for
% comparison purposes.
%
f = inline('5*x.^2.*cos(3*log(x)) - (10/3)*x.^2.*sin(3*log(x))') ;
%%
% \subsection{Plot the Results}
fig1 = figure;
plot( x, f(x), 'k');
hold on;
plot( x, y, 'ro');
grid on;
xlabel('$$x$$');
ylabel('$$y(x)$$');
legend('Analytic','Numerical','Location','NorthWest');
%
%\caption{Comparison of the analytical and the numerical solution for the 
% second example. Note the non-uniform spacing of the nodes.}
%
%% Define the Bibliography
%
% \bibliographystyle{plain}
% \bibliography{odebib}