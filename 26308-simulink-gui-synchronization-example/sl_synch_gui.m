function varargout = sl_synch_gui(varargin)
% SL_SYNCH_GUI M-file for sl_synch_gui.fig
%      SL_SYNCH_GUI, by itself, creates a new SL_SYNCH_GUI or raises the existing
%      singleton*.
%
%      H = SL_SYNCH_GUI returns the handle to a new SL_SYNCH_GUI or the handle to
%      the existing singleton*.
%
%      SL_SYNCH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SL_SYNCH_GUI.M with the given input arguments.
%
%      SL_SYNCH_GUI('Property','Value',...) creates a new SL_SYNCH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sl_synch_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sl_synch_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Edited by Will Campbell, MathWorks Inc.
% will.campbell@mathworks.com
% January 7, 2010
% Copyright 2010 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 19-Feb-2010 10:51:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sl_synch_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sl_synch_gui_OutputFcn, ...
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


% --- Executes just before sl_synch_gui is made visible.
function sl_synch_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sl_synch_gui (see VARARGIN)

% Choose default command line output for sl_synch_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sl_synch_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Get the value of the manual switch and synch the GUI
value = get_param([bdroot '/Manual Switch'],'sw');
if strcmp(value,'0')
    set(handles.checkbox_switch,'Value',0)
else
    set(handles.checkbox_switch,'Value',1)
end

% Get the value of the gain edit box and synch the GUI
value = get_param([bdroot '/Gain'],'Gain');
set(handles.edit_Gain,'String',value); 

% Set the value of the gain slider, with max/min of +10/-10
slider_position = max(0,min(1,(str2double(value) + 10)/20));
set(handles.slider_Gain,'Value',slider_position);

% Assign gui, startstop, switch, and gain handles to the base workspace
assignin('base','sl_synch_handles',handles)
assignin('base','startstop_hObject',handles.pushbutton_startstop)
assignin('base','switch_hObject',handles.checkbox_switch)
assignin('base','gain_hObject',handles.edit_Gain)

% --- Outputs from this function are returned to the command line.
function varargout = sl_synch_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_startstop.
function pushbutton_startstop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_startstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mystring = get(hObject,'String');
status = get_param(bdroot,'simulationstatus');

if strcmp(mystring,'Start Simulation')
    
    % Check the status of the simulation and start it if it's stopped
    if strcmp(status,'stopped')
        set_param(bdroot,'simulationcommand','start')
    end
    
    % Update the string on the pushbutton
    set(handles.pushbutton_startstop,'String','Stop Simulation')
    
elseif strcmp(mystring,'Stop Simulation')
    
    % Check the status of the simulation and stop it if it's running
    if strcmp(status,'running')
        set_param(bdroot, 'SimulationCommand', 'Stop')
    end
    
    % Update the string on the pushbutton
    set(handles.pushbutton_startstop,'String','Start Simulation')
    
else
    warning('Unrecognized string for pushbutton_startstop') %#ok<WNTAG>
end

% Assign handles and the startstop object to the base workspace
assignin('base','sl_synch_handles',handles)
assignin('base','startstop_hObject',handles.pushbutton_startstop)


% --- Executes on button press in checkbox_switch.
function checkbox_switch_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_switch

value = get(hObject,'Value');

if value == 0
    set_param([bdroot '/Manual Switch'],'sw','0')
else
    set_param([bdroot '/Manual Switch'],'sw','1')
end

% Assign handles and the switch object to the base workspace
assignin('base','sl_synch_handles',handles)
assignin('base','switch_hObject',handles.checkbox_switch)



function edit_Gain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gain as text
%        str2double(get(hObject,'String')) returns contents of edit_Gain as a double

value = get(hObject,'String');

% Update the model's gain value
set_param([bdroot '/Gain'],'Gain',value)

% Set the value of the gain slider, with max/min of +10/-10
slider_position = max(0,min(1,(str2double(value) + 10)/20));
set(handles.slider_Gain,'Value',slider_position);

% Update simulation if the model is running
status = get_param(bdroot,'simulationstatus');
if strcmp(status,'running')
    set_param(bdroot, 'SimulationCommand', 'Update')
end

% --- Executes during object creation, after setting all properties.
function edit_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Gain_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Get the value of the gain slider and determine what the gain value should be
slider_position = get(hObject,'Value');
value = num2str(slider_position*20 - 10);

% Update the model's gain value
set_param([bdroot '/Gain'],'Gain',value)

% Set the value of the gain edit box
set(handles.edit_Gain,'String',value);

% Update simulation if the model is running
status = get_param(bdroot,'simulationstatus');
if strcmp(status,'running')
    set_param(bdroot, 'SimulationCommand', 'Update')
end

% --- Executes during object creation, after setting all properties.
function slider_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
