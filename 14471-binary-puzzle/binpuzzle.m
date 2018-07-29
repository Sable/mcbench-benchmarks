function binpuzzle(varargin)
%BINPUZZLE  A Binary Puzzle - Try to light up all of the buttons
%   BINPUZZLE starts the default game (5 buttons)
%   BINPUZZLE(N) starts the game with N buttons,
%       where N is an integer between 3 and 10
%
% To solve the puzzle:
%   You must get all of the buttons to light up (turn white)
%   Click the (gray/white) buttons to try turning them on/off
%     The buttons will only turn on/off in a specific pattern
%       that you will have to discover as you go
%     (Hint: this game is not called Binary Puzzle for nothing)
%
% You will know you are a master of the puzzle when you reach
%   the minimum number of clicks possible at each level:
%       Num Buttons = 3   4   5   6   7    8    9   10
%       Min Clicks  = 5  10  21  42  85  170  341  682
%
% Other Controls:
%   Click the (blue) up/down buttons to increase
%     or decrease the number of buttons in the puzzle
%   Click the (yellow) 'H' to view the help notes
%
% Example:
%     binpuzzle; %creates the puzzle with 5 buttons (default)
%
% Example:
%     binpuzzle(8); %creates the puzzle with 8 buttons
%
% Author: Joseph Kirk
% Email: jdkirk630 at gmail dot com
% Release: 1.1
% Release Date: 5/23/07

% process input
if nargin < 1
    num_buttons = 5;
elseif nargin == 1
    num_buttons = varargin{1};
    if ~isnumeric(num_buttons)
        error('Input must be an integer between 3 and 10');
    else
        num_buttons = max(3, min(10, round(real(num_buttons(1)))));
    end
else
    error('Too many input arguments.');
end

%load high score file
best_score_file = [fileparts(which(mfilename)) filesep 'topScores.mat'];
if exist(best_score_file, 'file')
    load(best_score_file);
else
    best_scores = Inf(8, 2);
end

% create figure window
h.figure = figure('Name', 'Binary Puzzle', ...
    'NumberTitle', 'off', ...
    'Color', 'k', ...
    'Renderer', 'zbuffer', ...
    'MenuBar', 'none', ...
    'CloseRequestFcn', @close_request);

% user data
g = struct('inner_radius', 2, ...
    'outer_radius', 5, ...
    'button_step', 0.1, ...
    'dim_color', [0.25 0.25 0.25], ...
    'lit_color', [1 1 1], ...
    'old_pos', get(h.figure, 'Position'), ...
    'num_buttons', num_buttons, ...
    'button_radius', 0.4, ...
    'up_down_color', [0 0 1], ...
    'first_click_flag', 1, ...
    'num_clicks', Inf, ...
    'time', Inf, ...
    'best_score', best_scores, ...
    'best_score_file', best_score_file, ...
    'sequence', zeros(1, num_buttons));
set(h.figure, 'UserData', g);

% create axes
h.axes = axes(...
    'DataAspectRatio', [1 1 1], ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'XLim', [-6 6], ...
    'YLim', [-6 6], ...
    'NextPlot', 'add', ...
    'Visible', 'off', ...
    'Parent', h.figure);

% up/down button locations
xbutton = [0 0]*g.button_radius;
ybutton = [0.75 -0.75]*g.button_radius;

% create up button
angle = linspace(0.5*pi, 2.5*pi, 4);
x = xbutton(1)+cos(angle)*g.button_radius;
y = ybutton(1)+sin(angle)*g.button_radius;
h.up_button = patch(...
    x, y, g.up_down_color, ...
    'EdgeColor', 'none', ...
    'Parent', h.axes, ...
    'BusyAction', 'cancel', ...
    'Interruptible', 'off');

% create down button
angle = linspace(1.5*pi, 3.5*pi, 4);
x = xbutton(2)+cos(angle)*g.button_radius;
y = ybutton(2)+sin(angle)*g.button_radius;
h.down_button = patch(...
    x, y, g.up_down_color, ...
    'EdgeColor', 'none', ...
    'Parent', h.axes, ...
    'BusyAction', 'cancel', ...
    'Interruptible', 'off');

% create help button
x = -[4 4 4.25 4.25 4.5 4.5 4.75 4.75 4.5 4.5 4.25 4.25];
y = [4.75 4 4 4.25 4.25 4 4 4.75 4.75 4.5 4.5 4.75];
h.help_button = patch(...
    x, y, [1 1 0], ...
    'EdgeColor', 'none', ...
    'Parent', h.axes, ...
    'BusyAction', 'cancel', ...
    'Interruptible', 'off', ...
    'ButtonDownFcn', ['help ', mfilename]);

% create best scores text
h.score = text(...
    'Parent', h.axes, ...
    'Units', 'normalized', ...
    'Position', [0.5 0.05 0], ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'Middle', ...
    'FontSize', 14, ...
    'FontWeight', 'Bold', ...
    'Color', 'r');
set_score(h);

% create buttons
make_buttons(h);


