function [xopt,fopt,niter,gnorm,dx] = grad_descent(varargin)
% grad_descent.m demonstrates how the gradient descent method can be used
% to solve a simple unconstrained optimization problem. Taking large step
% sizes can lead to algorithm instability. The variable alpha below
% specifies the fixed step size. Increasing alpha above 0.32 results in
% instability of the algorithm. An alternative approach would involve a
% variable step size determined through line search.
%
% This example was used originally for an optimization demonstration in ME
% 149, Engineering System Design Optimization, a graduate course taught at
% Tufts University in the Mechanical Engineering Department. A
% corresponding video is available at:
% 
% http://www.youtube.com/watch?v=cY1YGQQbrpQ
%
% Author: James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 3/4/12

if nargin==0
    % define starting point
    x0 = [3 3]';
elseif nargin==1
    % if a single input argument is provided, it is a user-defined starting
    % point.
    x0 = varargin{1};
else
    error('Incorrect number of input arguments.')
end

% termination tolerance
tol = 1e-6;

% maximum number of allowed iterations
maxiter = 1000;

% minimum allowed perturbation
dxmin = 1e-6;

% step size ( 0.33 causes instability, 0.2 quite accurate)
alpha = 0.1;

% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf; x = x0; niter = 0; dx = inf;

% define the objective function:
f = @(x1,x2) x1.^2 + x1.*x2 + 3*x2.^2;

% plot objective function contours for visualization:
figure(1); clf; ezcontour(f,[-5 5 -5 5]); axis equal; hold on

% redefine objective function syntax for use with optimization:
f2 = @(x) f(x(1),x(2));

% gradient descent algorithm:
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = grad(x);
    gnorm = norm(g);
    % take step:
    xnew = x - alpha*g;
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end
    % plot current point
    plot([x(1) xnew(1)],[x(2) xnew(2)],'ko-')
    refresh
    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    x = xnew;
    
end
xopt = x;
fopt = f2(xopt);
niter = niter - 1;

% define the gradient of the objective
function g = grad(x)
g = [2*x(1) + x(2)
    x(1) + 6*x(2)];