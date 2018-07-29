function [boardToScore, areasVector, flagHitGoal]  = runSolutionVector(solutionVector, board, goal, flagVisualize)
 
numInColorMap = unique(board);
boardToScore = [];
flagHitGoal  = 0;
highestBoardValue = max(board(:));
areasVector = zeros(numel(solutionVector), 1);
 
if flagVisualize
    displayBoard(board, goal, numInColorMap)
end
 
boardPath = zeros(size(board));

for i = 1:numel(solutionVector)+1 %run through all solutionVector then the goal color to see if we hit goal
    
    if i <= numel(solutionVector)
        colorToPaint = solutionVector(i);
    else
        colorToPaint = board(goal);
    end
    prePaintedBoard = board;
    [areasVector(i,1), flagHitGoal, board, boardPath] = runOnePaint(board, colorToPaint, goal, boardPath);
    
    if flagHitGoal && isempty(boardToScore)
        boardToScore = prePaintedBoard;
    end
    
    if flagVisualize &&  i <= numel(solutionVector);
        displayBoard(board, goal, numInColorMap)
    end
end
 
if ~flagHitGoal %did not hit goal? all non-walls become most expensive paint
    boardToScore     =  board;
    vi               = (board > 0); %non-walls
    boardToScore(vi) = highestBoardValue;
end
 
areasVector(end) = []; %remove final areasToPaint from the check at end to see if hit goal
 
function [areaPainted, flagHitGoal, board, boardPath] = runOnePaint(board, colorToPaint, goal, boardPath)
 
[vi, boardPath] = flood(board, boardPath);
areaPainted = numel(vi);
board(vi)   = colorToPaint;
 
% ismember(10,[1 2 10])
% ans =  1
%
% ismember(10,[1 2 11])
% ans =  0
 
flagHitGoal = ismember(goal, vi);
 
function [vi, boardPath] = flood(board, boardPath)
%vi  is the list of indices that are 4 connected to first element of the
%matrix by the same color.
 
% Code created here:
%http://blogs.mathworks.com/videos/2009/06/17/puzzler-find-four-connected-c
%omponent-to-element-1-of-2-d-matrix/#comments
[sizeBoardEdgeR, sizeBoardEdgeC] = size(board);
 
oldColor = board(1,1);
updated=1;
while updated==1
    updated=0;
    for row=1:sizeBoardEdgeR
        for col=1:sizeBoardEdgeC
            if row==1 && col==1 && boardPath(row,col)==0  ...
                    || board(row,col)== oldColor && row>1              && boardPath(row-1,col  )~=0 && boardPath(row,col)==0 ...
                    || board(row,col)== oldColor && col>1              && boardPath(row  ,col-1)~=0 && boardPath(row,col)==0 ...
                    || board(row,col)== oldColor && col<sizeBoardEdgeC && boardPath(row  ,col+1)~=0 && boardPath(row,col)==0 ...
                    || board(row,col)== oldColor && row<sizeBoardEdgeR && boardPath(row+1,col  )~=0 && boardPath(row,col)==0;
                
                boardPath(row,col) = 1;
                updated=1;
                
            end
        end
    end
end
 
vi = find(boardPath==1);
 
function [score, boardScore, paintPenalty, timePenalty] = ...
    scoreEntry(solutionVector, boardToScore, areasVector, timeToSolve)
 
boardScore = sum(boardToScore(:));
 
% paintPenalty = areasVector' * solutionVector; %pay for paint
paintPenalty = sum(solutionVector);
 
timeScalar = 1;
timePenalty = timeToSolve * timeScalar;
 
score = boardScore + paintPenalty + timePenalty;
 
function displayBoard(board, goal, numInColorMap)

upperNums = numInColorMap > board(goal);
lowerNums = numInColorMap < board(goal);

cMapUpper =    hot(nnz(upperNums));
cMapLower = winter(nnz(lowerNums));
cMapGoal  = [0.7 0.7 0.7];

for i = 1:numel(numInColorMap); 
    labels{i} = num2str(numInColorMap(i)); 
end

flagWallExists = numInColorMap(1) == 0; %there is a wall
if flagWallExists
    cMapWall = [0 0 0];
    cMapLower(1,:) = [];
    labels{1} = 'wall';
else
    cMapWall = [];
end

cMap = [cMapWall; cMapLower; cMapGoal; cMapUpper];

clf
image(board+flagWallExists) %walls are zero must be brought to 1
axis equal off
colormap(cMap)
line(1,1,'marker','o', 'markersize', 10)
[gy, gx] = ind2sub(size(board),goal);
line(gx, gy, 'marker', 'x', 'markersize', 10)
colorbar('ytick', 1:numel(numInColorMap), 'ytickLabel',labels)
msg = 'Press Enter to continue or Ctrl-C to stop.';
fprintf(msg);
pause
fprintf(repmat(char(8),size(msg)))

% %%%%%%%%%%%%
% goalValue = board(goal);
%     cmap = zeros(1+numColors,3);
%     cmap(2:goalValue,:) = winter(goalValue-1);
%     cmap(goalValue+1,:) = [1 1 1];
%     cmap(goalValue+2:numColors+1,:) = autumn(numColors-goalValue);
%     colormap(cmap)
%     %colormap([0 0 0; jet(numColors)]);
%     axis off
%     for i = 1:numColors
%         labels{i} = num2str(i);
%     end
%     
%     colorbar('ytickLabel',['wall', labels])
%     axis equal

