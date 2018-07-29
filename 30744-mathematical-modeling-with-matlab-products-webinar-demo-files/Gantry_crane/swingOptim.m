%% Generating Swing-Free Maneuvers for Simple Gantry Crane System
% In this demo, we use optimization to find optimal bang-coast-bang
% acceleration basis functions. Acceleration function is calculated to
% minimize swing of payload. Dynamic equations used are for a simplified
% Gantry Crane System and are derived using MuPAD.

% Copyright 2011 The MathWorks, Inc.

%% Cart Acceleration Profile
% The following shows the accleration profile of the crane cart. The goal
% is to find the optimal values for tp1, tp2, and tf.
%
% <<bcbProfile.png>>

%% Set Initial Values
% With a particular set of initial values, we get the following behavior.

r       = 10;  % height of crane
ptotal  = 50;  % payload displacement
tp1_org = 3;   % length of first pulse
tp2_org = 3;   % length of second pulse
tf_org  = 20;  % total length of time

sol = solveCraneODE([tp1_org, tp2_org, tf_org]', ptotal, r);
plotResult(sol);

%% Animate

figure;
animateCrane(sol)

%% Setup and Run the Optimization
% To run the following optimization, you need Optimization Toolbox.
%
% We define the following constraints:
%
% * tpf >= tp1 + tp2
% * 1 <= tp1 <= 20
% * 1 <= tp2 <= 20
% * 4 <= tpf <= 25

A = [1, 1, -1];
b = 0;
x0 = [tp1_org, tp2_org, tf_org]';
lb = [1, 1, 4];
ub = [20, 20, 25];

options = optimset;
options = optimset(options,'Display' ,'iter');
options = optimset(options, 'Algorithm', 'interior-point');

x = fmincon(@(x) swingCalc(x, ptotal, r), x0, A, b, ...
   [], [], lb, ub, [], options)

%%  Display Output from Optimization

solOptim = solveCraneODE(x, ptotal, r);
plotResult(solOptim);

%% Animate

animateCrane(solOptim)

%% Run with Multiple Starting Points
% This problem contains multiple solutions that are acceptable. So we want
% to make sure that we haven't missed other (better) solutions. One way to
% do that is to solve the optimization problem with different initial
% conditions. With Global Optimization Toolbox, you can use the
% "MultiStart" solve to automate this process.

if matlabpool('size') == 0               % for parallel
    matlabpool open 4                    % for parallel
end                                      % for parallel

opts = optimset;
opts = optimset(opts, 'Algorithm', 'interior-point');
problem = createOptimProblem('fmincon','objective',...
    @(x) swingCalc(x, ptotal, r), ...
    'x0', x, 'Aineq', A, 'bineq', b, ...
    'lb', lb, 'ub', ub, 'options', opts);

 % 8 different initial conditions
 pts = [...
    1  1  20;
    10 10 25;
    2  20 25;
    20 2  25;
    10 2  20;
    2  10 20;
    1  1  10;
    5  5  11];
start_pts = CustomStartPointSet(pts);
ms = MultiStart('UseParallel', 'always', 'Display' ,'iter');  % for parallel
[xMS, ~, ~, ~, allSol]  = run(ms, problem, start_pts);

matlabpool close                          % for parallel

%% Find Top 3 Possible Solutions and Plot
% Notice three very different solutions that resulted from different
% initial guesses.

totalSol = [allSol.X]; totalSol = totalSol(:,1:3);
solMS = solveCraneODE(totalSol, ptotal, r);
plotResult(solMS)

%% Animate Top Solution

animateCrane(solMS(1))
