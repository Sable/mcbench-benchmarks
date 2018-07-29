function ThrowFcn(~, ~, game, FinishBtn, SelectBtn)

%% GET OFFENDER/DEFENDER DATA
offender = get(game.OffenseTxt, 'UserData');
defender = get(game.DefenseTxt, 'UserData');

offOcc = get(game.board(offender).Patch, 'UserData');   
defOcc = get(game.board(defender).Patch, 'UserData');   % Defending state may already have been occupied in this turn

%% CHECK WHETHER DICE WERE THROWN AT THE APPROPRIATE MOMENT
if offOcc(1) == defOcc(1)   % same occupant
    msg = msgbox('You already invaded this state');
    uiwait(msg)
    return
end

%% NUMBER OF TROOPS
Noff = get(game.board(offender).Text, 'UserData');

%% GET NUMBER OF TROOPS THE OFFENDER WANTS TO SEND
while true
    N = str2double(inputdlg('Number of offending troops', 'How many troops?', 1, {'1'}));

    if isempty(N) || isnan(N)
        return
    end
    if N > Noff - 1
        uiwait(msgbox(sprintf('Maximum number of offending troops is %d', Noff - 1)))
        continue
    end
    if N <= 0
        uiwait(msgbox('Send at least 1 unit into battle'))
        continue
    end
    
    break
end

%% NO FINISH / RESELECT DURING BATTLE
set(FinishBtn, 'Enable', 'inactive')
set(SelectBtn, 'Enable', 'inactive')

%% NUMBER OF DICE TO BE USED
M(1) = N * (N <= 3) + 3 * (N > 3);

%% RESULT
res1 = round(rand(1,M(1)) * 5) + 1;
for i = 1:M(1)
    imshow(sprintf('dice/%d.jpg', res1(i)), 'Parent', game.dice(i));
end
for i = M(1) + 1 : 3
    imshow('dice/7.jpg', 'Parent', game.dice(i));
end

%% UNSET OFFENSE THROWBUTTON, SET DEFENSE
set(game.ThrowBtnOff, 'Enable', 'off')
set(game.ThrowBtnDef, 'Enable', 'on', 'Callback', {@ThrowFcn2, game, res1, N, M, FinishBtn, SelectBtn});
set(game.txtH, 'String', 'Defender may throw the dice')
