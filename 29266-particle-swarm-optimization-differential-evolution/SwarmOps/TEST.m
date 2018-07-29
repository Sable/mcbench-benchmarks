% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% This is a test-script that performs optimization
% with all optimizers on all the benchmark problems.

% Start recording output to text-file.
diary diary.txt

% Print Matlab / Octave version information
ver

% Settings.
dim = 5       % Dimensionality.
evals = 2000  % Max number of fitness evaluations.

% Load all parameters.
lusparameters
deparameters
psoparameters
molparameters
deparameters

disp('Testing PS');
testdo(@ps, [], dim, evals);

disp('Testing LUS');
testdo(@lus, LUS_DEFAULT, dim, evals);

disp('Testing DE');
testdo(@de, DE_DEFAULT, dim, evals);

disp('Testing PSO');
testdo(@pso, PSO_DEFAULT, dim, evals);

disp('Testing MOL');
testdo(@mol, MOL_DEFAULT, dim, evals);


% Setup parallel workers.
matlabpool open 1

disp('Testing DE Parallel');
testdo(@deparallel, DE_DEFAULT, dim, evals);

disp('Testing PSO Parallel');
testdo(@psoparallel, PSO_DEFAULT, dim, evals);

disp('Testing MOL Parallel');
testdo(@molparallel, MOL_DEFAULT, dim, evals);

% Close parallel workers.
matlabpool close

% Stop recording output to text-file.
diary off

% ------------------------------------------------------
