%% Optimizing the operation of a Hydroelectric Dam
%
% This demo maximizes the revenue generated from a hydroelectric dam using
% Quadratic Programming.  We compute the optimal flow rate to the turbine
% as well as the optimal spill flow rate.
%
% This problem is constrained such that:
%
%  1)  0 < Turbine Flow < 25,000 CFS
%  2)  0 < Spill Flow
%  3)  Max change in Turbine and Spill Flow < 500 CFS
%  4)  Combined Turbine and Spill Flow > 1000 CFS
%  5)  50000 < Reservoir Storage < 100000 Acre-Feet
%  6)  The final reservoir level must equal the initial level (90000 AF)
%
% Two solvers are used to solve this problem: FMINCON and QUADPROG
% FMINCON is used first as it takes less time to set-up the problem for 
% ths solver.  Supplying the Gradient and Hessian to the FMINCON algorithm
% significantly speeds up the solution of the problem.  
% QUADPROG ionterior-point-convex is used third to provide a faster 
% algorithm for solving this type of problem.  This solver is also better 
% suited for handling a larger version of the same problem.
%
% Copyright (c) 2012, MathWorks, Inc.

%% 1 - Load data
% Two variables are loaded from data set:
%   inFlow - flow rate into the reservoir measured hourly (CFS)
%   price - price of electricity measured hourly ($/MWh)
load('FlowAndPriceData.mat');

%% 2 - Define Starting Point and Constants
% We wish to find the vector x of optimal decision variables. 
% For this problem:
% x = [turbineFlow(1) ... turbineFlow(N) spillFlow(1) ... spillFlow(N)]

% Our initial starting point is turbineFlow = inFlow and spillFlow = 0
x0 = [inFlow; zeros(size(inFlow))];

stor0 = 90000; % initial vol. of water stored in the reservoir (Acre-Feet)

k1 = 0.00003; % K-factor coefficient
k2 = 9; % K-factor offset

MW2kW = 1000; % MW to kW
C2A = 1.98347/24; % Convert from CFS to AF/HR

C = [C2A k1 k2 MW2kW]; % Vector of constants

N = length(inFlow);

%% 3 - Define Linear Inequality Constraints and Bounds
DefineConstraints;

%% 4 - Objective function
% Use symbolic math for creating the objective function and then convert
% into a MATLAB function that can be evaluated.
%% 4.1 - Derive Objective Function using Symbolic Math
% First define the decision variables as X, which is a vector consisting
% of [TurbineFlow, SpillFlow] and all the parameters as symbolic objects
X = sym('x',[2*N,1]);   % turbine flow and spill flow
F = sym('F',[N,1]);     % flow into the reservoir
P = sym('P',[N,1]);     % price
s0 = sym('s0');         % initial storage
c = sym({'c1','c2','c3','c4'}.','r');   % constants

%%
% Total out flow equation
TotFlow = X(1:N)+X(N+1:end);

%%
% Storage Equations
S = cell(N,1);
S{1} = s0 + c(1)*(F(1)-TotFlow(1));

for ii = 2:N
    S{ii} = S{ii-1} + c(1)*(F(ii)-TotFlow(ii));
end

%%
% K factor equation
k = c(2)*([s0; S(1:end-1)]+ S)/2+c(3);

% MWh equation
MWh = k.*X(1:N)/c(4);

%%
% Revenue equation
R = P.*MWh;

%%
% Total Revenue (Minus sign changes from maximization to minimization)
totR = -sum(R);

%% 4.2 - Create Function File that can be Evaluated in MATLAB
% Create a function that when evaluated returns the value at a point

% Perform substitutions so that X is the only remaining variable 
totR = subs(totR,[c;s0;P;F],[C';stor0;price;inFlow]);

% Generate a MATLAB file from the equation
matlabFunction(totR,'vars',{X},'file','objFcn');

%% 5 - Optimize with FMINCON
options = optimset('MaxFunEvals',Inf,'MaxIter',5000,...
    'Algorithm','interior-point','Display','iter');

tic
[x1, fval1] = fmincon(@objFcn,x0,A,b,Aeq,beq,LB,UB,[],options);
toc

% Visualize Results
plotResults(price, x1, N);

%% 6 - Optimize with FMINCON with supplied Gradient and Hessian
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Let's see if we can speed up the optimization by supplying the gradient
% and Hessian.  Passing these to the algorithm allows it to make more 
% accurate decisions because it no longer has to approximate the gradient
% and hessian (approximation also takes longer as it requires many 
% objective function evaluations).

%% 6.1 - Gradient
% Use the GRADIENT function from Symbolic Math to calculate the gradient
gradObj = gradient(totR,X);

% Create a function that when evaluated returns the gradient at a point
matlabFunction(gradObj,'vars',{X},'file','grad');

% The optimization routine expects two return arguments for a user-supplied
% gradient.  The first argument is the value of the objective function and
% the second argument is the gradient.  The DEAL function is used to return
% multiple output arguments through a function handle.
ValAndGrad = @(x) deal(objFcn(x),grad(x));

%% 6.2 - Hessian
% Use the HESSIAN function from Symbolic Math to calculate the Hessian
hessObj = hessian(totR,X);

% Create a function that when evaluated returns the Hessian at a point
matlabFunction(hessObj,'vars',{X},'file','Hess');

% The Hessian function has two input arguments (the current point and the
% Lagrange Multipliers) and returns the value of the Hessian at the current
% point.
hfcn = @(x,lambda) Hess(x);

%% 6.3 - Optimize
options = optimset('Disp','iter','Algorithm','interior-point',...
                   'MaxFunEvals',500,'MaxIter',5000,...
                   'GradObj','on','Hessian','user-supplied',...
                   'HessFcn',hfcn);

tic
[x2,fval2] = fmincon(ValAndGrad,x0,A,b,Aeq,beq,LB,UB,[],options);
toc

% Visualize Results
plotResults(price, x2, N);

%% 7 - Optimize using the QUADPROG Solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUADPROG minimizes functions of the type (1/2) * x' * H * x  +  f' * x
% First perform some substitutions into the revenue equation
Rsub = subs(R,[c;s0;P;F],[C';stor0;price;inFlow]);

% Total revenue (minus sign to flip maximization to minimization)
Rtot = -sum(Rsub);

%% 7.2 - Calculate and evaluate the linear component
fsym = gradient(Rtot,X);
f = double(subs(fsym,X,zeros(size(X))));

%% 7.1 - Calculate and evaluate the quadratic matrix
H = 0.5.*double(hessian(Rtot,X));

%% 7.3 - Optimize
qpoptions = optimset('Algorithm','interior-point-convex','Disp','iter');

tic
[x3,fval3] = quadprog(H,f,A,b,Aeq,beq,LB,UB,[],qpoptions);
toc

% Visualize Results
plotResults(price, x3, N);