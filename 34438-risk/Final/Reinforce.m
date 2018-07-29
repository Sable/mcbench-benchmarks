function Reinforce(~, ~, game, player)

%% REPLACE BUTTONS
button1 = findobj('style', 'pushbutton', 'String', 'Reinforce');
button2 = findobj('style', 'pushbutton', 'String', 'Attack');
delete([button1, button2])

ConfirmBtn = ...
uicontrol('style', 'pushbutton', ... 
          'Parent', game.figH, ...
          'Units', 'normalized', ...
          'Position', [0.46 0.87, 0.08, 0.03], ...
          'String', 'Confirm', ...
          'Callback', {@ConfirmReinforcements, game, player}); %5

N = numel(game.board);

%% CALCULATE NUMBER OF EXTRA TROOPS
list = zeros(1, N);
for i = 1:N
    occupant = get(game.board(i).Patch, 'UserData');
    list(i) = (occupant(1) == player); 
end
n = floor(sum(list)/3);
if n < 3
    n = 3;
end

%% SET BUTTONDWNFCNS
for i = find(list)    
    set(game.board(i).Patch, 'ButtonDownFcn', {@ClickToReinforce, game, player})
end

%% SHOW TEXT
str = sprintf('%s, you may add %d troops.', game.names{player}, n);
set(game.txtH, 'String', str, 'UserData', n);

uiwait(game.figH);  %5

%% CONFIRMED!
delete(ConfirmBtn)
uiresume(game.figH) %2