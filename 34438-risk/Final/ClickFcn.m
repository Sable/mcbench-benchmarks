function ClickFcn(handle, ~, board)

idx = str2double(get(handle, 'Tag'));
msgbox(sprintf('Hello from %s!', board(idx).Name))

