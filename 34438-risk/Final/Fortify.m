function Fortify(YesBtn,~, game, player)

set(game.txtH, 'String', 'Select troops to send on the move')

%% DELETE BUTTONS
NoBtn = findobj('style', 'pushbutton', 'String', 'No');
delete([YesBtn, NoBtn]);

%% TROOP BUFFER
troops = uicontrol('style', 'text', ...
                   'Parent', game.figH, ...
                   'Visible', 'off', ... 
                   'Position', [1 1 1 1], ...
                   'UserData', 0);      

%% SET BUTTONDOWNFCN
for i = 1:numel(game.board)
    occupant = get(game.board(i).Patch, 'UserData');
    if occupant(1) == player
        set(game.board(i).Patch, 'ButtonDownFcn', {@ClickToFortify, game, troops})
    end
end

%% FINISH BUTTON
FinishBtn = uicontrol('style', 'pushbutton', ...
                      'Parent', game.figH, ...
                      'Units', 'normalized', ... 
                      'Position', [0.46, 0.87, 0.08, 0.03], ...
                      'String', 'Finish', ...
                      'Callback', {@FinishFortify, troops});

uiwait(game.figH)
delete(FinishBtn)
delete(troops)
