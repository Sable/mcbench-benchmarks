function varargout = simpleGUI_imaq(varargin)
%SIMPLEGUI_IMAQ M-file for simpleGUI_imaq.fig
%      SIMPLEGUI_IMAQ, by itself, creates a new SIMPLEGUI_IMAQ or raises the existing
%      singleton*.
%
%      H = SIMPLEGUI_IMAQ returns the handle to a new SIMPLEGUI_IMAQ or the handle to
%      the existing singleton*.
%
%      SIMPLEGUI_IMAQ('Property','Value',...) creates a new SIMPLEGUI_IMAQ using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to simpleGUI_imaq_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SIMPLEGUI_IMAQ('CALLBACK') and SIMPLEGUI_IMAQ('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMPLEGUI_IMAQ.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simpleGUI_imaq

% Last Modified by GUIDE v2.5 04-Sep-2012 15:26:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simpleGUI_imaq_OpeningFcn, ...
                   'gui_OutputFcn',  @simpleGUI_imaq_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before simpleGUI_imaq is made visible.
function simpleGUI_imaq_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for simpleGUI_imaq
handles.output = hObject;
load_system('simpleModel_imaq');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simpleGUI_imaq wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simpleGUI_imaq_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('simpleModel_imaq/Constant','Value','0');
% set_param('simpleModel','SimulationCommand','Stop');
axes(handles.axes1);
cla;
axes(handles.axes2);
cla;
sim('simpleModel_imaq');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('simpleModel_imaq/Constant','Value','1');


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
