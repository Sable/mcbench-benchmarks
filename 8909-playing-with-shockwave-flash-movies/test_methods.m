function varargout = test_methods(varargin)
% TEST_METHODS M-file for test_methods.fig
%      TEST_METHODS, by itself, creates a new TEST_METHODS or raises the existing
%      singleton*.
%
%      H = TEST_METHODS returns the handle to a new TEST_METHODS or the handle to
%      the existing singleton*.
%
%      TEST_METHODS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_METHODS.M with the given input arguments.
%
%      TEST_METHODS('Property','Value',...) creates a new TEST_METHODS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_methods_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_methods_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_methods

% Last Modified by GUIDE v2.5 02-Nov-2005 11:22:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_methods_OpeningFcn, ...
                   'gui_OutputFcn',  @test_methods_OutputFcn, ...
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


% --- Executes just before test_methods is made visible.
function test_methods_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_methods (see VARARGIN)

% Choose default command line output for test_methods
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_methods wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = test_methods_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in play_tag.
function play_tag_Callback(hObject, eventdata, handles)
% hObject    handle to play_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get(handles.activex2)
handles.activex2.Play() %play movie

% --- Executes on button press in stop_tag.
function stop_tag_Callback(hObject, eventdata, handles)
% hObject    handle to stop_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.activex2,'Playing',0)
handles.activex2.StopPlay() %stop movie


function edit_movie_Callback(hObject, eventdata, handles)
% hObject    handle to edit_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_movie as text
%        str2double(get(hObject,'String')) returns contents of edit_movie as a double



% --- Executes on button press in zoom_in.
function zoom_in_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex2.Zoom(50) %zoom on



% --- Executes on button press in close_req.
function close_req_Callback(hObject, eventdata, handles)
% hObject    handle to close_req (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1) %close GUI


% --- Executes on button press in zoom_out.
function zoom_out_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex2.Zoom(200) %zoom out





