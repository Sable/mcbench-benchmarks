function varargout = TabPanel(varargin)
% TABPANEL M-file for TabPanel.fig
%      TABPANEL, by itself, creates a new TABPANEL or raises the existing
%      singleton*.
%
%      H = TABPANEL returns the handle to a new TABPANEL or the handle to
%      the existing singleton*.
%
%      TABPANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABPANEL.M with the given input arguments.
%
%      TABPANEL('Property','Value',...) creates a new TABPANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TabPanel_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TabPanel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TabPanel

% Last Modified by GUIDE v2.5 20-Apr-2004 10:07:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TabPanel_OpeningFcn, ...
                   'gui_OutputFcn',  @TabPanel_OutputFcn, ...
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


% --- Executes just before TabPanel is made visible.
function TabPanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TabPanel (see VARARGIN)

% Choose default command line output for TabPanel
handles.output = hObject;

% uicontrols handles list for tabA and tabB respectively
handles.tabA = [ handles.txNullA, handles.pbNullA, handles.axDisplay ];
handles.tabB = [ handles.txNullB, handles.pbNullB, handles.pbTest, ...
                 handles.chTest,  handles.lbTest, handles.rbTest ];



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TabPanel wait for user response (see UIRESUME)
% uiwait(handles.TabPanel);


% --- Outputs from this function are returned to the command line.
function varargout = TabPanel_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tabA.
function tabA_ButtonDownFcn(hObject, eventdata, handles)
%
set(handles.tabA, 'Visible', 'on');
set(handles.tabB, 'Visible', 'off');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tabB.
function tabB_ButtonDownFcn(hObject, eventdata, handles)
% 

set(handles.tabA, 'Visible', 'off');
set(handles.tabB, 'Visible', 'on');



% --- Executes on selection change in lbTest.
function lbTest_Callback(hObject, eventdata, handles)


% --- Executes on button press in chTest.
function chTest_Callback(hObject, eventdata, handles)

% --- Executes on button press in pbTest.
function pbTest_Callback(hObject, eventdata, handles)

oStr = get( handles.lbTest, 'String');
nStr = 'Thanx. I needed it!';
lbStr = strvcat(oStr, nStr);
set( handles.lbTest, 'String', lbStr);


% --- Executes on button press in rbTest.
function rbTest_Callback(hObject, eventdata, handles)

% --- Executes on button press in pbNullB.
function pbNullB_Callback(hObject, eventdata, handles)



