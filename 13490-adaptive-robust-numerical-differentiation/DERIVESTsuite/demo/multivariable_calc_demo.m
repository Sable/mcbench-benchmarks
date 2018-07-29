% Multivariate calculus demo script

% This script file is designed to be used in cell mode
% from the matlab editor, or best of all, use the publish
% to HTML feature from the matlab editor. Older versions
% of matlab can copy and paste entire blocks of code into
% the Matlab command window.

% Typical usage of the gradient and Hessian might be in
% optimization problems, where one might compare an analytically
% derived gradient for correctness, or use the Hessian matrix
% to compute confidence interval estimates on parameters in a
% maximum likelihood estimation.

%% Gradient of the Rosenbrock function at [1,1], the global minimizer
rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
% The gradient should be zero (within floating point noise)
[grad,err] = gradest(rosen,[1 1])

%% The Hessian matrix at the minimizer should be positive definite
H = hessian(rosen,[1 1])
% The eigenvalues of h should be positive
eig(H)

%% Gradient estimation using gradest - a function of 5 variables
[grad,err] = gradest(@(x) sum(x.^2),[1 2 3 4 5])

%% Simple Hessian matrix of a problem with 3 independent variables
[H,err] = hessian(@(x) x(1) + x(2)^2 + x(3)^3,[1 2 3])

%% A semi-definite Hessian matrix
H = hessian(@(xy) cos(xy(1) - xy(2)),[0 0])
% one of these eigenvalues will be zero (approximately)
eig(H)

%% Directional derivative of the Rosenbrock function at the solution
% This should be zero. Ok, its a trivial test case.
[dd,err] = directionaldiff(rosen,[1 1],[1 2])

%% Directional derivative at other locations
[dd,err] = directionaldiff(rosen,[2 3],[1 -1])

% We can test this example
v = [1 -1];
v = v/norm(v);
g = gradest(rosen,[2 3]);

% The directional derivative will be the dot product of the gradient with
% the (unit normalized) vector. So this difference will be (approx) zero.
dot(g,v) - dd

%% Jacobian matrix of a scalar function is just the gradient
[jac,err] = jacobianest(rosen,[2 3])

grad = gradest(rosen,[2 3])

%% Jacobian matrix of a linear system will reduce to the design matrix
A = rand(5,3);
b = rand(5,1);
fun = @(x) (A*x-b);

x = rand(3,1);
[jac,err] = jacobianest(fun,x)

disp 'This should be essentially zero at any location x'
jac - A

%% The jacobian matrix of a nonlinear transformation of variables
% evaluated at some arbitrary location [-2, -3]
fun = @(xy) [xy(1).^2, cos(xy(1) - xy(2))];
[jac,err] = jacobianest(fun,[-2 -3])


