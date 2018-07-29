% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Behavioural parameters for Differential Evolution (DE)
% tuned by Pedersen (1). The parameter-array consists of
% the following parameters:
% - Population size (denoted np)
% - Crossover probability (denoted cr)
% - Differential weight (denoted f)
%
% Select the parameters that most closely match the
% characteristics of your optimization problem.
% For example, if you want to optimize a problem where
% the search-space has 15 dimensions and you can perform
% 30000 evaluations, then you could first try using the
% parameters DE_20DIM_40000EVALS. If that does not yield
% satisfactory results then you could try
% DE_10DIM_20000EVALS. If that does not work then you will
% either need to tune the parameters for the problem at
% hand, or you should try using another optimizer.
%
% Literature references:
% (1) M.E.H. Pedersen.
%     Good parameters for Differential Evolution.
%     Technical Report HL1002, Hvass Laboratories, 2010.

% Parameters for non-parallel version:

DE_2DIM_400EVALS_A       = [ 13, 0.7450, 0.9096];
DE_2DIM_400EVALS_B       = [ 10, 0.4862, 1.1922];
DE_2DIM_4000EVALS_A      = [ 24, 0.2515, 0.8905];
DE_2DIM_4000EVALS_B      = [ 20, 0.7455, 0.9362];
DE_5DIM_1000EVALS        = [ 17, 0.7122, 0.6301];
DE_5DIM_10000EVALS       = [ 20, 0.6938, 0.9314];
DE_10DIM_2000EVALS_A     = [ 28, 0.9426, 0.6607];
DE_10DIM_2000EVALS_B     = [ 12, 0.2368, 0.6702];
DE_10DIM_20000EVALS      = [ 18, 0.5026, 0.6714];
DE_20DIM_40000EVALS      = [ 37, 0.9455, 0.6497];
DE_20DIM_400000EVALS     = [ 35, 0.4147, 0.5983];
DE_30DIM_6000EVALS       = [ 11, 0.0877, 0.6419];
DE_30DIM_60000EVALS      = [ 19, 0.1220, 0.4983];
DE_50DIM_100000EVALS     = [ 48, 0.9784, 0.6876];
DE_100DIM_200000EVALS    = [ 46, 0.9565, 0.5824];
DE_HANDTUNED             = [300, 0.9000, 0.5000];
DE_DEFAULT               = DE_10DIM_20000EVALS;

% Parameters for parallel version (above may also work):

DE_PAR_5DIM_10000EVALS   = [ 32, 0.7653, 0.9980];
DE_PAR_30DIM_60000EVALS  = [128, 0.9489, 0.4550];
DE_PAR_DEFAULT           = DE_PAR_5DIM_10000EVALS;

% ------------------------------------------------------
