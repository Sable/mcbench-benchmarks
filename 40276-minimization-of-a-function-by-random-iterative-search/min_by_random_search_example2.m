% This M-file demonstates the use of the function  'min_by_random_search'
% type:  help min_by_random_search for more information
%
% In this example the target function is ten-dimensional,
% and has a single minimum.

% set search region
region = [-1000     -1000     -1000      -1000     -1000      -1000     -1000      -1000     -1000      -1000;
                +1000    +1000    +1000     +1000    +1000     +1000    +1000     +1000    +1000     +1000];

% call minimization function
vopt = min_by_random_search( ...
    @min_by_random_search_test_func2, region );

% display optimal solution
vopt
