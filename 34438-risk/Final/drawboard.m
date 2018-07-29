function drawboard(board)

for i = 1:numel(board)
    patch(board(i).xy(:,1), board(i).xy(:,2), [0.5 0.5 0.5]);
end

axis image off