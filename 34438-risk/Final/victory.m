function result = victory(player, game)

occupiers = contOcc(game);
currentMission = game.mission(player);

if currentMission < 7
    result = eval(sprintf('mission%d(occupiers, player)', currentMission));
else
    result = mission7(occupiers, currentMission - 6);
end