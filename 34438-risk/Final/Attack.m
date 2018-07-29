function Attack(button, ~, game, player)

%% CHECK IF PLAYER IS ABLE TO ATTACK
able = false;
for i = 1:numel(game.board)
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) == player && get(game.board(i).Text, 'UserData') > 1
        for j = game.board(i).Neighbors
            occupant = get(game.board(j).Patch, 'UserData');
            if occupant(1) ~= player
                able = true;
                break
            end
        end
    end
    if able
        break
    end
end

if ~able
    uiwait(msgbox('You are not in the position to attack anybody.'))
    return
end

%% REPLACE BUTTONS
set(game.txtH, 'String', 'Select territories at war')

button2 = findobj('style', 'pushbutton', 'String', 'Reinforce');
button3 = findobj('style', 'pushbutton', 'String', 'Select');
delete([button, button2, button3]);

test = findobj('style', 'pushbutton', 'String', 'Finish');
if ~isempty(test)% Player attacks for the 2nd+ time
    set(test, 'Visible', 'off')
end


uicontrol('style', 'pushbutton', ... 
          'Parent', game.figH, ...
          'Units', 'normalized', ...
          'Position', [0.46 0.87, 0.08, 0.03], ...
          'String', 'Confirm', ...
          'Callback', {@ReadyForWar, game, player});

N = numel(game.board);


%% SET BUTTONDOWNFCN
for i = 1:N
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) == player
        set(game.board(i).Patch, 'ButtonDownFcn', {@ClickToSelectOffense, game, player})
    else
        set(game.board(i).Patch, 'ButtonDownFcn', {@ClickToSelectDefense, game, player})
    end
end                   

uiwait(game.figH);  %3
uiresume(game.figH); %2
