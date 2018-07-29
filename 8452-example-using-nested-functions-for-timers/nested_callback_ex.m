function nested_callback_ex

% Create and configure timer object
t = timer('ExecutionMode','fixedRate', ...  % Run continuously
    'TasksToExecute',10, ...                % Runs 10 times
    'TimerFcn',@MyTimerFcn);                % Run MyTimerFcn at each timer event

% Load and display a grayscale image
Im = imread('street1.jpg');imagesc(Im);

% Start the timer
start(t)

    function MyTimerFcn(obj,event)
        % Scale and display image
        Im = Im*1.1;                        % Make brighter
        imagesc(Im)                         % Display updated image
    end

end     % function nested_callback_ex

% Copyright 2005 The MathWorks, Inc