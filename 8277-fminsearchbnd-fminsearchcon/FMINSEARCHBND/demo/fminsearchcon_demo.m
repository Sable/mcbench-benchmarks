%% Optimization of a simple (Rosenbrock) function
rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;

% With no constraints, operation simply passes through
% directly to fminsearch. The solution should be [1 1]
xsol = fminsearchcon(rosen,[3 3])

%% Only lower bound constraints
xsol = fminsearchcon(rosen,[3 3],[2 2])

%% Only upper bound constraints
xsol = fminsearchcon(rosen,[-5 -5],[],[0 0])

%% Dual constraints
xsol = fminsearchcon(rosen,[2.5 2.5],[2 2],[3 3])

%% Mixed constraints
xsol = fminsearchcon(rosen,[0 0],[2 -inf],[inf 3])

%% Fix a variable as constant, x(2) == 3
fminsearchcon(rosen,[3 3],[-inf 3],[inf,3])

%% Linear inequality, x(1) + x(2) <= 1
fminsearchcon(rosen,[0 0],[],[],[1 1],1)

%% Nonlinear inequality, norm(x) <= 1
fminsearchcon(rosen,[0 0],[],[],[],[],@(x) norm(x) - 1)

%% Minimize a linear objective, subject to a nonlinear constraints.
fun = @(x) x*[-2;1];
nonlcon = @(x) [norm(x) - 1;sin(sum(x))];
fminsearchcon(fun,[0 0],[],[],[],[],nonlcon)

%% Provide your own fminsearch options
opts = optimset('fminsearch');
opts.Display = 'iter';
opts.TolX = 1.e-12;
opts.MaxFunEvals = 100;

n = [10,5];
H = randn(n);
H=H'*H;
Quadraticfun = @(x) x*H*x';

% Global minimizer is at [0 0 0 0 0].
% Set all lower bound constraints, all of which will
% be active in this test.
LB = [.5 .5 .5 .5 .5];
xsol = fminsearchcon(Quadraticfun,[1 2 3 4 5],LB,[],[],[],[],opts)

%% Exactly fix one variable, constrain some others, and set a tolerance
opts = optimset('fminsearch');
opts.TolFun = 1.e-12;

LB = [-inf 2 1 -10];
UB = [ inf  inf 1  inf];
xsol = fminsearchcon(@(x) norm(x),[1 3 1 1],LB,UB,[],[],[],opts)

%% All the standard outputs from fminsearch are still returned
[xsol,fval,exitflag,output] = fminsearchcon(@(x) norm(x),[1 3 1 1],LB,UB)

