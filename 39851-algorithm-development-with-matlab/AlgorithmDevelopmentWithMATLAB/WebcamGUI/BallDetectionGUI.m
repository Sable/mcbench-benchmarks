function varargout = BallDetectionGUI(varargin)
% BALLDETECTIONGUI MATLAB code for BallDetectionGUI.fig
%      BALLDETECTIONGUI, by itself, creates a new BALLDETECTIONGUI or raises the existing
%      singleton*.
%
%      H = BALLDETECTIONGUI returns the handle to a new BALLDETECTIONGUI or the handle to
%      the existing singleton*.
%
%      BALLDETECTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BALLDETECTIONGUI.M with the given input arguments.
%
%      BALLDETECTIONGUI('Property','Value',...) creates a new BALLDETECTIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BallDetectionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BallDetectionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BallDetectionGUI

% Last Modified by GUIDE v2.5 30-Mar-2011 17:45:48

% Copyright 2011 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
   'gui_Singleton',  gui_Singleton, ...
   'gui_OpeningFcn', @BallDetectionGUI_OpeningFcn, ...
   'gui_OutputFcn',  @BallDetectionGUI_OutputFcn, ...
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


% --- Executes just before BallDetectionGUI is made visible.
function BallDetectionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BallDetectionGUI (see VARARGIN)

% Choose default command line output for BallDetectionGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BallDetectionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

movegui(handles.figure1, 'center');

warning('off', 'imaq:peekdata:tooManyFramesRequested');
imaqreset;


% --- Outputs from this function are returned to the command line.
function varargout = BallDetectionGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartStopBtn.
function StartStopBtn_Callback(hObject, eventdata, handles)
% hObject    handle to StartStopBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject, 'String'), 'Start')
   % create video object
   handles.vid = webcam;
   
   % set timer function
   handles.vid.TimerPeriod = 0.1;
   handles.vid.TimerFcn = {@videoTimerFunction, handles};
   
   % start acquisition
   start(handles.vid);
   
   % change button label
   set(hObject, 'String', 'Stop');
   
   % Update handles structure
   guidata(hObject, handles);
else
   % stop image acquisition
   stop(handles.vid);
   
   % delete video object
   delete(handles.vid);
   
   % clear image
   cla(handles.axes1);
   
   % change button label
   set(hObject, 'String', 'Start');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timer Function
function videoTimerFunction(vid, eventdata, handles)

% get a single frame
pic = peekdata(vid,1);

% find ball
thresh = str2double(get(handles.threshEdit, 'String'));
h = get(handles.imageTypeSelection, 'SelectedObject');
imageType = get(h, 'UserData');
findBallFcn(pic, thresh, imageType, handles.axes1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function threshEdit_Callback(hObject, eventdata, handles)
% hObject    handle to threshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshEdit as text
%        str2double(get(hObject,'String')) returns contents of threshEdit as a double


% --- Executes during object creation, after setting all properties.
function threshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in imageTypeSelection.
function imageTypeSelection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in imageTypeSelection
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('on', 'imaq:peekdata:tooManyFramesRequested');
imaqreset;
