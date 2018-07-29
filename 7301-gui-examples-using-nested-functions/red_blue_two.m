function red_blue_two
% RED_BLUE_TWO Example GUI demonstrating using nested functions
%
% This example GUI makes extensive use of nested functions to avoid passing
% structures of handles to GUI objects and data between functions. Each
% nested function has access to the handles of the GUI objects, which are
% created in the main function, and therefore no handles or data need be
% explicitly passed or retrieved in the callback functions for the buttons
% in the GUI.
%
% The variables created in the main GUI and their contents are:
% f1 = the handle to main GUI figure
% red = the handle to the 'red' button on the main GUI
% blue = the handle to the 'blue' button on the main GUI
% new = the handle to the 'new' button on the main GUI
% This button will open and close the subGUI
% swatch = the patch whose color is changed by the red and blue buttons
% f2 = the handle to the subGUI figure
% This handle is mainly used to close the subGUI

%% Beginning of code for function red_blue_two
% Create a new figure for the GUI
f1 = figure('CloseRequestFcn', @closefirstfigure);
% Create the 'red' pushbutton
red = uicontrol(f1,'String','red','callback',@red_button_press,...
    'Position',[20 5 60 20]);
% Create the 'blue' pushbutton
blue = uicontrol(f1,'String','blue','callback',@blue_button_press,...
    'Position',[100 5 60 20]);
% Create the 'new' pushbutton that will create the new GUI
new = uicontrol(f1,'String','new','callback',@new_button_press,...
    'Position',[180 5 60 20]);
% Create the patch that will change color based on the button pressed
swatch = patch([0 40 40 0],[0 0 40 40],'r');
% Create a variable to store the handle of the new GUI figure
% f2 becomes non-empty when the new figure is created.
f2 = [];
% Now, press the blue button to start things off
blue_button_press

%% A helper nested function, button_press, will change the swatch color
    function button_press(b1,b2,color)
        % If the secondary GUI is not open
        if isempty(f2)
            % Disable one of the buttons and enable another
            % The handles to the buttons are the first two input arguments
            set(b1,'Enable','off');
            set(b2,'Enable','on');
        end
        % Now set the swatch color to the one specified in the third input
        set(swatch,'FaceColor',color);
    end
% End of helper nested function button_press

%% Define the two button callbacks in terms of the helper function

%% Red button's callback
    function red_button_press(h,dummy)
        % Disable the 'red' button and enable 'blue', then turn swatch red
        button_press(red,blue,'r');
    end

%% Blue button's callback
    function blue_button_press(h,dummy)
        % Disable the 'red' button and enable 'blue', then turn swatch red
        button_press(blue,red,'b');
    end

%% New button's callback
    function new_button_press(h,dummy)
        % If we don't have a new figure up already ...
        if isempty(f2)
            % Create a new figure with no menubar or 'Figure #' in its
            % title bar and with name 'New figure'
            f2 = figure('MenuBar', 'none', 'Name', 'New figure', ...
                'NumberTitle', 'off');
            % Get the original figure's position
            P = get(f1,'Position');
            % Move the new figure whose handle is in f2 to a position below
            % and to the right of the original figure whose handle is in f1
            % Also when this new figure is closed, the subfunction
            % cancel_f2 will run
            set(f2,'Position',[P(1)+P(3),P(2)-50,240,50],...
                'CloseRequestFcn',@cancel_f2);
            % Create a new pushbutton with callback qqq_button_press that
            % will turn the patch swatch a random color
            %
            % If you want to reuse existing code, the callback for
            % the button below can be changed to the following anonymous
            % function that reuses the code in the function button_press.
            %
            % @(h, dummy) button_press([], [], rand(1,3))
            %
            % If you do this, the function rc_button_press can be removed
            uicontrol(f2,'String','Random Color', ...
                'callback', @rc_button_press, 'Position',[20 5 200 20]);
            % Change the string shown on the new button
            set(new,'String','quit');
            % Make the swatch patch green
            set(swatch,'FaceColor','g');
            % Enable both the red and blue buttons
            set(red,'Enable','on');
            set(blue,'Enable','on');
            % If we do have a new figure up already (in which case the new
            % button's string has been changed to 'quit') ...
        else
            % Close the new figure
            close(f2);
            % Tell the GUIs that there is no longer a new figure
            f2 = [];
        end
    end
% End of new button's callback

%% Random color button's callback
    function rc_button_press(h,dummy)
        % Set the swatch patch's color to a random RGB triplet
        set(swatch,'FaceColor',rand(1,3));
    end
% End of random color button's callback

%% New figure's closing function
    function cancel_f2(h,dummy)
        % Close the new figure window the new button created
        delete(f2);
        % Tell the GUIs that there is no longer a new figure
        f2 = [];
        % Reset the new button's string
        set(new,'String','new')
    end
% End of new figure's closing function

%% Original figure's closing function
    function closefirstfigure(h, dummy)
        % If the new figure window the new button created is open ...
        if ~isempty(f2)
            % Close it
            delete(f2);
        end
        % Close the original figure
        delete(f1);
    end
% End of original figure's closing function
end
% End of main function red_blue_two