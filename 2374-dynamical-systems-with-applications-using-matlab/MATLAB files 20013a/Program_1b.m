% Chapter 1 - Linear Discrete Dynamical Systems.
% Program 1b - The Leslie Matrix.
% Copyright Birkhauser 2013. Stephen Lynch.
% Commands are short enough for the Command Window.

% Define a 3x3 Leslie Matrix (Example 4).
L=[0 3 1; 0.3 0 0; 0 0.5 0]

% Set initial conditions.
X0=[1000;2000;3000]

% After 10 years the population distribution will be:
X10=L^10*X0

% Find the eigenvectors and eigenvalues of L (Example 5).
[v,d]=eig(L)

% End of Program 1b.