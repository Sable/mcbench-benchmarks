%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Sturm Liouville Example 1}
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
% \section{Sturm Liouville: Example 1}
%
% This file demonstrate the application of the DOPbox to the solution of
% Sturm-Liouville problems. This example deals with the simplest
% Sturm-Liouville , i.e. the vibrating string,
%
% \begin{equation}
%    -\ddot{y} + \lambda \, y = 0
%    \hspace{5mm}
%    \text{with}
%    \hspace{5mm}
%    y(0) = 0}
%   \hspace{5mm}
%   \text{and} 
%   \hspace{5mm}
%   \dot{y}(\pi) = 0
% \end{equation}
% %
% in the closed interval $0 \leq x \leq \pi$. The analytical solution to 
% this problem is:
% %
% \begin{align}
%   \lambda_k &= k^2,\\
%   \Phi_k &= \sin k \, x.
% \end{align}
%
%%
% \section{Tidy up the workspace}
%
clear all;
close all;
setUpGraphics;
%%
% \section{Define the Nodes and Compute the Basis Functions}
%
% Define the number of nodes and the number of basis functions used.
%
noPts = 1000;
noBfs = round( noPts / 2 );
%%
% Compute the Chebyshev points, but scaled to form a closed interval
% $0 \leq x \leq \pi$.
%
x = dopNodes( noPts, 'chebyends' );
x = pi * (x + 1)/2;
%%
% Synthesize a complete set of basis functions
%
B = dop(x);
%%
% \subsection{Generate the Differentiating Matrix}
%
% Synthesize the differentiating matrix with support length $l_s$
%
ls = 13;
D = dopDiffLocal( x, ls, ls );
%%
% \subsection{Define the Constraints and Compute the Admissible Functions}
%
% Define the constraints
%
C = zeros( noPts, 2 );
C(1,1) = 1;
C(end,end) = 1;
%%
% Compute the set of constrained basis functions
%
Bc = dopConstrain( C, B );
%%
% Truncate the basis functions
%
Bc = Bc(:,1:noBfs);
%%
% \section{Setup the Sturm-Liouville Matrix Linear Differential Operator}
%
% Setup the Linear differential operator.
%
L = - Bc' * D * D * Bc;
%%
% \section{Solve the Eigenvector Problem}
%
% Solve the eigenvalue problem
%
[Vec, Val] = eig( L );
vals = diag( Val );
%%
% Sort the solutions
%
[vals, inds] = sort(vals);
Vec = Vec(:,inds);
%%
% Compute the corresponding Eigenfunctions 
%
sols = Bc * Vec ;
%%
% \section{Compute the Analytical Solution for the Eigenvalues}
%
noV = length(vals);
n = [1:noV]';
valsT = n.^2;
%%
% compute the relative error for the first 1/2 of the solutions
%
noBfst = round( noBfs / 2 );
noBfst = noBfs;
relErr = 100*(valsT(1:noBfst) - vals(1:noBfst))./valsT(1:noBfst);
%%
% \section{Plot the results}
%
setUpGraphics(10)
FigureSize=[1 1 10 6];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.18 0.17 0.8 0.8];
set(0,'DefaultaxesPosition',MyAxesPosition);
%
xScale = 0:(length(relErr)-1);
fig1 = figure;
plot(xScale, relErr , 'k');
range = axis;
xlabel('Eigenvector number $$n$$');
ylabel('$$\frac{\lambda - \lambda_d}{\lambda} \, \, \, [ \times \, 100]$$');
grid on;
axis([0,noBfs,-0.1,0.1]);
%
% \caption{Relative error in the numerically computed eigenvalue 
% with respect to the analytical eigenvalue, relative error in \%. }
%%
%
%
setUpGraphics(10)
FigureSize=[1 1 10 10];
set(0,'DefaultFigureUnits','centimeters');
set(0,'DefaultFigurePosition',FigureSize);
set(0,'DefaultFigurePaperUnits','centimeters');
set(0,'DefaultFigurePaperPosition',FigureSize);
MyAxesPosition=[0.16 0.17 0.8 0.8];
set(0,'DefaultaxesPosition',MyAxesPosition);
%
fig2 = figure;
P1 = [0.16 0.4 0.8 0.55] ;
A = axes('position',P1);
imagesc( log10(abs(Vec) ));
colorbar;
ylabel(['Basis function number $$m$$, $$n_b = ',int2str(noBfs),'$$']);
P2 = [0.16 0.1 0.615 0.25] ;
A = axes('position',P2);
plot(xScale, relErr , 'k');
range = axis;
axis([0,noBfs,-0.1,0.1]);
grid on;
xlabel('Eigenvector number $$n$$');
ylabel('$$\%$$ rel. error in $$\lambda$$');
%
% \caption{Rayleigh-Ritz spectrum of the eigenfunctions with respect to the admissible 
% functions and the relationship to the relative error in the eigenvalue. The spectrum 
% is scaled by $log_{10}( S )$, this geives an estimate for the number of
% significant digits are available and used to compute an eigenfunction.}
%%
% \section{Write the Figures to Disk}
%
fileType = 'eps';
printFigure( fig1, ['SLEx1LambdasNb',int2str(noBfs)], fileType);
printFigure( fig2, ['SLEx1SpectrumNb',int2str(noBfs)], fileType);
