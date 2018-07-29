function [xopt,fopt,niter,gnorm,dx] = stoch_grad_descent(varargin)
% stoch_grad_descent.m demonstrates how the stochastic gradient descent method can be used
% to solve a simple unconstrained optimization problem.In stochastic
% gradient descent, we randomly pick a variable and compute the gradient.
%
% Author: Paras Babu Tiwari, Washington University in Saint Louis;
% http://www.cse.wustl.edu/~tiwarip/
% This program is modification of the gradient descent written by James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 09/24/2013

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
h = get(gca, 'xlabel');
set(h,'FontSize',22);
h = get(gca, 'ylabel');
set(h,'FontSize',22);
h=get(gca,'Title');
set(h,'FontSize',22);
set(gca,'FontSize',15);

% gradient descent algorithm:
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    r = randi([1 2]);
    g = grad(x,r);
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
%saveas(gcf, '~/grad_descent/stoch_fig', 'jpg');
%fid = fopen('~/grad_descent/stoc_output.txt','w');
%fprintf(fid,'x:%f\n',x);
%fprintf(fid,'f:%f \n # of Iterations:%d\n',fopt,niter);
%fclose(fid);

% define the gradient of the objective
function g = grad(x,r)
grd = [2*x(1) + x(2)
    x(1) + 6*x(2)];
g = zeros(size(x,1),1);
g(r) = grd(r);