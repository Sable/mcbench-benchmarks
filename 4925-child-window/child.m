function varargout = child(varargin)
% CHILD: callbacks for child.fig
%
%    ABOUT
%
%      -Created:     February 12th, 2004
%      -Last update: 
%      -Revision:    0.0.2
%      -Author:      R. S. Schestowitz, University of Manchester
% ==============================================================

% Edit the above text to modify the response to help_button register

% Last Modified by GUIDE v2.5 23-Mar-2004 07:42:43

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @advanced_OpeningFcn, ...
    'gui_OutputFcn',  @advanced_OutputFcn, ...
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
function advanced_OpeningFcn(hObject, eventdata, handles, varargin)
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

% UIWAIT makes register pause for user response (see UIRESUME)
% uiwait(handles.Advanced_window);


% --- Outputs from this function are returned to the command line.
function varargout = advanced_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function initialize_gui(fig_handle, handles)

set(handles.slider_value, 'String', getappdata(0, 'test_data'));
set(handles.slider, 'Value', str2num(get(handles.slider_value, 'String')));


% --- Executes on button press in ok_botton.
function ok_botton_Callback(hObject, eventdata, handles)
% hObject    handle to ok_botton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


setappdata(0, 'test_data', get(handles.slider_value, 'String'));
close;




% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in apply_button.
function apply_button_Callback(hObject, eventdata, handles)
% hObject    handle to apply_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0, 'test_data', get(handles.slider_value, 'String'));

function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function slider_Callback(hObject, eventdata, handles)

set(handles.slider_value, 'String', num2str(ceil(get(handles.slider, 'Value'))));