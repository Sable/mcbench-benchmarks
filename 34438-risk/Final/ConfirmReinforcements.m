function ConfirmReinforcements(~,~, game, player)

if get(game.txtH, 'UserData') ~= 0
    uiwait(msgbox('Please use all troops'))
    return
end

total = 0;
for i = 1:numel(game.board)
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) == player
        set(game.board(i).Patch, 'ButtonDownFcn', [])
        newN = eval(get(game.board(i).Text, 'String'));
        set(game.board(i).Text, 'UserData', newN, ...
                                'String', num2str(newN));
        total = total + newN;
    end
end

scoreboard = get(game.Players(player), 'UserData');
scoreboard(1) = total;
set(game.Players(player), 'UserData', scoreboard)    
set(game.Players(player), 'String', info(player, game)) 

uiresume(game.figH)     %1

          