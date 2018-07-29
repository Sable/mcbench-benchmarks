function occupiers = contOcc(game)

continents = {'Asia', ...
              'North-America', ...
              'Europe', ...
              'Africa', ...
              'Australia', ...
              'South-America'};
          
occupiers = cell(1, 6);
occupiers{1} = zeros(1,12); %ASIA
occupiers{2} = zeros(1,9);  %NA
occupiers{3} = zeros(1,7);  %EUR
occupiers{4} = zeros(1,6);  %AFR
occupiers{5} = zeros(1,4);  %AUS
occupiers{6} = zeros(1,4);  %SA

for i = 1:numel(game.board)
    cont = ismember(continents, game.board(i).Continent);
    idx = find(occupiers{cont} == 0, 1);
    occupant = get(game.board(i).Patch, 'UserData');
    occupiers{cont}(idx) = occupant(1);
end