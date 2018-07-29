% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Behavioural parameters for Particle Swarm Optimization (PSO)
% tuned by Pedersen (1). The parameter-array consists of
% the following parameters:
% - Swarm-size (denoted s)
% - Inertia weight (denoted omega)
% - Particle's best weight (denoted phiP)
% - Swarm's best weight (denoted phiG)
%
% Select the parameters that most closely match the
% characteristics of your optimization problem.
% For example, if you want to optimize a problem where
% the search-space has 25 dimensions and you can perform
% 100000 evaluations, then you could first try using the
% parameters PSO_20DIM_40000EVALS. If that does not yield
% satisfactory results then you could try
% PSO_30DIM_60000EVALS or perhaps PSO_20DIM_400000EVALS_A.
% If that does not work then you will either need to tune
% the parameters for the problem at hand, or you should
% try using another optimizer.
%
% Literature references:
% (1) M.E.H. Pedersen.
%     Good parameters for Particle Swarm Optimization.
%     Technical Report HL1001, Hvass Laboratories, 2010.

% Parameters for non-parallel version:

PSO_2DIM_400EVALS_A       = [ 25,  0.3925,  2.5586, 1.3358];
PSO_2DIM_400EVALS_B       = [ 29, -0.4349, -0.6504, 2.2073];
PSO_2DIM_4000EVALS_A      = [156,  0.4091,  2.1304, 1.0575];
PSO_2DIM_4000EVALS_B      = [237, -0.2887,  0.4862, 2.5067];
PSO_5DIM_1000EVALS_A      = [ 63, -0.3593, -0.7238, 2.0289];
PSO_5DIM_1000EVALS_B      = [ 47, -0.1832,  0.5287, 3.1913];
PSO_5DIM_10000EVALS_A     = [223, -0.3699, -0.1207, 3.3657];
PSO_5DIM_10000EVALS_B     = [203,  0.5069,  2.5524, 1.0056];
PSO_10DIM_2000EVALS_A     = [ 63,  0.6571,  1.6319, 0.6239];
PSO_10DIM_2000EVALS_B     = [204, -0.2134, -0.3344, 2.3259];
PSO_10DIM_20000EVALS      = [ 53, -0.3488, -0.2746, 4.8976];
PSO_20DIM_40000EVALS      = [ 69, -0.4438, -0.2699, 3.3950];
PSO_20DIM_400000EVALS_A   = [149, -0.3236, -0.1136, 3.9789];
PSO_20DIM_400000EVALS_B   = [ 60, -0.4736, -0.9700, 3.7904];
PSO_20DIM_400000EVALS_C   = [256, -0.3499, -0.0513, 4.9087];
PSO_30DIM_60000EVALS      = [134, -0.1618,  1.8903, 2.1225];
PSO_30DIM_600000EVALS     = [ 95, -0.6031, -0.6485, 2.6475];
PSO_50DIM_100000EVALS     = [106, -0.2256, -0.1564, 3.8876];
PSO_100DIM_200000EVALS    = [161, -0.2089, -0.0787, 3.7637];
PSO_HANDTUNED             = [ 50,  0.7290,  1.4945, 1.4945];
PSO_DEFAULT               = PSO_20DIM_400000EVALS_A;

% Parameters for parallel version (above may also work):

PSO_PAR_5DIM_10000EVALS   = [ 72, -0.4031, -0.5631, 3.4277];
PSO_PAR_30DIM_60000EVALS  = [ 64, -0.2063, -2.7449, 2.3198];
PSO_PAR_DEFAULT           = PSO_PAR_5DIM_10000EVALS;

% ------------------------------------------------------