%----- subfunction: make_buttons(...) ---------
function make_buttons(h)
g = get(h.figure, 'UserData');
b_width = 2*pi/g.num_buttons;
o_step = b_width*g.button_step;
i_step = o_step*g.outer_radius/g.inner_radius;
h.button = [];
for button_num = 1:g.num_buttons
    b.button_number = button_num;
    button_angle = (button_num-1)*b_width;
    inner_arc = linspace(button_angle-b_width/2, button_angle+b_width/2-i_step, 20)+i_step/2;
    outer_arc = linspace(button_angle-b_width/2, button_angle+b_width/2-o_step, 40)+o_step/2;
    x = -[g.inner_radius*sin(inner_arc) g.outer_radius*sin(fliplr(outer_arc))];
    y = -[g.inner_radius*cos(inner_arc) g.outer_radius*cos(fliplr(outer_arc))];
    h.button(button_num) = patch(x, y, g.dim_color, ...
        'EdgeColor', 'none', ...
        'Parent', h.axes, ...
        'UserData', b, ...
        'HitTest', 'on', ...
        'BusyAction', 'cancel', ...
        'Interruptible', 'off');
end
for btn = 1:g.num_buttons
    set(h.button(btn), 'ButtonDownFcn', {@button_down, h});
end
set(h.up_button, 'ButtonDownFcn', {@up_button_down, h});
set(h.down_button, 'ButtonDownFcn', {@down_button_down, h});
set(h.figure, 'ResizeFcn', {@resize, h})

%----- subfunction: button_down(...) ---------
function button_down(this_button, eventdata, h)
g = get(h.figure, 'UserData');
b = get(this_button, 'UserData');
% check if this is the first button click
if g.first_click_flag
    g.first_click_flag = 0;
    g.num_clicks = 0;
    tic;
end
% evaluate button selection
num_buttons = g.num_buttons;
sequence = g.sequence;
button = b.button_number;
g.num_clicks = g.num_clicks + 1;
if button == 1
    sequence(button) = ~sequence(button);
    set(this_button, 'FaceColor', 1.25-get(this_button, 'FaceColor'));
else
    sum_preceeding = sum(sequence(1:button-1));
    if sum_preceeding == 1 && sequence(button-1) == 1
        sequence(button) = ~sequence(button);
        set(this_button, 'FaceColor', 1.25-get(this_button, 'FaceColor'));
    end
end
g.sequence = sequence;
set(h.figure, 'UserData', g);
% check if solved
if sum(sequence) == num_buttons
    g.time = ceil(toc*100)/100;
    if g.time == 1, sec_str = ' second'; else sec_str = ' seconds'; end
    msgbox({' Congratulations! You solved the puzzle! ', ' ', [' It took you ' num2str(g.time) ...
        sec_str ' and ' num2str(g.num_clicks) ' clicks! ']}, 'Woohooo!');
    set(h.figure, 'UserData', g);
    set_score(h);
    pause(1);
    g = get(h.figure, 'UserData');
    g.sequence = zeros(1, num_buttons);
    g.first_click_flag = 1;
    g.num_clicks = 0;
    set(h.figure, 'UserData', g);
    delete(h.button);
    make_buttons(h);
end

%----- subfunction: up_button_down(...) ---------
function up_button_down(hfig, eventdata, h)
g = get(h.figure, 'UserData');
g.num_buttons = min(10, g.num_buttons+1);
g.sequence = zeros(1, g.num_buttons);
g.first_click_flag = 1;
g.num_clicks = Inf;
g.time = Inf;
set(h.figure, 'UserData', g);
set_score(h);
delete(h.button);
make_buttons(h);

%----- subfunction: down_button_down(...) ---------
function down_button_down(hfig, eventdata, h)
g = get(h.figure, 'UserData');
g.num_buttons = max(3, g.num_buttons-1);
g.sequence = zeros(1, g.num_buttons);
g.first_click_flag = 1;
g.num_clicks = Inf;
g.time = Inf;
set(h.figure, 'UserData', g);
set_score(h);
delete(h.button);
make_buttons(h);

%----- subfunction: set_score(...) ---------
function set_score(h)
g = get(h.figure, 'UserData');
idx = g.num_buttons-2;
g.best_score(idx, 1) = min(g.time, g.best_score(idx, 1));
g.best_score(idx, 2) = min(g.num_clicks, g.best_score(idx, 2));
best_time = num2str(g.best_score(idx, 1));
best_clicks = num2str(g.best_score(idx, 2));
num_buttons = num2str(g.num_buttons);
set(h.figure, 'UserData', g);
set(h.score, 'String', ['Buttons: ' num_buttons '  |  Fastest Time: ' ...
    best_time '  |  Fewest Clicks: ' best_clicks]);

%----- subfunction: resize(...) ---------
function resize(hfig, eventdata, h)
g = get(hfig, 'UserData');
new_pos = get(hfig, 'Position');
new_font = get(h.score, 'FontSize')*min(new_pos(3:4))/min(g.old_pos(3:4));
set(h.score, 'FontSize', new_font)
g.old_pos = new_pos;
set(hfig, 'UserData', g);

%----- subfunction: close_request(...) ---------
function close_request(hfig, eventdata)
g = get(hfig, 'UserData');
best_scores = g.best_score;
save(g.best_score_file, 'best_scores');
delete(hfig);

