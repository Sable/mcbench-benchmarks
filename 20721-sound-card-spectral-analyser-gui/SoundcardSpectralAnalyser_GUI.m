function varargout = SoundcardSpectralAnalyser_GUI(varargin)
% SOUNDCARDSPECTRALANALYSER_GUI Performs Real-Time Analysis on soundcard data
%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SoundcardSpectralAnalyser_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SoundcardSpectralAnalyser_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before SoundcardSpectralAnalyser_GUI is made visible.-------
function SoundcardSpectralAnalyser_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SoundcardSpectralAnalyser_GUI (see VARARGIN)

    % Initialise plots
    axes(handles.time_domain_axes)
    hold on
    handles.time_domain_plot(1) = plot(nan, nan, 'r');
    handles.time_domain_plot(2) = plot(nan, nan, 'b');
    grid on
    zoom on
    xlabel('Sample')
    ylabel('Counts')
    
    axes(handles.freq_domain_axes)
    hold on
    handles.freq_domain_plot(1) = plot(nan, nan, 'r');
    handles.freq_domain_plot(2) = plot(nan, nan, 'b');
    grid on
    zoom on
    xlabel('Frequency (Hz)')
    ylabel('dB re 1 Count / sqrt(Hz)')
    
    handles.spectral_analyser = SoundcardSpectralAnalyser(handles.time_domain_plot, ...
                                                          handles.freq_domain_plot);

	% gather the parameter controls into an array for bulk enable/disable
    handles.parameter_controls(1) = handles.fs_text;
    handles.parameter_controls(2) = handles.fs_edit;
    handles.parameter_controls(3) = handles.sample_size_text;
    handles.parameter_controls(4) = handles.sample_size_edit;
    handles.parameter_controls(5) = handles.channels_text;
    handles.parameter_controls(6) = handles.channels_popup;
    handles.parameter_controls(7) = handles.update_rate_text;
    handles.parameter_controls(8) = handles.update_rate_edit;
    
    % Defaults
    handles.sample_freq = 44000;
    handles.sample_size = 16;
    handles.update_rate = 5;
    handles.channels    = 2;
    
    % Trigger the resize callback to ensure correct layout
    set(handles.figure1, 'Position', [103 25 120 35]);
    
    % Update handles structure
    handles.output = hObject;
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = SoundcardSpectralAnalyser_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    varargout{1} = handles.output;

% --- Executes on GUI close-----------------------------------------------------
function varargout = SoundcardSpectralAnalyser_GUI_DeleteFcn(hObject, eventdata, handles) 
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
	% Stop analyser in case its running
    handles.spectral_analyser = stop(handles.spectral_analyser);
    
