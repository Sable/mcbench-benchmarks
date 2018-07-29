function [message,result,solverTime] = runcontest(flagVisualize,charFlag,whichBoards)
%RUNCONTEST Test an entry.
%   [MESSAGE,RESULTS,TIME] = RUNCONTEST runs the file solver.m against all
%   the problems defined in testsuite_sample.mat. MESSAGE returns a summary
%   of the testing, RESULTS measures how well the entry solved the problem,
%   and TIME measures the time the entry took to compute the answer.
%
%   RUNCONTEST(true) graphically visualize the results.
%
%   RUNCONTEST(true/false, true) displays numbers as their ASCII
%   equivalents
%
%   RUNCONTEST(true/false, true/false, DOBOARDS) runs the file solver.m
%   against the problems enumerated in the vector DOBOARDS as defined in
%   the testsuite.

% Copyright 2011 The MathWorks, Inc.

% The MATLAB Contest Team
% April 2011

testSuiteFile = 'testsuite_sample.mat';
tests = load(testSuiteFile,'testsuite');

% Argument parsing.
if nargin < 3
    whichBoards = 1:numel(tests.testsuite); % do all boards in test suite
end
if nargin < 2
    charFlag = false;  % display numbers as numbers
end
if nargin < 1
    flagVisualize = false;  % no visualization
end

numBoards = numel(whichBoards);
solverTime = zeros(numBoards,1);
solverScore = zeros(numBoards,1);

if flagVisualize
    fh = figure('Color', [1 1 1]);
end

for n = 1:numBoards
    [words, weights, boardSize, penalty] = getboard(tests.testsuite,whichBoards(n));
    
    time0 = cputime;
    board = solver(words, weights, boardSize, penalty);
    solverTime(n) = cputime-time0;
    
    [remainInDictionary, inPuzzle, bogus] = ...
        runSolution(board, boardSize, words, weights);
    
    solverScore(n) = scoresolution(remainInDictionary, bogus, penalty);
    
    % Print a report to the Command Window
    if flagVisualize
        visualizeSolution(board, boardSize, bogus, charFlag, fh);
        fprintf('\n  Puzzle: %d\n  Score: %d\n\n', n, solverScore(n));
        
        fprintf('Unused words remaining in dictionary\n------------------------------------\n');
        printWords(remainInDictionary.words, charFlag);
        
        fprintf('Valid words used in puzzle solution\n-----------------------------------\n');
        printWords(inPuzzle.words, charFlag);
        
        fprintf('Bogus words used in puzzle solution\n-----------------------------------\n');
        printWords(bogus.words, charFlag);
        
        if (n < numBoards) && mypause(fh)
            break; % stop
        end
    end
end

% Report results.
result = sum(solverScore);
resultTime = sum(solverTime);
message = sprintf('results: %.2f\ntime: %.2f', result, resultTime);

end

function printWords(words, charFlag)
%printWords: displays words in cell array to the Command Window

for n = 1:numel(words)
    if charFlag
        fprintf([char(words{n}),'\n']);
    else
        fprintf([num2str(words{n}),'\n']);
    end
end
fprintf('\n');
end

function [remainInDictionary, inPuzzle, bogus] = runSolution(board, boardSize, dictionary, weights)
%runSolution: parses the solution returned by the solver to determine the
% words it contains. Three structures are returned:
%
%  * remainInDictionary.words: words that remain in the dictionary
%  * remainInDictionary.points: points for each unused dictionary word
%  * remainInDictionary.hash: hash value used internally for searching
%
%  * inPuzzle.words: valid dictionary words used in the solution
%  * inPuzzle.points: points for each valid word
%
%  * bogus.words: words in the solution that aren't in the dictionary
%  * bogus.locations: linear indices of all letters in each word

% Initialize outputs
remainInDictionary = struct('words',{dictionary}, 'weights',{weights}, ...
    'hash', {cellfun(@applyHash, dictionary)});
inPuzzle = struct('words',{{}}, 'weights',{[]});
bogus = struct('words',{{}}, 'locations',{{}});

% Find words going across and down. dir = 1 for across, 2 for down.
for dir = 1:2
    for n = 1:boardSize
        % Get the current row / column to process
        if dir == 1
            curLine = board(n,:);
        else
            curLine = board(:,n).';
        end
        
        % Split current line of the board by locations of zeros
        zeroLoc = find(curLine == 0);
        idx1 = [1, zeroLoc+1];
        idx2 = [zeroLoc-1, boardSize];
        
        % Process the words on the current line
        for m = 1:numel(idx1)
            % Get the linear indices that make up the current word
            idxRange = idx1(m):idx2(m);
            idxConst = repmat(n, 1, numel(idxRange));
            if dir == 1
                linearWordIdx = sub2ind([boardSize, boardSize], idxConst, idxRange);
            else
                linearWordIdx = sub2ind([boardSize, boardSize], idxRange, idxConst);
            end
            
            % Current word to process
            curWord = board(linearWordIdx);
            
            if isscalar(curWord)
                % Get the indices of the adjacent squares - above,
                % below, left, and right.
                [r, c] = ind2sub([boardSize, boardSize], linearWordIdx);
                rows = [r-1, r+1, r,   r];
                cols = [c,   c,   c-1, c+1];
                outOfRange = (rows < 1) | (rows > boardSize) | ...
                    (cols < 1) | (cols > boardSize);
                rows(outOfRange) = [];
                cols(outOfRange) = [];
                adjacentIdx = sub2ind([boardSize, boardSize], rows, cols);
                
                % Treat a lone floating letter as invalid both across
                % and down. We assume that the dictionary never
                % contains any single letter words.
                if all(board(adjacentIdx) == 0)
                    bogus = addBogusWord(bogus, curWord, linearWordIdx);
                end
            elseif ~isempty(curWord) % Skip empty words - nothing to process
                % Determine if the word is in the dictionary
                dictionaryLoc = findWord(curWord, remainInDictionary.words, ...
                    remainInDictionary.hash);
                if isempty(dictionaryLoc)
                    % Bogus word - add to bogus word list
                    bogus = addBogusWord(bogus, curWord, linearWordIdx);
                else
                    % Legit word - move to inPuzzle list
                    [remainInDictionary, inPuzzle] = moveValidWord( ...
                        remainInDictionary, inPuzzle, dictionaryLoc);
                end
            end
        end
    end
