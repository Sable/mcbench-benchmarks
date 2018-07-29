% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Behavioural parameters for Many Optimizing Liaisons (MOL)
% tuned by Pedersen (1). The parameter-array consists of
% the following parameters:
% - Swarm-size (denoted s)
% - Inertia weight (denoted omega)
% - Swarm's best weight (denoted phiG)
%
% Select the parameters that most closely match the
% characteristics of your optimization problem.
% For example, if you want to optimize a problem where
% the search-space has 7 dimensions and you can perform
% 5000 evaluations, then you could first try using the
% parameters MOL_5DIM_10000EVALS. If that does not yield
% satisfactory results then you could try
% MOL_10DIM_2000EVALS or perhaps MOL_10DIM_20000EVALS.
% If that does not work then you will either need to tune
% the parameters for the problem at hand, or you should
% try using another optimizer.
%
% Literature references:
% (1) M.E.H. Pedersen.
%     Good parameters for Particle Swarm Optimization.
%     Technical Report HL1001, Hvass Laboratories, 2010.

% Parameters for non-parallel version:

MOL_2DIM_400EVALS_A       = [ 23, -0.3328, 2.8446];
MOL_2DIM_400EVALS_B       = [ 50,  0.2840, 1.9466];
MOL_2DIM_4000EVALS_A      = [183, -0.2797, 3.0539];
MOL_2DIM_4000EVALS_B      = [139,  0.6372, 1.0949];
MOL_5DIM_1000EVALS        = [ 50, -0.3085, 2.0273];
MOL_5DIM_10000EVALS       = [ 96, -0.3675, 4.1710];
MOL_10DIM_2000EVALS       = [ 60, -0.2700, 2.9708];
MOL_10DIM_20000EVALS      = [116, -0.3518, 3.8304];
MOL_20DIM_40000EVALS      = [228, -0.3747, 4.2373];
MOL_20DIM_400000EVALS_A   = [125, -0.2575, 4.6713];
MOL_20DIM_400000EVALS_B   = [125, -0.2575, 4.6713];
MOL_30DIM_6000EVALS       = [ 67, -0.4882, 2.7923];
MOL_30DIM_60000EVALS      = [198, -0.2723, 3.8283];
MOL_30DIM_600000EVALS     = [134, -0.4300, 3.0469];
MOL_50DIM_100000EVALS     = [290, -0.3067, 3.6223];
MOL_100DIM_200000EVALS    = [219, -0.1685, 3.9162];
MOL_DEFAULT               = MOL_30DIM_60000EVALS;

% Parameters for parallel version (above may also work):

MOL_PAR_5DIM_10000EVALS   = [ 32, -0.3319, 5.9100];
MOL_PAR_30DIM_60000EVALS  = [164, -0.4241, 2.7729];
MOL_PAR_DEFAULT           = MOL_PAR_5DIM_10000EVALS;

% ------------------------------------------------------
