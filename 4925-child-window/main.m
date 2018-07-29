
function varargout = main(varargin)
% Main: callback functions for main window
%
%    ABOUT
%
%      -Created:     January 2004
%      -Last update: February 13th, 2004
%      -Revision:    0.0.1
%      -Author:      R. S. Schestowitz, University of Manchester
% ==============================================================

% Edit the above text to modify the response to help_button register

% Last Modified by GUIDE v2.5 24-Mar-2004 17:39:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @register_OpeningFcn, ...
    'gui_OutputFcn',  @register_OutputFcn, ...
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

% --- Executes just before register is made visible.
function register_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to register (see VARARGIN)

% Choose default command line output for register
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    initialize_gui(hObject, handles);
end




% --- Outputs from this function are returned to the command line.
function varargout = register_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function initialize_gui(fig_handle, handles)


setappdata(0, 'test_data', '1');


function open_child_Callback(hObject, eventdata, handles)

child;



function show_params_Callback(hObject, eventdata, handles)

msgbox(getappdata(0, 'test_data'), 'Parameter Shown');