end
end

function val = applyHash(word)
% applyHash: A rudimentary hashing function to speed up looking for words
% in the dictionary

n = min(5, ceil(numel(word)/2));
m1 = [1e10, 1e9, 1e8, 1e7, 1e6];
m2 = [1e4, 1e3, 1e2, 1e1, 1e0];

val = 1e12*sum(word) + sum(word(1:n).*m1(1:n)) + sum(word(end-n+1:end).*m2(1:n));
end

function idx = findWord(word, dictionary, dictionaryHash)
% findWord: Find word in dictionary using hash table. An empty matrix is
% return if the word does not exist in the dictionary

% Initialize output - assume word won't be found
idx = [];

% Find possible matches
possibleIdx = find(dictionaryHash == applyHash(word));

% Check all possible matches. If none is an actual match, we'll return empty
for n = 1:numel(possibleIdx)
    if isequal(dictionary{possibleIdx(n)},word)
        idx = possibleIdx(n);
        return;
    end
end

end

function bogus = addBogusWord(bogus, newWord, wordLoc)
%addBogusWord: add a word to the list of bogus words

bogus.words{end+1} = newWord;
bogus.locations{end+1} = wordLoc;
end

function [inDictionary, inPuzzle] = moveValidWord(inDictionary, inPuzzle, dictionaryLoc)
%moveValidWord: moves a word from the list of unused dictionary words to
% the list of words used in the puzzle solution

% Add word to list of words in the puzzle solution
inPuzzle.words{end+1} = inDictionary.words{dictionaryLoc};
inPuzzle.weights(end+1) = inDictionary.weights(dictionaryLoc);

% Remove word for list of unused dictionary words
inDictionary.words(dictionaryLoc) = [];
inDictionary.weights(dictionaryLoc) = [];
inDictionary.hash(dictionaryLoc) = [];
end

function score = scoresolution(remainInDictionary, bogus, penalty)
% SCORESOLUTION Calculates the score for the solution.

score = sum(remainInDictionary.weights) + penalty * numel(bogus.words);
end

function  [words, weights, n, penalty] = getboard(testsuite,k)
% GETBOARD Gets the k-th problem from the loaded testsuite

k = round(min(max(1,k),numel(testsuite)));
n = testsuite(k).n;
words = testsuite(k).words;
weights = testsuite(k).weights;
penalty = testsuite(k).penalty;
end

function visualizeSolution(board, boardSize, bogus, charFlag, fh)
% Display the resulting crossword puzzle solution

% Set the figure
figure(fh);
clf(fh);

% Set the axes
ax = axes('Parent',fh, 'Ydir','reverse', 'XLim',[0.5, boardSize+0.5], ...
    'YLim',[0.5, boardSize+0.5], 'Visible', 'off', ...
    'DataAspectRatio',[1, 1, 1], 'DataAspectRatioMode','manual');

% Draw the grid
for n = 0.5:boardSize+0.5
    line([n, n], [0.5, boardSize+0.5], 'Parent',ax, 'Color',[0, 0, 0]);
    line([0.5, boardSize+0.5], [n, n], 'Parent',ax, 'Color',[0, 0, 0]);
end

% Mark bogus word squares in red
for n = 1:numel(bogus.locations)
    for m = 1:numel(bogus.locations{n})
        [y, x] = ind2sub([boardSize, boardSize], bogus.locations{n}(m));
        patch([x-0.5, x+0.5, x+0.5, x-0.5],[y-0.5, y-0.5, y+0.5, y+0.5], [-1, -1, -1, -1], ...
            'Parent',ax, 'FaceColor',[1, 0, 0]);
    end
end

% Fill in each square - either a letter or black if unused
idx = 0;
for n = 1:boardSize
    for m = 1:boardSize
        if board(n,m) == 0
        patch([m-0.5, m+0.5, m+0.5, m-0.5],[n-0.5, n-0.5, n+0.5, n+0.5], [0, 0, 0, 0], ...
            'Parent',ax, 'FaceColor',[0, 0, 0]);
        else
            if charFlag
                letter = char(board(n,m));
            else
                letter = num2str(board(n,m));
            end
            
            idx = idx + 1;
            letterSize(idx) = 0.75/(boardSize*ceil(numel(letter)/2)); %#ok<AGROW>
            tx(idx) = text(m, n, letter, 'Parent',ax, 'FontUnits','normalized', ...
                'FontSize',letterSize(idx), 'VerticalAlignment','middle', ...
                'HorizontalAlignment','center', 'Clipping','on'); %#ok<AGROW>
        end
    end
end

% Set up zoom callback to resize text objects
h = zoom(fh);
set(h,'ActionPostCallback',@(o,e)zoomcb);

    function zoomcb
        zoom_ratio = boardSize / diff(get(ax,'XLim'));
        set(tx,{'FontSize'},num2cell(letterSize*zoom_ratio).');
    end
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