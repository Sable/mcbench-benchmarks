function agilentScope(visaResourceString)
% AGILENTSCOPE  Controls an Agilent MSO6014A Oscilloscope
%  agilentScope(S) opens a GUI for controlling an Agilent MSO6014A
%  Oscilloscope, where S is the VISA resource string for the instrument.
%
%  agilentScope('simulate') uses a simulated instrument.
%
%  Examples:
%   % Starts a GUI connected to the instrument
%   % with the specified visa resource string
%   agilentScope('USB0::0x0957::0x1724::MY45007100::INSTR')
%
%   % Start a GUI with a simulated instrument
%   agilentScope('simulate')

if ~isempty(findobj('tag', 'AgilentScopeGUI'))
    disp('GUI is already running');
    return;
end

%------

if strcmp(visaResourceString, 'simulate')
    scope = agilentMSO6014A_simulator(visaResourceString);
else
    scope = agilentMSO6014A(visaResourceString);
end

handles = guihandles( scope_gui );
timerObj = timer('period', 1, 'BusyMode','drop', ...
    'executionMode', 'fixedRate', ...
    'timerFcn', @getWaveTimerCallback);
initializeGUI();

% initializes the values by calling autoscale
autoscaleCallback(handles.autoscaleButton, []);

%% -------------------------------------------------
    function initializeGUI
        set(handles.figure1, 'name', 'MATLAB + Instrument Control Toolbox', ...
            'deleteFcn', @figureDeleteCallback, 'tag', 'AgilentScopeGUI', ...
            'handleVisibility', 'on');

        set(handles.vscaleEdit, 'string', '1.0',  ...
            'callback', @verticalScaleCallback);
        set(handles.timeBaseEdit, 'string', '1.0',  ...
            'callback', @timeBaseCallback);

        set(handles.updateIntervalEdit, 'string', 1); % default is 1 second
        set(handles.autoscaleButton, 'callback', @autoscaleCallback);
        set(handles.startstopButton, 'callback', @startstopCallback);

        set(handles.waveformAxes, 'fontsize', 9, 'color', 'k', 'nextplot', 'add', ...
            'tickdir', 'out', 'xcolor', [0 .6 0], 'ycolor', [0 0.6 0],'Xlim',[0 1000]);
        grid(handles.waveformAxes, 'on');
        handles.waveformLine = plot(handles.waveformAxes,0,'g');
        drawnow;
    end

    function startstopCallback(hobj, eventdata) %#ok<INUSD>
        if strcmp(get(timerObj,'running'), 'off')
            period = str2double(get(handles.updateIntervalEdit, 'string'));
            if period<0.3
                period = 0.3;
                set(handles.updateIntervalEdit, 'string','0.3')
            end
            set(timerObj, 'period', period);
            set(hobj, 'string', 'Stop data collection', 'foregroundcolor', 'r');
            set(handles.updateIntervalEdit, 'enable', 'off');
            start(timerObj);
        else % timer is running
            stop(timerObj);
            set(hobj, 'string', 'Get data from Scope', 'foregroundcolor', 'k');
            set(handles.updateIntervalEdit, 'enable', 'on');
        end
    end


%% -----------------------------------------------
%     function startstopCallback(hobj, eventdata) %#ok<INUSD>
%         xlabel(handles.waveformAxes, 'samples');
%         ylabel(handles.waveformAxes, 'Amplitude (volts)');
%
%         if get(hobj,'Value')
%             set(hobj, 'string', 'Stop data collection', 'foregroundcolor', 'r');
%         else
%             set(hobj, 'string', 'Get data from Scope', 'foregroundcolor', 'k');
%         end
%
%         while get(hobj,'Value')
%             data = scope.getWaveform();
%             set(handles.waveformLine,'YData', data);
%             set(handles.waveformAxes,'YLim',[min(data) max(data)]);
%             drawnow;
%         end
%
%     end

%% -----------------------------------------------
    function autoscaleCallback(hobj, eventdata) %#ok<INUSD>
        scope.autoscale();
        set(handles.vscaleEdit,   'string', num2str(scope.getVerticalScale()));
        set(handles.timeBaseEdit, 'string', num2str(scope.getTimeBase()));
    end


    function verticalScaleCallback(hobj, eventdata)
        newvalue = str2double( get(hobj, 'string') );
        if isnan(newvalue)
            set(hobj, 'string', num2str(scope.getVerticalScale()));
        else
            scope.setVerticalScale(newvalue);
        end
    end

    function timeBaseCallback(hobj, eventdata)
        newvalue = str2double( get(hobj, 'string') );
        if isnan(newvalue)
            set(hobj, 'string', num2str(scope.getTimeBase()));
        else
            scope.setTimeBase(newvalue);
        end
    end

%% -----------------------------------------------
    function figureDeleteCallback(hobj, eventdata)
        if isequal(get(timerObj,'running'), 'on')
            stop(timerObj);
        end
        delete(timerObj);
        scope.close();
    end

%% ------------------
% This callback is evoked every timer tick, and grabs data from the scope
    function getWaveTimerCallback(hobj, eventdata) %#ok<INUSD>
        data = scope.getWaveform();
        set(handles.waveformLine, 'xdata', 1:length(data), 'ydata', data);
        axis(handles.waveformAxes, 'tight');
        xlabel(handles.waveformAxes, 'samples');
        ylabel(handles.waveformAxes, 'Amplitude (volts)');
    end
end
