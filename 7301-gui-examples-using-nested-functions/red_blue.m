function red_blue
%% Beginning of outer function red_blue
% Create figure
f = figure;
% Create a patch object to show which color is selected
swatch = patch([0 40 40 0], [0 0 40 40], 'r');
% Create a pushbutton to make the patch red
red = uicontrol(f, 'String', 'red', 'Callback', @red_button_press, ...
    'Units', 'pixels', 'Position', [20 5 60 20]);
% Create a pushbutton to make the patch blue
blue = uicontrol(f, 'String', 'blue', 'Callback', @blue_button_press, ...
    'Units', 'pixels', 'Position', [100 5 60 20]);
%% Beginning of nested callback function for 'red' button
    function red_button_press(h, eventdata)
        % Note that I haven't defined the variable 'red' here
        % The callback can see the variable defined in the function
        % in which it is nested and use it from there
        set(red, 'Enable', 'off');
        % The same holds for the variables 'blue' and 'swatch'
        set(blue, 'Enable', 'on');
        set(swatch, 'FaceColor', 'r');
        % If a file contains a nested function, all functions in that file
        % must end with the word 'end'
    end
%% Beginning of nested callback function for 'blue' button
    function blue_button_press(h, eventdata)
        % This behaves the same way as red_button_press
        set(red, 'Enable', 'on');
        % The same holds for the variables 'blue' and 'swatch'
        set(blue, 'Enable', 'off');
        set(swatch, 'FaceColor', 'b');
    end
%% Back in the function red_blue, let's 'press' the blue button
blue_button_press
% Now to end the main function ... we need to use 'end' to do so
% again because the file contains nested functions
end