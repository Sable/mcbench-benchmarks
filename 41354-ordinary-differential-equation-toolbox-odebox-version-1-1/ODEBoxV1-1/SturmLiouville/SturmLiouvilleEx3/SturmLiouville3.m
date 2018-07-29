%% 
% \documentclass[12pt]{article}
%
% \title{ODEbox: A Toolbox for Ordinary Differential Equations\\
% Sturm Liouville Example 3\\
% The Truncated Hydrogen Differential Equation}
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
% This example addresses the solution of the truncated hydrogen
% differential equation, a Sturm-Liouville equation. This is a boundary
% value problem with an LNP singular condition at $y(0)$. A series of
% eigenvalues are known for this problem, they will be used here to
% evaluate the quality of the eigenvalues computed numerically.
% %
% \begin{equation}
%    -\ddot{y} + 
%       \left\{
%           \frac{2}{x^2}
%         - \frac{1}{x}
%       \right\}
%       = \lambda \, y
%    \hspace{5mm}
%    \text{with}
%    \hspace{5mm}
%    y(0) = LNP
%   \hspace{5mm}
%   \text{and} 
%   \hspace{5mm}
%   y(1000) = 0
% \end{equation}
% %
% in the closed interval $0 \leq x \leq 1000$.
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
noBfs = round(noPts/2);
%%
% Compute the Chebyshev points, but scaled to form a open interval
% $0 < x < 1000$.
%
x = dopNodes( noPts, 'cheby' );
xMax = 1000;
x = xMax * (x + 1)/2;
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
% Define the constraints, in this example only one constraint.
%
C = zeros( noPts, 1 );
C(end,end) = 1;
%%
% Compute the set of constrained basis functions, i.e., admissible
% functions.
%
Bc = dopConstrain( C, B );
%%
% Truncate the constrained basis functions to avoide aliasing
%
Bc = Bc(:,1:noBfs);
%%
% \section{Setup the Sturm-Liouville Matrix Linear Differential Operator}
%
% Setup the Linear differential operator for the differential
% equation.
%
Gx = diag((1./x).*(2./x - 1) ) ;
L = Bc' * (-D * D + Gx)* Bc;
%
%%
% \section{Solve the Eigenvector Problem}
%
% Solve the eigenvalue problem
%
[Vec, Val] = eig( L );
vals = diag( Val );
%%
% and sort the eigenvalues
%
[vals, inds] = sort(vals);
Vec = Vec(:,inds);
%%
%
% Compute the eigenfunctions
%
sols = Bc * Vec;
%%
% \section{Known Eigenvalues}
%
% Some of the eigenvalues are known for this differential equation~\cite{Pryce1999,Amodio2011}
%
L0Known = -6.250000000000E-2;
L9Known = -2.066115702478E-3;
L17Known = -2.5757359232E-4;
L18Known =  2.873901310E-5;
%%
% Display the relative error in the numerically computed eigenvalues with
% respect to the known eigenvalues.
%
disp( ['L_',int2str(0),' = ',num2str(vals(1),'%1.10E'),' ',num2str(L0Known,'%1.10E'),' ',num2str((L0Known - vals(1))/L0Known,'%1.10E') ] );
disp( ['L_',int2str(9),' = ',num2str(vals(10),'%1.10E'),' ',num2str(L9Known,'%1.10E'),' ',num2str((L9Known - vals(10))/L9Known,'%1.10E') ] );
disp( ['L_',int2str(17),' = ',num2str(vals(18),'%1.10E'),' ',num2str(L17Known,'%1.10E'),' ',num2str((L17Known - vals(18))/L17Known,'%1.10E') ] );
disp( ['L_',int2str(18),' = ',num2str(vals(19),'%1.10E'),' ',num2str(L18Known,'%1.10E'),' ',num2str((L18Known - vals(19))/L18Known,'%1.10E') ] );

%%
% \section{Plot the Results}
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
fig1 = figure;
P1 = [0.18 0.1 0.8 0.17];
A1 = axes( 'position', P1, 'color', 'w'  );
plot( x, sols(:,1), 'k');
grid on;
xlabel('$$ x $$');
ylabel('$$y(x)_{0}$$');
axis([0,xMax,-0.01,0.2]);
hold on;
%
P2 = [0.18 0.33 0.8 0.17];
A2 = axes( 'position', P2, 'color', 'w'  );
plot( x, sols(:,10), 'k');
grid on;
ylabel('$$y(x)_{9}$$');
hold on;
%
P3 = [0.18 0.56 0.8 0.17];
A3 = axes( 'position', P3, 'color', 'w'  );
plot( x, sols(:,18), 'k');
grid on;
ylabel('$$y(x)_{17}$$');
hold on;
%
P4 = [0.18 0.79 0.8 0.17];
A4 = axes( 'position', P4, 'color', 'w' );
plot( x, sols(:,19), 'k');
grid on;
grid on;
ylabel('$$ y(x) $$');
ylabel('$$y(x)_{18}$$');
hold on;
%
% \caption{The eigenfunctions corresponding to the $4$ known eigenvalues.}
%%
%
fig2 = figure;
P1 = [0.16 0.4 0.8 0.55] ;
A = axes('position',P1);
imagesc( log10(abs(Vec) ));
colorbar;
ylabel(['Basis function number $$m$$, $$n_b = ',int2str(noBfs),'$$']);
P2 = [0.16 0.1 0.615 0.25] ;
A = axes('position',P2);
plot(vals , 'k');
range = axis;
axis([0,noBfs,0,5]);
grid on;
xlabel('Eigenvector number $$n$$');
ylabel('$$\%$$ rel. error in $$\lambda$$');
%
% \caption{The Rayleigh-Ritz spectrum of the eigenfunctions with respect 
% to the admissible functions.}
%%
%\section{Write the Figures to Disk}
%
fileType = 'eps';
printFigure( fig1, ['SLEx5EigFnsNb',int2str(noBfs)], fileType);
printFigure( fig2, ['SLEx5SpectrumNb',int2str(noBfs)], fileType);
%%% Define the Bibliography
%
% \bibliographystyle{plain}
% \bibliography{biblio}

