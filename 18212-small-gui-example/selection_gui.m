function varargout = selection_gui(varargin)
% SELECTION_GUI M-file for selection_gui.fig
%      SELECTION_GUI, by itself, creates a new SELECTION_GUI or raises the existing
%      singleton*.
%
%      H = SELECTION_GUI returns the handle to a new SELECTION_GUI or the handle to
%      the existing singleton*.
%
%      SELECTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTION_GUI.M with the given input arguments.
%
%      SELECTION_GUI('Property','Value',...) creates a new SELECTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selection_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selection_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selection_gui

% Last Modified by GUIDE v2.5 04-Jan-2008 12:38:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selection_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @selection_gui_OutputFcn, ...
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


% --- Executes just before selection_gui is made visible.
function selection_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selection_gui (see VARARGIN)
handles.guifig = gcf;
movegui(handles.guifig,'center');

guidata(handles.guifig,handles);
% Choose default command line output for selection_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selection_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selection_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(handles.guifig,'WindowStyle','Modal'); %make figure modal

uiwait; %wait till the figure is destroyed  or asked to resume

try %this statement is necessary if figure is destroyed , then output argument will be empty by default
    handles = guidata(handles.guifig);
    varargout{1} = handles.selection;
    closereq; % close the gui if OK is pressed
catch
    varargout{1} = [];
end



% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'value');%if there is no selection of radio button and OK is pressed then the selection is Radio Button1 by default
    handles.selection = handles.value;
else
    handles.selection = 'Radio Button1';
end

guidata(hObject, handles);
guidata(handles.guifig, handles);

uiresume;



% --------------------------------------------------------------------
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radio1'
        handles.value = 'Radio Button1'; %if Radio Button1 is selected then update handles.value
    case 'radio2'
        handles.value = 'Radio Button2';%if Radio Button2 is selected then update handles.value
end
guidata(hObject, handles);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