% --- Executes on figure resize.------------------------------------------------
function SoundcardSpectralAnalyser_GUI_ResizeCallback(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Need to allow space around axes for labels
    PLOT_BOT_PAD   = 3;
    PLOT_TOP_PAD   = 2;
    PLOT_LEFT_PAD  = 12;
    PLOT_RIGHT_PAD = 4;
    
    % Get the current position
    figure_window = get(hObject, 'Position');
    
    % Available plot space is figure minus bottom panel
    bottom_panel_size = get(handles.parameters_panel, 'Position');

    plot_area_position(1) = bottom_panel_size(1);                           % X
    plot_area_position(2) = bottom_panel_size(2) +  bottom_panel_size(4);   % Y
    plot_area_position(3) = figure_window(3);                               % Width
    plot_area_position(4) = figure_window(4) - bottom_panel_size(4);        % Height
    
    freq_axes_position = [plot_area_position(1) + PLOT_LEFT_PAD                     ...
                          plot_area_position(2) + PLOT_BOT_PAD                      ...
                          plot_area_position(3) - (PLOT_LEFT_PAD + PLOT_RIGHT_PAD)  ...
                          0.5*plot_area_position(4) - (PLOT_TOP_PAD + PLOT_BOT_PAD)];
                      
    time_axes_position = [plot_area_position(1) + PLOT_LEFT_PAD                             ...
                          plot_area_position(2) + 0.5*plot_area_position(4) + PLOT_BOT_PAD  ...
                          plot_area_position(3) - (PLOT_LEFT_PAD + PLOT_RIGHT_PAD)          ...
                          0.5*plot_area_position(4) - (PLOT_TOP_PAD + PLOT_BOT_PAD)];
    
    set(handles.time_domain_axes, 'Position', time_axes_position)
    set(handles.freq_domain_axes, 'Position', freq_axes_position)
    
    bottom_panel_size(3) = figure_window(3);
    set(handles.parameters_panel, 'Position', bottom_panel_size);

% --- Executes after the contents of fs_edit are updated.-----------------------
function fs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of fs_edit as text
    %        str2double(get(hObject,'String')) returns contents of fs_edit as a double

    handles = guidata(gcbo);
    
    handles.sample_freq = str2double(get(hObject,'String'));    
    handles.spectral_analyser = set(handles.spectral_analyser, ...
                                    'Fs', handles.sample_freq);
    
	% Update the plot axes
	set(handles.freq_domain_axes, 'XLim', [0 handles.sample_freq/2]);
    set(handles.time_domain_axes, 'XLim', [0 handles.sample_freq/handles.update_rate]);
                                    
    guidata(gcbo, handles);

% --- Executes during object creation, after setting all properties.------------
function fs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes after the contents of sample_size_edit are updated.--------------
function sample_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sample_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_size_edit as text
%        str2double(get(hObject,'String')) returns contents of sample_size_edit as a double
    
    handles = guidata(gcbo);
    
    handles.sample_size = str2double(get(hObject,'String'));    
    handles.spectral_analyser = set(handles.spectral_analyser, ...
                                    'SampleSize', handles.sample_size);
	% Update the plot axes
    plot_limit = 2^(handles.sample_size-1);
	set(handles.time_domain_axes, 'YLim', [-plot_limit plot_limit]);
                                    
    guidata(gcbo, handles);
    
% --- Executes during object creation, after setting all properties.------------
function sample_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in channels_popup.---------------------------
function channels_popup_Callback(hObject, eventdata, handles)
% hObject    handle to channels_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns channels_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channels_popup

    handles = guidata(gcbo);
    
    handles.channels = get(hObject, 'Value');    
    handles.spectral_analyser = set(handles.spectral_analyser, ...
                                    'Channels', handles.channels);

    guidata(gcbo, handles);

% --- Executes during object creation, after setting all properties.------------
function channels_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes after the contents of update_rate_edit are updated.--------------
function update_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to update_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of update_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of update_rate_edit as a double

    handles = guidata(gcbo);
    
    handles.update_rate = str2double(get(hObject,'String'));
    handles.spectral_analyser = set(handles.spectral_analyser, ...
                                    'UpdateRate', handles.update_rate);
    % Update the plot axes
    set(handles.time_domain_axes, 'XLim', ...
        [0 handles.sample_freq/handles.update_rate]);

    guidata(gcbo, handles);
    
% --- Executes during object creation, after setting all properties.------------
function update_rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to update_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in start_stop_toggle.----------------------------
function start_stop_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to start_stop_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_stop_toggle

    handles = guidata(gcbo);

    % Disable the start/stop toggle to avoid double clicking which can cause
    % the spectral_analyser fail to stop
    set(hObject, 'Enable', 'off');

    if (get(hObject,'Value')) % Start

        set(hObject, 'String', 'Starting...')

        % clear plot of any previous data
        set(handles.time_domain_plot, 'XData', nan, 'YData', nan);
        set(handles.freq_domain_plot, 'XData', nan, 'YData', nan);

        for i = 1:length(handles.parameter_controls)
            set(handles.parameter_controls(i), 'Enable', 'off');
        end

        handles.spectral_analyser = start(handles.spectral_analyser);
        pause(1);

        set(hObject, 'String', 'Stop')
        set(hObject, 'BackgroundColor', [1 0 0])

    else % Stop

        set(hObject, 'String', 'Stopping...')

        handles.spectral_analyser = stop(handles.spectral_analyser);
        pause(1)

        for i = 1:length(handles.parameter_controls)
            set(handles.parameter_controls(i), 'Enable', 'on');
        end

        set(hObject, 'String', 'Start')
        set(hObject, 'BackgroundColor', [0 1 0])

    end

    set(hObject, 'Enable', 'on');

    guidata(gcbo, handles);



