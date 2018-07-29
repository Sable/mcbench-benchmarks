%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Boundary Value Problem: Example 1}
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
%\section{Boundary Value Problem}
%
% This file demonstrates the solution for a classical engineering boundary 
% value problem. It is the example of a cantilever with an additional
% support.
%
% \begin{figure}
%     \centering
%     \includegraphics[width=6cm]{cantileverWithSuppFig.eps}
%     \caption{Schematic of the cantilever with additional support being considered in this example.}
%    \label{fig:DCTandPolysForBeam}
% \end{figure}
% %
% The differential equation for the bending of the beam is,
% %
% \begin{equation}
%    y^{(4)} - \lambda \, y = 0
%    \hspace{2mm}
%    \text{with}
%    \hspace{2mm}
%    y(0) = 0,
%    \hspace{2mm}
%    \dot{y}(0) = 0,
%    \hspace{2mm}
%    \ddot{y}(1) = 0,
%   \hspace{2mm}
%   \text{and} 
%   \hspace{2mm}
%   y(0.8) = 0
% \end{equation}
%
%%
% \section{tidy up the Workspace}
%
close all;
clear all;
setUpGraphics;
%%
% \section{Define the Nodes and Synthesize the Basis Functions}
%
% Define the number of nodes and the number of basis functions used.
%
noPts = 1001;
noBfs = 500;
%%
% Define the nodes
%
x = dopNodes( noPts, 'gramends');
x = (x+1)/2;
%
% Synthesize a complete set of basis functions
%
B = dop( x );
%%
%
% \section{Generate the Differentiating Matrix}
%
% Set up the local differentiating matrix with support length $l_s$
%
ls = 13;
D = dopDiffLocal( x, ls, ls ); 
%%
%
% Generate a matrix for the second derivative
%
D2 = D * D;
D3 = D2 * D;
%%
% \section{Define Constraints and Generate the Admissible Functions}
%
% Define the constraints
%
c1 = zeros(noPts,1);
c1(1) = 1;
%%
% Find the node value closest to 0.8, this is only an approximation for 
% demonstration purposes. In an application requiring high accuracy a 
% node would be placed exactly at 0.8. 
%
Tinds = find( x <= 0.8 );
cAt = Tinds(end);
c2 = zeros(noPts,1);
c2(cAt) = 1;
%%
% Define the derivative constraints
%
c3 = D(1,:)';
c4 = D2(end,:)';
c5 = D3(end,:)';
%
C = [c1,c2,c3,c4,c5];
%%
% Generate the constrained basis functions
%
Bc = dopConstrain( C, B );
%%
% Truncate the basis functions
%
Bc = Bc(:,1:noBfs );
%%
% \section{Define the Linear Differential Operator for the BVP}
%
% Define the linear differential operator
%
L = Bc' * D2 * D2 * Bc;
%%
% Compute the eigenvalues and eigenvectors.
%
[Vecs, Vals] = eig( L );
%
%%
% Sort the eigenvalues and eigenvectors
%
vals = diag( Vals );
[vals, inds] = sort( vals);
Vecs = Vecs(:,inds );
%
S = Bc * Vecs;
%
%%
% \section{Write Some Results to a LATEX file}
%
% Write the Rayleigh-Ritz coefficients to a Latex file for documentation
% purposes
%
M = Vecs(1:10,1:4);
Mlatex = matrix2latex( M );
writeStringCells2file( Mlatex, 'coeffs.tex' );
%%
% \section{Plot the Results}
%
setUpGraphics(10)
FigureSize=[1 1 10 6];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.14 0.17 0.8 0.8];
set(0,'DefaultaxesPosition',MyAxesPosition);
%---------------------------------------------------------------------
% plot the first m admissible fulctions
fig1 = figure;
plot(x, Bc(:,1), 'k');
hold on;
plot(x, Bc(:,2), 'k-.');
plot(x, Bc(:,3), 'k--');
% plot(x, Bc(:,4), 'k');
grid on;
range = axis;
plot( [x(cAt), x(cAt)], range(3:4), 'k');
xlabel('$$x$$');
ylabel('$$y(x)_{a,i}$$');
%
% \caption{First $3$ admissible functions.}
%%
fig2 = figure;
plot(x, S(:,1), 'k');
hold on;
plot(x, S(:,2), 'k-.');
plot(x, S(:,3), 'k--');
% plot(x, S(:,4), 'k');
grid on;
range = axis;
plot( [x(cAt), x(cAt)], range(3:4), 'k');
xlabel('$$x$$');
ylabel('$$y(x)_{a,i}$$');
%
% \caption{First $3$ eigenfunctions.}
%%
% \section{Save the Figures to Disk}
fileType = 'eps';
printFigure( fig1, 'cantileverWithSuppAddFns', fileType);
printFigure( fig2, 'cantileverWithSuppSols', fileType);


