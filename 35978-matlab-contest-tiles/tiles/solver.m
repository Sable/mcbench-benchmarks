function [board, orientation] = solver(tiles, boardSize)
% SOLVER Sample solver for the MATLAB Tiles Contest

% The MATLAB Contest Team 
% Copyright 2012 The MathWorks, Inc.

board = zeros(boardSize);
board(1:2) = 1:2;
orientation = ones(size(tiles,1), 1);
orientation(1:2) = 1:2;
end