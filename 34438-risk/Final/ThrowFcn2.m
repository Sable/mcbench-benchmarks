function ThrowFcn2(~,~, game, res1, N, M, FinishBtn, SelectBtn)

%% GET OFFENDER/DEFENDER DATA
offender = get(game.OffenseTxt, 'UserData');
defender = get(game.DefenseTxt, 'UserData');

Noff = get(game.board(offender).Text, 'UserData');
Ndef = get(game.board(defender).Text, 'UserData');

offOcc = get(game.board(offender).Patch, 'UserData');   
defOcc = get(game.board(defender).Patch, 'UserData'); 

%% SET THROWBUTTON
set(game.ThrowBtnDef, 'Enable', 'off', 'Callback', [])

%% GET NUMBER OF TROOPS TO DEFEND WITH
while true
    N(2) = str2double(inputdlg('Number of defending troops', 'How many troops?', 1, {'1'}));

    if isempty(N(2)) || isnan(N(2))
        continue
    end
    if N(2) > Ndef
        uiwait(msgbox(sprintf('Maximum number of defending troops is %d', Ndef)))
        continue
    end
    if N(2) <= 0 
        uiwait(msgbox('Defend with at least 1 unit'))
        continue
    end
    
    break
end

%% NUMBER OF DICE TO BE USED
M(2) = N(2) * (N(2) <= 2) + 2 * (N(2) > 2);

%% RESULT
res2 = round(rand(1,M(2)) * 5) + 1;
for i = 4 : M(2) + 3
    j = i - 3;
    imshow(sprintf('dice/%d.jpg', res2(j)), 'Parent', game.dice(i));
end
for i = M(2) + 4 : 5 
    imshow('dice/7.jpg', 'Parent', game.dice(i));
end

%% INCREMENT COUNTER
set(FinishBtn, 'UserData', get(FinishBtn, 'UserData') + 1);

%% DETERMINE WINNER
X = sort(res1, 'descend');
Y = sort(res2, 'descend');
res = [X(1:min(M)); Y(1:min(M))];

for i = 1:min(M)
    if res(1,i) > res(2,i) 
        set(game.board(defender).Text, 'String', num2str(Ndef - 1), ...
                                       'UserData', Ndef - 1);
        Ndef = Ndef - 1;
        playerdata = get(game.Players(defOcc(1)), 'UserData');
        playerdata(1) = playerdata(1) - 1;
        set(game.Players(defOcc(1)), 'UserData', playerdata)
        set(game.Players(defOcc(1)), 'String', info(defOcc(1), game))
    else
        set(game.board(offender).Text, 'String', num2str(Noff - 1), ...
                                       'UserData', Noff - 1);
        Noff = Noff - 1;
        playerdata = get(game.Players(offOcc(1)), 'UserData');
        playerdata(1) = playerdata(1) - 1;
        set(game.Players(offOcc(1)), 'UserData', playerdata)
        set(game.Players(offOcc(1)), 'String', info(offOcc(1), game))
    end    
end

if Ndef == 0 % Invasion!
    uiwait(msgbox(sprintf('Victory! You invaded %s!', game.board(defender).Name)))
    
    % Update Board
    set(game.board(offender).Patch, 'UserData', [offOcc(1), 0], ...
                                    'FaceColor', game.cmap(offOcc(1), :))
    set(game.board(defender).Patch, 'UserData', [offOcc(1), 0], ...
                                    'FaceColor', game.cmap(offOcc(1), :))
    set(game.board(offender).Text, 'String', num2str(Noff - N(1)), ...
                                   'Color', [0 0 0], ...
                                   'UserData', Noff - N(1))                                
    set(game.board(defender).Text, 'String', num2str(N(1)), ... 
                                   'UserData', N(1))
    
    % Update Scoreboard
    playerdata = get(game.Players(offOcc(1)), 'UserData');
    playerdata(2) = playerdata(2) + 1;
    set(game.Players(offOcc(1)), 'UserData', playerdata)
    set(game.Players(offOcc(1)), 'String', info(offOcc(1), game))    
    playerdata = get(game.Players(defOcc(1)), 'UserData');
    playerdata(2) = playerdata(2) - 1;
    set(game.Players(defOcc(1)), 'UserData', playerdata)
    set(game.Players(defOcc(1)), 'String', info(defOcc(1), game))     
end

%% RE-ACTIVATE FINISH/SELECT/OFFENSE BUTTON AND RESET TEXT
set(game.ThrowBtnOff, 'Enable', 'on')
set(game.txtH, 'String', 'Offender may throw the dice')
set(FinishBtn, 'Enable', 'on')
set(SelectBtn, 'Enable', 'on')