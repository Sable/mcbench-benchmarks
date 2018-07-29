%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Sturm Liouville Example 2\\
% The Mathieu Differential Equation}
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
% \section{The Mathieu Differential Equation}
%
% This example addresses the solution of the Mathieu differential equation.
% This equation occurs in conjunction with the modelling of the vibration
% of a ellptical membrane. The problem has no known analytical solution.
% %
% \begin{equation}
%    -\ddot{y} + 2 \,r \, \cos( 2 \, x )= \lambda \, y
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
% in the closed interval $0 \leq x \leq \pi$.
%
%%
% \section{tidy up the Workspace}
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
noBfs = round( noPts/2);
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
% Compute the set of constrained basis functions, i.e., admissible
% functions.
%
Bc = dopConstrain( C, B );
%%
% Trucate the basis functions
%
Bc = Bc(:,1:noBfs);
%
%%
% \section{Setup the Sturm-Liouville Matrix Linear Differential Operator}
%
% Setup the Linear differential operator for the Mathieu differential
% equation.
%
c1 = 0;
c2 = -50;
gx = diag(c1 + c2 * cos(2*x)) ;
L = Bc' * (D * D - gx )* Bc;
%
%%
% \section{Solve the Eigenvector Problem}
%
% Solve the eigenvalue problem
%
[Vec, Val] = eig( L );
vals = -diag( Val );
%%
% and sort the solutions.
%
[vals, inds] = sort(vals);
Vec = Vec(:,inds);
%%
% and compute the final eigenfunctions.
%
sols = Bc * Vec;
%%
% \section{Close Pair of Eigenvalues}
%
% The Mathieu differential equation as paramatized here is known to produce
% a close pair of eigenvalues. We now show this pair.
%
noEVals = 2;
for k=1:noEVals
    numStr = num2str(vals(k),'%2.10E') ;
    str = ['\lambda_{', int2str(k-1), '} = ', numStr]
end;
%noV = length(vals);
%n = [1:noV]';
%valsT = n.^2;
%
%%
% \section{Plot a Few Eigenfunctions}
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
fig1 = figure;
plot( x, sols(:,1), 'r');
hold on
plot( x, sols(:,2), 'g');
plot( x, sols(:,3), 'b');
plot( x, sols(:,4), 'k');
grid on;
xlabel('$$x$$');
ylabel('$$y8x)$$');
axis([0,pi,-0.1,0.1]);
%
% \caption{The first $4$ eigen functions of the Mathieu differential equation.}
%%
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
plot( vals(1:noBfs), 'k');
range = axis;
axis([0,noBfs,-1000,900000]);
grid on;
xlabel('Eigenvector number $$n$$');
ylabel('$$\lambda$$');
%
% \caption{The Rayleigh-Ritz Spectrum of the Eigenfunvtions with respect to 
% the admissible functions and the eigenvalues for the Mathieu differential 
% equation.}
%%
% \section{Save the Figure to Disk.}
fileType = 'eps';
printFigure( fig1, ['SLEx2EigFnsNb',int2str(noBfs)], fileType);
printFigure( fig2, ['SLEx2SpectrumNb',int2str(noBfs)], fileType);
