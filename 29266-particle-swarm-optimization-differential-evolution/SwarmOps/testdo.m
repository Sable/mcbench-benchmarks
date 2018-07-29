% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Helper function for TEST script.
function testdo(optimizer, parameters, dim, evals)
    tic;
    disp('ackley');
    [bestX, bestFitness, evaluations] = feval(optimizer, @ackley, ackleydata(dim, evals), parameters)
    disp('griewank');
    [bestX, bestFitness, evaluations] = feval(optimizer, @griewank, griewankdata(dim, evals), parameters)
    disp('quarticnoise');
    [bestX, bestFitness, evaluations] = feval(optimizer, @quarticnoise, quarticnoisedata(dim, evals), parameters)
    disp('rastrigin');
    [bestX, bestFitness, evaluations] = feval(optimizer, @rastrigin, rastrigindata(dim, evals), parameters)
    disp('rosenbrock');
    [bestX, bestFitness, evaluations] = feval(optimizer, @rosenbrock, rosenbrockdata(dim, evals), parameters)
    disp('sphere');
    [bestX, bestFitness, evaluations] = feval(optimizer, @sphere, spheredata(dim, evals), parameters)
    disp('myproblem');
    [bestX, bestFitness, evaluations] = feval(optimizer, @myproblem, myproblemdata(evals), parameters)
    toc
end

% ------------------------------------------------------
