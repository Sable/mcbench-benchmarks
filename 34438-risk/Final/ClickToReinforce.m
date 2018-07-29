function ClickToReinforce(patch,~, game, player)

%% RETRIEVE NUMBER OF ALLOWED EXTRA TROOPS
n = get(game.txtH, 'UserData');

%% DETERMINE WHETHER TROOPS WERE ALLREADY ADDED TO THIS PATCH
idx = str2double(get(patch, 'Tag'));
str = get(game.board(idx).Text, 'String');
if isempty(find(str == '+', 1))
    original = true;
else
    original = false;
end

%% DETECT LEFT (ADD) OR RIGHT (DOUBLE) CLICK (REMOVE)
if strcmp(get(game.figH, 'selectiontype'), 'normal')
    if n == 0
        return % no more troops allowed to add
    end
    set(game.figH, 'UserData', 'left')
    add = 1;
elseif strcmp(get(game.figH, 'selectiontype'), 'alt')
    if original
        return % can't remove troops from an original patch
    end
    set(game.figH, 'UserData', 'right')
    add = -1;
elseif strcmp(get(game.figH, 'selectiontype'), 'open')
    switch get(game.figH, 'UserData')
        case 'left'
            if n == 0
                return
            else
                add = 1;
            end
        case 'right'
            if original
                return
            else
                add = -1;
            end
    end
else
    return
end

%% NEW INFORMATION
if original
    str = [str, ' + 1'];
else
    first = find(str == ' ', 1, 'first');
    last = find(str == ' ', 1, 'last');
    plus  = str2double(str(last + 1 : end));
    new   = plus + add;
    if new == 0
        str = num2str(str(1 : first - 1));
    else
        str = [str(1:last), num2str(new)];
    end
end   

set(game.board(idx).Text, 'String', str);

str = sprintf('%s, you may add %d troops.', game.names{player}, n - add);
set(game.txtH, 'String', str, 'UserData', n - add); 
    