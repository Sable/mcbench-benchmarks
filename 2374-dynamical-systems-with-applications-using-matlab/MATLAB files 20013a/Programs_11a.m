% Chapter 11 - Hamiltonian Systems, Lyapunov Functions, and Stability.
% Programs_11a - Surface and Contour Plots. Finding Vdot.
% Copyright Birkhauser 2013. Stephen Lynch.

% The double-well potential (Fig. 11.5(b)).
% Symbolic Math toolbox required.
ezsurfc('-x^2/2+x^4/4+y^2/2',[-1.5,1.5]);

% Calculating Vdot (Exercise 6).
clear
syms x y V
V=(1-4*x^2-y^2)^2;
xdot=-y*(1+x)/2+x*(1-4*x^2-y^2);
ydot=2*x*(1+x)+y*(1-4*x^2-y^2);
Vdot=factor(diff(V,x)*xdot+diff(V,y)*ydot)

% Phase portraits may be plotted using the M-files in Chapter 8.
% End of Programs_11a.
