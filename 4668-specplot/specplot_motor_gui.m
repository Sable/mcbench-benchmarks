function varargout = specplot_motor_gui(varargin)
% SPECPLOT_MOTOR_GUI M-file for specplot_motor_gui.fig
%      SPECPLOT_MOTOR_GUI, by itself, creates a new SPECPLOT_MOTOR_GUI or raises the existing
%      singleton*.
%
%      H = SPECPLOT_MOTOR_GUI returns the handle to a new SPECPLOT_MOTOR_GUI or the handle to
%      the existing singleton*.
%
%      SPECPLOT_MOTOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECPLOT_MOTOR_GUI.M with the given input arguments.
%
%      SPECPLOT_MOTOR_GUI('Property','Value',...) creates a new SPECPLOT_MOTOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before specplot_motor_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to specplot_motor_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help specplot_motor_gui

% Last Modified by GUIDE v2.5 18-Mar-2004 18:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @specplot_motor_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @specplot_motor_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before specplot_motor_gui is made visible.
function specplot_motor_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to specplot_motor_gui (see VARARGIN)

% Choose default command line output for specplot_motor_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes specplot_motor_gui wait for user response (see UIRESUME)
% uiwait(handles.motor);


% --- Outputs from this function are returned to the command line.
function varargout = specplot_motor_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listmotor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listmotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listmotor.
function listmotor_Callback(hObject, eventdata, handles)
% hObject    handle to listmotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listmotor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listmotor


% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


