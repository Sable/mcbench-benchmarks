function FinishFcn(button,~, game)

if get(button, 'UserData') > 0
    for i = 1:numel(game.board)
        occupant = get(game.board(i).Patch, 'UserData');
        set(game.board(i).Patch, 'FaceColor', game.cmap(occupant(1),:));
        set(game.board(i).Text, 'Color', [0 0 0]);
    end
    uiresume(game.figH) %4
else
    msg = msgbox('Attack at least once.');
    uiwait(msg);
end