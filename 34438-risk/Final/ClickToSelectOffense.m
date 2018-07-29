function ClickToSelectOffense(patch, ~, game, player)

N = numel(game.board);

%% RESET ALL PATCHES TO NEUTRAL
for i = 1:N
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) == player
        set(game.board(i).Patch, 'UserData', [player, 0], ...
                                 'FaceColor', game.cmap(player, :));
        set(game.board(i).Text, 'Color', [0 0 0]);
    end
end

%% SET CURRRENT PATCH TO OFFENSE
idx = str2double(get(patch, 'Tag'));
set(game.board(idx).Patch, 'UserData', [player 1], ...
                           'FaceColor', game.cmap(7,:));
set(game.board(idx).Text, 'Color', game.cmap(8,:));