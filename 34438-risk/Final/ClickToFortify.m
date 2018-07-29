function ClickToFortify(patch, ~, game, troops)
idx = str2double(get(patch, 'Tag'));
N = get(game.board(idx).Text, 'UserData');
trp = get(troops, 'UserData');

%% CHECK IF THERE ARE ALREADY TROOPS ON THE MOVE
if ~trp(1) % No troops on the move -> send
    while true
        n = inputdlg('How many troops do you want to move?','Move',1,{'0'});
        if isempty(n)
            return      %cancel
        end
        n = str2double(n{1});
        if n > N - 1
            uiwait(msgbox('Invalid number of troops'))
        else
            break
        end
    end
    set(troops, 'UserData', [n idx])
    set(game.board(idx).Text, 'String', num2str(N-n), 'UserData', N - n)
    set(game.txtH, 'String', sprintf('You sent %d troops on the move', n))
else                       % Add troops to current patch
    player = get(patch, 'UserData');
    dist = distable(game.board, player(1));
    if isnan(dist(trp(2), idx))
        uiwait(msgbox('This territory cannot be reached'))
        return
    end
    set(troops, 'UserData', 0)
    set(game.board(idx).Text, 'String', num2str(N + trp(1)), 'UserData', N + trp(1));
    set(game.txtH, 'String', 'Select troops to send on the move')
end
