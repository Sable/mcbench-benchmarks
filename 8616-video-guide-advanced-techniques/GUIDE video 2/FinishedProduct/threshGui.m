function varargout = threshGui(varargin)
% THRESHGUI M-file for threshGui.fig
%      THRESHGUI, by itself, creates a new THRESHGUI or raises the existing
%      singleton*.
%
%      H = THRESHGUI returns the handle to a new THRESHGUI or the handle to
%      the existing singleton*.
%
%      THRESHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHGUI.M with the given input arguments.
%
%      THRESHGUI('Property','Value',...) creates a new THRESHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before threshGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threshGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threshGui

%   Copyright 1984-2010 The MathWorks, Inc. 
% Last Modified by GUIDE v2.5 30-Sep-2005 11:03:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threshGui_OpeningFcn, ...
                   'gui_OutputFcn',  @threshGui_OutputFcn, ...
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


% --- Executes just before threshGui is made visible.
function threshGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threshGui (see VARARGIN)

% Choose default command line output for threshGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes threshGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threshGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hMainGui = getappdata(0, 'hMainGui');
fhUpdateAxes = getappdata(hMainGui, 'fhUpdateAxes');

thresh = get(hObject,'Value');
setappdata(hMainGui, 'thresh', thresh);
feval(fhUpdateAxes);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

hMainGui = getappdata(0, 'hMainGui');
thresh   = getappdata(hMainGui, 'thresh');

set(hObject, 'value', thresh)

