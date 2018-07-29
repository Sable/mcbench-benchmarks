function MoveBtn(button, ~, game, patch, Buffer)

Nmove = get(button, 'UserData');
new = get(Buffer, 'UserData') + Nmove;

set(Buffer, 'UserData', new)

idx = str2double(get(patch, 'Tag'));
N = get(game.board(idx).Text, 'UserData');
set(game.board(idx).Text, 'String', num2str(N - Nmove), ...
                          'UserData', N - Nmove);
                      
delete(get(button, 'Parent')) %8