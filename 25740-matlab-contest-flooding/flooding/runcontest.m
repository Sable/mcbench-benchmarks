function [message,results,timeElapsed] = runcontest(drawboard,doBoards)
%RUNCONTEST Test an entry.
%   [MESSAGE,RESULTS,TIME] = RUNCONTEST(DRAWBOARD) runs the M-file
%   solver.m against all the problems defined in testsuite_sample.mat.  The
%   input DRAWBOARD specifies if you want to graphically visualize the results.
%   MESSAGE returns a summary of the testing.  RESULTS measures how well the
%   entry solved the problem, and TIME measures the time the entry took to
%   compute its answer.
%
%   [MESSAGE,RESULTS,TIME] = RUNCONTEST(DRAWBOARD, DOBOARDS) runs the M-file
%   solver.m against the problems enumerated in the vector DOBOARDS
%   as defined in testsuite_sample.mat.  DRAWBOARD is handles as above.

% Argument parsing.
if (nargin < 1)
    drawboard = false;
end

load testsuite_sample testsuite
n = numel(testsuite);
responses = cell(n,1);
scores = zeros(n,1);

if (nargin < 2)
    doBoards = 1:numel(testsuite);
end

% Run the submission for each problem in the suite.
if drawboard == false % no board drawing

    time0 = cputime;
    for k = doBoards
        inputs = struct2cell(testsuite(k));
        responses{k} = solver(inputs{:});
    end
    timeElapsed = cputime-time0;

    for k = doBoards
        inputs = struct2cell(testsuite(k));
        scores(k) = grade(inputs{:},responses{k});
    end

else          % step into each of the responses
    for k = doBoards
        inputs = struct2cell(testsuite(k));
        responses{k} = solver(inputs{:});
        scores(k) = visualize(inputs{:},responses{k});
    end
    timeElapsed = NaN;
end

% Report results.
results = sum(scores);
message = sprintf('results: %.4f\ntime: %.2f',results,timeElapsed);
