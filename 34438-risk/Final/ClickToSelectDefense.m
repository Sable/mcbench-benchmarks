function ClickToSelectDefense(patch, ~, game, player)

N = numel(game.board);

%% RESET ALL PATCHES TO NEUTRAL
for i = 1:N
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) ~= player
        set(game.board(i).Patch, 'UserData', [occupant(1), 0], ...
                                 'FaceColor', game.cmap(occupant(1), :));
        set(game.board(i).Text, 'Color', [0 0 0]);
    end
end

%% SET CURRRENT PATCH TO DEFENSE
idx = str2double(get(patch, 'Tag'));
occupant = get(game.board(idx).Patch, 'UserData');
set(game.board(idx).Patch, 'UserData', [occupant(1), -1], ...
                           'FaceColor', game.cmap(8,:));
set(game.board(idx).Text, 'Color', game.cmap(7,:));