function UseCards(object, ~, inventory, main)

res = get(0, 'ScreenSize');
%% FIGURE WINDOW
handle = ...
    figure('Name', 'Use Cards', ...
           'Units', 'pixels', ...
           'MenuBar', 'none', ...
           'NumberTitle', 'off', ...
           'Position', [res(3:4)/3, 150, 200]);

%% RADIO BUTTONS 
str = {'3 x Infantry','3 x Cavallery','3 x Artillery','One of each'};
r = zeros(1,4);
for i = 1:4
    r(i) = uicontrol('style', 'radiobutton', ...
                     'Parent', handle, ...
                     'Units', 'normalized', ...
                     'String', str{i}, ...
                     'FontSize', 12, ...
                     'BackgroundColor', get(handle, 'Color'), ...
                     'Position', [0.1, 0.85 - 0.2 * (i-1), 0.8, 0.1], ...
                     'CallBack', @RadioCallback);
end
      
%% USE BUTTON      
uicontrol('style', 'pushbutton', ...
          'Parent', handle, ...
          'Units', 'normalized', ...
          'String', 'Use', ...
          'FontSize', 12, ...
          'FontWeight', 'bold', ...
          'BackgroundColor', get(handle, 'Color'), ...
          'Position', [0.3, 0.06, 0.4, 0.1], ...
          'CallBack', {@UseBtnCallback, inventory, r, object})

uiwait(handle) %10
uiresume(main); %9

function RadioCallback(button, ~)

r = findobj('Parent', get(button, 'Parent'), 'style', 'radiobutton');
for i = find(r ~= button)
    set(r(i), 'Value', 0);
end

function UseBtnCallback(button, ~, inventory, r, object)

for i = 1:4
    if get(r(i),'Value')
        break
    end
end

%% CHECK INVENTORY IF THIS OPTION IS AVAILABLE
N = [sum(inventory == 1), sum(inventory == 2), sum(inventory == 3)];
ok = ( (i < 4) && sum(inventory == i) >= 3 ) || ( (i == 4) && all(N) );

if ~ok
    uiwait(msgbox('You don''t have these cards.'))
    return
end

set(object, 'UserData', i);
uiresume(get(button, 'Parent')) %10
delete(get(button, 'Parent'))




















