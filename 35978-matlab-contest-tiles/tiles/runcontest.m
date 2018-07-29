function [message,result,solverTime] = runcontest(visualizationMethod,whichBoards)
%RUNCONTEST Test an entry.
%   [MESSAGE,RESULTS,TIME] = RUNCONTEST runs the file solver.m against all
%   the problems defined in testsuite_sample.mat. MESSAGE returns a summary
%   of the testing, RESULTS measures how well the entry solved the problem,
%   and TIME measures the time the entry took to compute the answer.
%
%   RUNCONTEST(VISUALIZATIONMETHOD) graphically visualize the results.
%   VISUALIZATIONMETHOD is an integer specifying how to visualize the
%   results:
% 
%     VISUALIZATIONMETHOD  |        DESCRIPTION
%    ----------------------------------------------------------
%              0           |      No visualization (default)
%              1           |      Intensity proportional to tile values
%              2           |      Intensity proportional to absolute
%                          |           difference between neighboring tiles
%
%   RUNCONTEST(VISUALIZATIONMETHOD, DOBOARDS) runs the file solver.m
%   against the problems enumerated in the vector DOBOARDS as defined in
%   the testsuite.

% The MATLAB Contest Team 
% Copyright 2012 The MathWorks, Inc.

testSuiteFile = 'testsuite_sample.mat';
tests = load(testSuiteFile,'testsuite');

% Argument parsing.
if nargin < 2
    whichBoards = 1:numel(tests.testsuite); % do all boards in test suite
end
if nargin < 1
    visualizationMethod = 0;  % no visualization
end

numBoards = numel(whichBoards);
solverTime = zeros(numBoards,1);
solverScore = zeros(numBoards,1);

if visualizationMethod > 0
    fh = figure('Color', [1 1 1]);
end

for i = 1:numBoards
    tiles = tests.testsuite(whichBoards(i)).tiles;
    rows = tests.testsuite(whichBoards(i)).r;
    cols = tests.testsuite(whichBoards(i)).c;
    boardSize = [rows, cols];
    
    time0 = cputime;
    [board, orientation] = solver(tiles, boardSize);
    solverTime(i) = cputime-time0;
    solverScore(i) = grade(board, orientation,tiles,boardSize);
    
    if visualizationMethod > 0
        visualizetiles(board,orientation,tiles,visualizationMethod)
        if (i < numBoards) && mypause(fh)
            break; % stop
        end
    end
end

% Report results.
result = sum(solverScore);
resultTime = sum(solverTime);
message = sprintf('results: %.2f\ntime: %.2f', result, resultTime);

end

function flag = mypause(fh)
%mypause: provide navigation through puzzle board solutions

flag = false;
h1 = uicontrol('Parent',fh, 'Position',[20, 5, 100, 20], 'String','Next Problem', ...
    'Callback',@(o,e)uiresume(fh));
h2 = uicontrol('Parent',fh, 'Position',[140, 5, 100, 20], 'String','Stop', ...
    'Callback',@(o,e)stop_cb);
uiwait(fh);

% Remove uicontrols when we're done
if ishandle(h1)
    delete(h1);
end
if ishandle(h2)
    flag = ~isempty(get(h2,'UserData')); % stop?
    delete(h2);
end
    function stop_cb
        set(h2,'UserData',1);
        uiresume(fh);
    end
end