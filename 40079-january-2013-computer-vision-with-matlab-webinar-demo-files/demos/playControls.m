% Copyright 2013 The MathWorks, Inc.
function y=playControls()

persistent state;
persistent hpause;
persistent hexit; %#ok<PUSE>
persistent isPaused;

if isempty(state)
    initializeUI;
end

% deal with the state
if state == 2 % exit
    y = 0; % terminate the loop
    state = [];
else
    % block the return until pause is turned off
    while(isPaused)
        drawnow; % keep refreshing the UI
        pause(0.01); % don't hog the CPU
    end
    
    y = 1;
end

    function exit_callback(~, ~)
        state = 2; % 2 signifies exit
        isPaused = false;
        close gcf;
    end

    function pause_callback(obj, ~)
        % Handle button string toggling
        if get(hpause,'value')
            isPaused = true;
            set(obj, 'string', 'PLAY');
        else
            isPaused = false;
            set(obj, 'string', 'PAUSE');
        end
    end

    function initializeUI
        state = 0;
        
        scrsz = get(0,'ScreenSize');
        % [left, bottom, width, height]
        %figure('Position',[1 scrsz(4)-50 80 50]);
        h = figure('Position',[scrsz(3)*.25 scrsz(4)*.75 80 50], 'Name', 'Loop controls', ...
            'NumberTitle','off','MenuBar','none');
        
        hpause = uicontrol('unit','pixel','style','togglebutton','string','PAUSE',...
            'position',[10 10 50 25],'callback',@pause_callback);
        hexit = uicontrol('unit','pixel','style','pushbutton','string','EXIT',...
            'position',[60 10 50 25],'callback',@exit_callback);
        
        set(h,'HandleVisibility','callback');
        
        isPaused = false;
    end

end
