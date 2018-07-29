function score = grade(board, orientation,tiles,boardSize)
% GRADE scores the solution for a given problem for the Vines Contest
%
% board is an r-by-c array of distinct positive integers and zeros.
% orientation is an m-by-1 vector of tile orientations 1-4.
% tiles is and m-by-4 array of tiles.
% boardSize is a 1-by-2 vector that specifies the board size

% The MATLAB Contest Team
% Copyright 2012 The MathWorks, Inc.


numTiles = size(tiles,1);

% Error checking
assert(isequal(size(board), boardSize), 'Solver returned invalid board size.');
assert(isequal(size(orientation), [numTiles, 1]), 'Solver returned invalid orientation vector');
assert(all(orientation == 1 | orientation == 2 | orientation == 3 | orientation == 4), ...
    'Solver returned an orientation vector with invalid orientation(s)');

boardVec = board(:);
boardVec(boardVec == 0) = [];
assert(all(boardVec > 0), 'Solver returned board with negative indices');
assert(all(mod(boardVec,1) == 0), 'Solver returned board with non-integer indices');
assert(all(boardVec) <= numTiles, 'Solver returned board with out of bounds indices');
assert(numel(boardVec) == numel(unique(boardVec)), 'Solver returned board with duplicated tiles');

score = calcTotalPenalty(tiles, board, orientation);
end

function penal=calcTotalPenalty(tiles,board,orientation)
% funtion to caclulate total penalty

[R, C]= size(board);

penalUnused=calcPenaltyUnused(tiles,board);

penalTopRow=0;
penalLefCol=0;
penalAll=0;

for j=1:C
    penalTopRow=penalTopRow+     calcPenaltyPosDir(1,j,1,tiles,board,orientation);
end

for i=1:R
    penalLefCol=penalLefCol+     calcPenaltyPosDir(i,1,4,tiles,board,orientation);
end

for i=1:R
    for j=1:C
        penalAll= penalAll +  calcPenaltyPosDir(i,j,2,tiles,board,orientation);
        penalAll= penalAll +  calcPenaltyPosDir(i,j,3,tiles,board,orientation);
    end
end

penal= penalAll + penalTopRow + penalLefCol + penalUnused ;

end

function Penal =calcPenaltyUnused (tiles, board)
% function to calculate the penalty due to unused tiles floating in sea of
% zeros

placedTiles=board(:);
placedTiles(placedTiles==0)=[];

UnusedTiles=tiles;
UnusedTiles(placedTiles,:)=[];

Penal= sum(sum(UnusedTiles));
end

function penal = calcPenaltyPosDir (x,y,Dir,tiles,board,orientation)
% function that calcualtes the penalty based due to edge in x,y postion and
% facing Dir direction

[R, C]= size(board);

boundryCorrectedA_Pos=zeros(R+2,C+2);
boundryCorrectedA_Pos(2:R+1,2:C+1)=board;
boundryCorrectedA_Pos=boundryCorrectedA_Pos+1;

boundryCorrectedA_Rot=[ 0 ; orientation];
% to take care of boundry Conditions
boundryCorrectedQ=[ 0 0 0 0 ; tiles];

xx=x+1;
yy=y+1;

assert(any(Dir == [1, 2, 3, 4]));
switch Dir
    case 1 % N
        penal=findEdgeValue(xx   ,yy  , 1 , boundryCorrectedQ , boundryCorrectedA_Pos , boundryCorrectedA_Rot) - ...
            findEdgeValue(xx-1 ,yy  , 3 , boundryCorrectedQ,  boundryCorrectedA_Pos , boundryCorrectedA_Rot);
        
    case 2 % E
        penal=findEdgeValue(xx   ,yy  , 2 , boundryCorrectedQ , boundryCorrectedA_Pos , boundryCorrectedA_Rot) - ...
            findEdgeValue(xx   ,yy+1, 4 , boundryCorrectedQ,  boundryCorrectedA_Pos , boundryCorrectedA_Rot);
        
    case 3  % S
        penal=findEdgeValue(xx   ,yy  , 3 , boundryCorrectedQ , boundryCorrectedA_Pos , boundryCorrectedA_Rot) - ...
            findEdgeValue(xx+1 ,yy  , 1 , boundryCorrectedQ,  boundryCorrectedA_Pos , boundryCorrectedA_Rot);
        
    case 4 % W
        penal=findEdgeValue(xx   ,yy  , 4 , boundryCorrectedQ , boundryCorrectedA_Pos , boundryCorrectedA_Rot) - ...
            findEdgeValue(xx   ,yy-1, 2 , boundryCorrectedQ,  boundryCorrectedA_Pos , boundryCorrectedA_Rot);
end

penal=abs(penal);

end

function EdgeValue = findEdgeValue(x,y,Dir,tiles,board,orientation)
% function to fetch the value of edge facing Dir in
% position x,y according to board Matirx, rotated clockwise by a value
% given by orientation.
% Dir = 1N 2E 3S 4W
% orientation= index of north.

tile_idx = board(x,y);

tile_value = tiles(tile_idx,:);

dir_coef= orientation(tile_idx)+ Dir -1;

dir_coef=mod((dir_coef-1),4)+1;

EdgeValue=tile_value(dir_coef);
end