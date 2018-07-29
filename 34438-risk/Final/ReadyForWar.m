function ReadyForWar(button, ~, game, player)

%% DETERMINE BOTH PARTIES
offender = 0;
defender = 0;

for i = 1:numel(game.board)
    side = get(game.board(i).Patch, 'UserData');
    if side(2) == 1
        offender = i;
    elseif side(2) == -1
        defender = i;
    end
    
    if offender ~= 0 && defender ~= 0
        break;
    end
end

if ~offender || ~defender
    msgbox('Please select both parties.')
    return
end

if isempty(find(defender == game.board(offender).Neighbors, 1))
    msgbox('Please select two adjecent states.')
    return
end

if  get(game.board(offender).Text, 'UserData') < 2
    msgbox('You don''t have sufficient troops to attack')
    return
end

%% BOTH PARTIES SELECTED -> WAR
set(game.txtH, 'String', 'Offender may throw the dice');

delete(button); % delete the confirm button
for i = 1:numel(game.board)
    set(game.board(i).Patch, 'ButtonDownFcn', []) % remove buttondownfcn's
end

SelectBtn = ...
    uicontrol('style', 'pushbutton', ... 
              'Parent', game.figH, ...
              'Units', 'normalized', ...
              'Position', [0.41 0.87, 0.08, 0.03], ...
              'String', 'Select', ...
              'Callback', {@Attack, game, player});
 
test = findobj('style', 'pushbutton', 'String', 'Finish');
if ~isempty(test)   % Finish button already here
    FinishBtn = test;
    set(FinishBtn, 'Visible', 'on');
else
    FinishBtn = uicontrol('style', 'pushbutton', ... 
                          'Parent', game.figH, ...
                          'Units', 'normalized', ...
                          'Position', [0.51 0.87, 0.08, 0.03], ...
                          'String', 'Finish', ...
                          'UserData', 0, ...
                          'Callback', {@FinishFcn, game});
end

set(game.OffenseTxt,  'String', game.board(offender).Name, ...
                      'UserData', offender)
set(game.DefenseTxt,  'String', game.board(defender).Name, ...
                      'UserData', defender)
set(game.ThrowBtnOff, 'Enable', 'on', 'Callback', {@ThrowFcn, game, FinishBtn, SelectBtn})

uiwait(game.figH)       %4


%% RESET BOARD
delete(findobj('style', 'pushbutton', 'String', 'Select'))
delete(findobj('style', 'pushbutton', 'String', 'Finish'))
set(game.OffenseTxt, 'String', 'Offense', 'UserData', 0)
set(game.DefenseTxt, 'String', 'Defense', 'UserData', 0)

uiresume(game.figH) %3