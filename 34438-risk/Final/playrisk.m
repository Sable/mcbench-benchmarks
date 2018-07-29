function playrisk(varargin)

%% LOAD BOARD
if nargin == 0 && ~exist('board.mat', 'file')
    error('No board-file found')
elseif nargin == 0
    board = load('board.mat');
    board = board.board;
else
    board = varargin{1};
end

%% TEST BOARD (FIELDS, CONNECTIONS, CONTINENTS)
if ~isfield(board, 'Name') || ~isfield(board, 'Continent') || ... 
   ~isfield(board, 'Neighbors') || ~isfield(board, 'xy') || ...
   ~isfield(board, 'TextPos') || ~isfield(board, 'lines')
    error('board should contain the fields: ''Name'', ''Continent'', ''Neighbors'', ''xy'', ''TextPos'' and ''lines''.')
end
dist = distableAll(board);
if nnz(isnan(dist)) > 0
    error('Board is not fully connected');
end
continents = {'Asia', ...
              'North-America', ...
              'Europe', ...
              'Africa', ...
              'Australia', ...
              'South-America'};
for i = 1:numel(board)
    if ~ismember(board(i).Continent, continents)
        error('Unknown continent(s)')
    end
end

%% GAME STRUCTURE
game = struct('board', board);

%% COLORSCHEME
game.cmap =  [238   0   0;...          %red
                0 139   0;...          %green
                0  50 180;...          %blue 
              255 215   0;...          %yellow
              255 140	0;...          %orange
              150  48 255;...          %purple
                0   0   0;...          %black
              255 255 255]/255;        %white

game.colors = {'Red', 'Green', 'Blue', 'Yellow', 'Orange', 'Purple'};

%% GET PLAYERDATA
[N, names] = PlayerData(game.colors);
game.names = names;
startTroops = 40 - 5 * (N - 2);

%% SETUP FIGURE
desktopRes = get(0, 'ScreenSize');

close(findobj('Name', 'RISK'));

game.figH = ...
       figure('Name', 'RISK', ...
              'Position', 0.9 * desktopRes, ...
              'MenuBar', 'none', ...
              'Color', [230 230 230]/255,...
              'NumberTitle', 'off');

game.axH = ...
         axes('Parent', game.figH, ...
              'Position', [0.2, 0.25, .6, .6], ...
              'Color', [156	243	255]/255,...
              'Box', 'on', ...
              'XTick', [], ...
              'YTick', [], ...
              'XTickLabel', [], ...
              'YTickLabel', []);


%% MISSIONS
mission = cell(12,1);
mission{1} = 'Capture Europe, South-America and one other continent';
mission{2} = 'Capture Europe, Australia and one other continent';
mission{3} = 'Capture North-America and Africa';
mission{4} = 'Capture North-America and Australia';
mission{5} = 'Capture Asia and Africa';
mission{6} = 'Capture 24 territories.';
for i = 7:12
    mission{i} = sprintf('Destroy all %s armies!', game.colors{i - 6});
end

game.mission = zeros(1, N);
missionNum = 1:N+6;
for i = 1:N
    while true
        pick = round(rand(1) * (numel(missionNum) - 1)) + 1;
        if missionNum(pick) ~= 6 + i % Avoid the suicide mission (e.g. Red: Kill Red)
            break
        end
    end
    game.mission(i) = missionNum(pick);
    missionNum(pick) = [];
end

%% PLAYER INFORMATION
for i = 1:N
    j = i * (i < 4) + (i - 3) * (i > 3);
    pos = [0.05 * (i < 4) + 0.85 * (i > 3),...
           0.7 - (j - 1) * 0.15, ...
           .1, .11];
       
    game.Players(i) = uicontrol('style', 'edit', ...
                                'Max', 2, ...
                                'Parent', game.figH, ...
                                'enable', 'inactive', ...
                                'Units', 'normalized', ...
                                'BackgroundColor', game.cmap(i,:), ...
                                'Position', pos, ...
                                'UserData', [0, 0, zeros(1,5)], ...
                                'String', ' ');
end         
         
%% DISTRIBUTE TERRITORIES
n = numel(game.board);
advantage = shuffle(1:N, 10);   % some players may have the advantage of an additional territory
occupant = zeros(1, n);
for i = 1:n-mod(n,N)
    occupant(i) = ceil(i / floor(n/N));
