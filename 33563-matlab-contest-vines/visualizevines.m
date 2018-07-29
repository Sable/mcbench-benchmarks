function visualizevines(moves, vine, board)
% VISUALIZEVINES Draws the board and the vine
%
% USAGE:
%     VISUALIZEVINES(MOVES,VINE,BOARD)

% The MATLAB Contest Team 
% Copyright 2011 The MathWorks, Inc.

imagesc(board)
colormap(copper);
colorbar
axis off
axis equal

if ~isempty(vine)
    
    [r,c] =ind2sub(size(board),vine);

    h = line(c,r);
    set(h,'linewidth',5);

    hRoot = line(c(end),r(end),'marker','.');
    set(hRoot,'markerSize',50);

end


numMoves = size(moves,1);

if numMoves == 0
    return
end

offsetIncrement = 1/(numMoves * 2);
offset = -(offsetIncrement*numMoves)/2;
for i = 1: numMoves
    
    [rS,cS] = ind2sub(size(board), moves(i,1));
    [rE,cE] = ind2sub(size(board), moves(i,2));
    
    flagHorizontal = (rS == rE);
    flagVertical   = (cS == cE);
    
    cOffset = flagVertical   * ((i * offsetIncrement)+offset);
    rOffset = flagHorizontal * ((i * offsetIncrement)+offset);
    
    hArrow(i) = line([cS, cE]+cOffset,[rS, rE]+rOffset, 'color','r');
    hTip(i)   = line(cS+cOffset, rS+rOffset, 'marker', '.', 'markerSize', 25,'color','r');
end
