function AddBtn(button, ~, game, patch, Buffer)

Nadd = get(button, 'UserData');
new = get(Buffer, 'UserData') - Nadd;

set(Buffer, 'UserData', new)

idx = str2double(get(patch, 'Tag'));
N = get(game.board(idx).Text, 'UserData');
set(game.board(idx).Text, 'String', num2str(N + Nadd), ...
                          'UserData', N + Nadd);
                      
delete(get(button, 'Parent')) %8