end
occupant = [nonzeros(occupant)', advantage(1:mod(n,N))];
occupant = shuffle(occupant, 300);
for i = 1:N                     % set playerdata (n_Troops, n_Territories, card1, ..., card5)
    ud = get(game.Players(i), 'UserData');
    ud(1:2) = sum(occupant == i) * ones(1,2);
    set(game.Players(i), 'UserData', ud);
    set(game.Players(i), 'String', info(i, game));
end

%% DRAW LINES (IF AVAILABLE)
L = game.board(1).lines;
for i = 1:size(L, 1)
    line(L(i, 1:2), L(i, 3:4), 'LineStyle', ':', 'Color', 'k')
end


%% CREATE PATCH OBJECTS
for i = 1:numel(board)
    game.board(i).Patch = patch(game.board(i).xy(:,1),...
                                game.board(i).xy(:,2),...
                                game.cmap(occupant(i),:));

    game.board(i).Text  =  text(game.board(i).TextPos(1), ...
                                game.board(i).TextPos(2), ...
                                '1');
    
    set(game.board(i).Patch, 'Parent', game.axH, ...
                             'Tag', num2str(i), ...
                             'UserData', [occupant(i), 0]); % 0 for neutral, 1 for offense, -1 for defense
    set(game.board(i).Text,  'HitTest', 'off', ...
                             'UserData', 1, ...
                             'HorizontalAlignment', 'center', ...
                             'VerticalAlignment', 'middle');
end


%% CONTINENT INFORMATION
ContValue = [7, 5, 5, 3, 2, 2];

str  = {['Asia - ', num2str(ContValue(1))]; ...
        ['North America - ', num2str(ContValue(2))]; ...
        ['Europe - ', num2str(ContValue(3))]; ...
        ['Africa - ', num2str(ContValue(4))]; ...
        ['Australia - ', num2str(ContValue(5))]; ...
        ['South America - ', num2str(ContValue(6))]};
    
uicontrol('style', 'text', ...
          'Max', 7, ...
          'Parent', game.figH, ...
          'enable', 'inactive', ...
          'Units', 'normalized', ...
          'BackgroundColor', get(game.figH, 'Color'), ...
          'Position', [0.43, 0.09, .14, .132], ...
          'String', str);

%% DICE
game.OffenseTxt = uicontrol('style', 'text', ...
                            'FontSize', 14, ...
                            'String', 'Offense', ...
                            'Units', 'normalized', ...
                            'Position', [0.2, 0.15, 0.23, 0.05], ...
                            'HorizontalAlignment', 'left', ...
                            'UserData', 0, ...
                            'BackgroundColor', get(game.figH, 'Color'));

game.DefenseTxt = uicontrol('style', 'text', ...
                            'FontSize', 14, ...
                            'String', 'Defense', ...
                            'Units', 'normalized', ...
                            'Position', [0.57, 0.15, 0.23, 0.05], ...
                            'HorizontalAlignment', 'right', ...
                            'UserData', 0, ...
                            'BackgroundColor', get(game.figH, 'Color'));

game.dice = zeros(1, 5);

for i = 1:3 %offence
    game.dice(i) = axes('Parent', game.figH, ...
                        'Position', [0.225 + (i-1) * 0.051, 0.1, 0.05, 0.05]);

    imshow(sprintf('dice/%d.jpg', i), 'Parent', game.dice(i))
end

for i = 4:5 %defense
    game.dice(i) = axes('Parent', game.figH, ...
                        'Position', [0.495 + (i-1) * 0.051, 0.1, 0.05, 0.05]);

    imshow(sprintf('dice/%d.jpg', i), 'Parent', game.dice(i))
end

%% THROW BUTTONS
game.ThrowBtnOff = uicontrol('style', 'pushbutton', ...
                             'Parent', game.figH, ...
                             'Units', 'normalized', ...
                             'Position', [0.25, 0.05, .1, .03], ...
                             'Enable', 'off', ...
                             'String', 'Throw');

game.ThrowBtnDef = uicontrol('style', 'pushbutton', ...
                             'Parent', game.figH, ...
                             'Units', 'normalized', ...
                             'Position', [0.65, 0.05, .1, .03], ...
                             'Enable', 'off', ...
                             'String', 'Throw');
                         
                         
%% START BUTTON
StartBtn = uicontrol('style', 'pushbutton', ...
                     'Parent', game.figH, ...
                     'Units', 'normalized', ...
                     'Position', [0.475, 0.9, .05, .03], ...
                     'Callback', @(s,~) uiresume(get(s,'Parent')), ...
                     'FontWeight', 'Bold', ...
                     'String', 'START');

%% SHUFFLE THE DECK
game.deck = shuffle([1 * ones(1, 14), ...       % Infantry
                     2 * ones(1, 14), ...       % Cavallery
                     3 * ones(1, 14)], ...      % Artillery
                     100); 

%% NUMBER OF REINFORCEMENTS
ReinfFunc = @(n) (n < 6)  * 4 + (n-1) * 2 + ...     % 2, 4, 6, 8, 10, 12
                 (n == 6) * 15 + ...                % 15
                 (n > 6)  * (n - 3) * 5;            % 20, 25, ...

%% WAIT FOR THE START BUTTON TO BE PUSHED
uiwait(game.figH)
if isempty(findobj('Name', 'RISK'))
    return
end
delete(StartBtn)
game.txtH = ...
       uicontrol('style', 'text', ...
                 'Units', 'normalized', ...
                 'Position', [0.2, 0.9, 0.6, 0.05], ...
                 'BackgroundColor', get(game.figH, 'Color'), ...
                 'FontSize', 14);

             
%% PLACE TROOPS

ConfirmBtn = uicontrol('style', 'pushbutton', ... 
                       'Parent', game.figH, ...
                       'Units', 'normalized', ...
                       'Position', [0.46 0.87, 0.08, 0.03], ...
                       'String', 'Confirm');

for i = 1:N
    set(ConfirmBtn, 'Callback', {@ConfirmReinforcements, game, i});
    toAdd = startTroops - sum(occupant == i);
    set(game.txtH, 'String', sprintf('%s, you may add %d troops.', names{i}, toAdd), ...
                   'UserData', toAdd)
    set(game.Players(i), 'ButtonDownFcn', {@PlayerInfo, game, mission})
    uiwait(missionbox(mission(game.mission(i)), names{i}));
    for j = find(occupant == i)
        set(game.board(j).Patch, 'ButtonDownFcn', {@ClickToReinforce, game, i})
    end
    uiwait(game.figH)   %1    
    set(game.Players(i), 'ButtonDownFcn', [])
end

set(ConfirmBtn, 'Visible', 'off')

%% THE GAME
turn = 1;
inTheGame = 1:N;
ReinfCount = 0;
while true
    %% TEST FOR END OF GAME
    if ~find(turn == inTheGame)
        continue                    % Player was eliminated
    elseif victory(turn, game)
        break                       % Player has completed his mission
    end   
    
    %% SET PLAYERINFO BUTTONDOWN
    set(game.Players(turn), 'ButtonDownFcn', {@PlayerInfo, game, mission})
    
    %% SET TITLE AND WAIT FOR PLAYER TO BEGIN
    str = sprintf('It''s %s''s turn.', game.names{turn});
    set(game.txtH, 'String', str);
    
    OK = uicontrol('style', 'pushbutton', ...
                   'Parent', game.figH, ...
                   'Units', 'normalized', ...
                   'Position', [0.47 0.87, 0.06, 0.03], ...
                   'String', 'OK', ...
                   'Callback', @(~,~) uiresume(game.figH));
    uiwait(game.figH)
    delete(OK)
    
    %% REINFORCEMENTS (CARDS)
    playerdata = get(game.Players(turn), 'UserData');
    inventory = playerdata(3:7);
    beforeOccupied = playerdata(2);
    
    if nnz(inventory) < 5
        set(game.txtH, 'String', 'Do you want to use your cards?');
        YesBtn = ...
                    uicontrol('style', 'pushbutton', ...
                              'Parent', game.figH, ...
                              'Units', 'normalized', ... 
                              'Position', [0.44, 0.87, 0.05, 0.03], ...
                              'String', 'Yes', ...
                              'Callback', {@UseCards, inventory, game.figH});

        NoBtn = ...
                    uicontrol('style', 'pushbutton', ...
                              'Parent', game.figH, ...
                              'Units', 'normalized', ... 
                              'Position', [0.51, 0.87, 0.05, 0.03], ...
                              'String', 'No', ...
                              'Callback', @(~,~) uiresume(game.figH)); %9

        uiwait(game.figH) %9                 
        cards = get(YesBtn, 'UserData');
        delete([YesBtn, NoBtn])
    else
        set(game.txtH, 'String', 'Your inventory is full! Pick a set to use.');
        while true
            UseCards(game.txtH, 0, inventory,game.figH);
            cards = get(game.txtH, 'UserData');
            if ~isempty(cards)
                break
            end
        end
    end
    
    NumReinf = 0;
    if ~isempty(cards) 
        %Calculate number of troops and remove cards from inventory
        ReinfCount = ReinfCount + 1;
        NumReinf = ReinfFunc(ReinfCount);
        if cards ~= 4
            pos = find(inventory == cards, 3);
        else
            pos = zeros(1, 3);
            for i = 1:3
                pos(i) = find(inventory == i, 1);
            end
        end
        inventory(pos) = 0;
        playerdata(3:7) = inventory;
        set(game.Players(turn), 'UserData', playerdata)
    end
    
    %% REINFORCEMENTS (CONTINENTS)
    occupiers = contOcc(game);
    for i = 1:6
        NumReinf = NumReinf + ContValue(i) * all(occupiers{i} == turn); 
    end
    
    if NumReinf > 0
        str = sprintf('%s, you may add %d troops', game.names{turn}, NumReinf);
        set(game.txtH, 'String', str, ...
                       'UserData', NumReinf);
        for i = 1:numel(game.board)
            occupant = get(game.board(i).Patch, 'UserData');
            if occupant(1) == turn
                set(game.board(i).Patch, 'ButtonDownFcn', {@ClickToReinforce, game, turn})
            end
        end
        set(ConfirmBtn, 'Visible', 'on')
        set(ConfirmBtn, 'Callback', {@ConfirmReinforcements, game, turn})
        uiwait(game.figH) %1
        set(ConfirmBtn, 'Visible', 'off')
    end
    
    %% REINFORCE / ATTACK
    set(game.txtH, 'String', 'Determine your tactic') 
    
    % Reinforce Button
    uicontrol('style', 'pushbutton', ...
              'Parent', game.figH, ...
              'Units', 'normalized', ...
              'Position', [0.41 0.87, 0.08, 0.03], ...
              'String', 'Reinforce', ...
              'Callback', {@Reinforce, game, turn});

    % Attack Button
    uicontrol('style', 'pushbutton', ...
              'Parent', game.figH, ...
              'Units', 'normalized', ...
              'Position', [0.51 0.87, 0.08, 0.03], ...
              'String', 'Attack', ...
              'Callback', {@Attack, game, turn});
    
    uiwait(game.figH);  %2
    
    playerdata = get(game.Players(turn), 'UserData');
    afterOccupied = playerdata(2);
    
    %% ADD A CARD TO THE INVENTORY
    if afterOccupied > beforeOccupied
        spot = find(playerdata == 0, 1);
        playerdata(spot) = game.deck(1);    
        game.deck(1) = [];
        if isempty(game.deck)       %% SHUFFLE USED CARDS
            count = zeros(1,3);
            for i = 1:N
                ud = get(game.Players(i), 'UserData');
                count = count + [sum(ud(3:7) == 1), ...
                                 sum(ud(3:7) == 2), ...
                                 sum(ud(3:7) == 3)];
            end
            game.deck = shuffle([1 * ones(1, 14 - count(1)), ...       % Infantry
                                 2 * ones(1, 14 - count(2)), ...       % Cavallery
                                 3 * ones(1, 14 - count(3))], ...      % Artillery
                                 200); 
        end
        set(game.Players(turn), 'UserData', playerdata);
        uiwait(msgbox('A card was added to your inventory'));
    end
    
    set(game.txtH, 'String', 'Do you want to fortify your positions?')

    %% FORTIFICATION
    
    % YES button
    uicontrol('style', 'pushbutton', ...
              'Parent', game.figH, ...
              'Units', 'normalized', ... 
              'Position', [0.44, 0.87, 0.05, 0.03], ...
              'String', 'Yes', ...
              'Callback', {@Fortify, game, turn});
          
    % NO button
    uicontrol('style', 'pushbutton', ...
              'Parent', game.figH, ...
              'Units', 'normalized', ... 
              'Position', [0.51, 0.87, 0.05, 0.03], ...
              'String', 'No', ...
              'Callback', @(~,~) uiresume(game.figH)); %6

    uiwait(game.figH) %6
    
    delete(findobj('style', 'pushbutton', 'String', 'Yes'))
    delete(findobj('style', 'pushbutton', 'String', 'No'))
    
    %% CHECK IF A PLAYER WAS ELIMINATED
    alive = zeros(1, numel(inTheGame));
    for i = 1:N
        ud = get(game.Players(i), 'UserData');
        alive(i) = ud(2) > 0;
    end
    inTheGame = inTheGame(logical(alive));
    
    
    %% TEST FOR END OF GAME
    if ~find(turn == inTheGame)
        continue                    % Player was eliminated
    elseif victory(turn, game)
        break                       % Player has completed his mission
    end  
    
    %% PREPARE FOR NEXT TURN
    set(game.Players(turn), 'ButtonDownFcn', [])
    turn = mod(turn + 1, N) + N * (mod(turn + 1, N) == 0);
end
%% GAME OVER
uiwait(msgbox(sprintf('Game Over, %s won!', game.names{turn})))
close('RISK')