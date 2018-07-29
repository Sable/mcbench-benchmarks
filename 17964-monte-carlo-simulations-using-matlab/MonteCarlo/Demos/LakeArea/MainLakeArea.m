%% First Test With Standard uniform law

close all;
rand('seed',0);
TestPolyGon('Standard');

%% Now try with Halton

rand('seed',0);
TestPolyGon('Halton');

%% Finally with Halton

rand('seed',0);
TestPolyGon('Sobol');