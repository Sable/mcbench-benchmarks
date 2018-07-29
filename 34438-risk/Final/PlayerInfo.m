function PlayerInfo(field, ~, game, mission)

player = find(ismember(game.cmap, get(field, 'BackgroundColor'), 'rows'));

switch get(game.figH, 'selectiontype')
    case 'normal'
        missionbox(mission{game.mission(player)}, game.names{player});
    case 'alt'
        inventory(game, player);
end
