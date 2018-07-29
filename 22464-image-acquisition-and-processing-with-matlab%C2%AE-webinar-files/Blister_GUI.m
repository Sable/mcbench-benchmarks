function varargout = Blister_GUI(varargin)
% BLISTER_GUI M-file for Blister_GUI.fig
%      BLISTER_GUI, by itself, creates a new BLISTER_GUI or raises the existing
%      singleton*.
%
%      H = BLISTER_GUI returns the handle to a new BLISTER_GUI or the handle to
%      the existing singleton*.
%
%      BLISTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLISTER_GUI.M with the given input arguments.
%
%      BLISTER_GUI('Property','Value',...) creates a new BLISTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Blister_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Blister_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Blister_GUI

% Last Modified by GUIDE v2.5 24-Nov-2008 12:22:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Blister_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Blister_GUI_OutputFcn, ...
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


% --- Executes just before Blister_GUI is made visible.
function Blister_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Blister_GUI (see VARARGIN)

% Choose default command line output for Blister_GUI
handles.output = hObject;
axes(handles.axes1);
imshow('sample 01.jpg');  % Show a default sample image

% Create video input objects
handles.vid_obj = videoinput('winvideo');
handles.obj_src= get(handles.vid_obj,'Source');

% Set device parameters
set(handles.obj_src,'Brightness',160);
set(handles.obj_src,'Saturation',160);
set(handles.vid_obj,'FramesPerTrigger',1);
triggerconfig(handles.vid_obj,'manual');
set(handles.vid_obj,'TriggerRepeat',inf);
start(handles.vid_obj);

handles.vidRes = get(handles.vid_obj, 'VideoResolution');
handles.nBands = get(handles.vid_obj, 'NumberOfBands');

axes(handles.axes2);
himage = image( zeros(handles.vidRes(2), handles.vidRes(1), handles.nBands) );
preview(handles.vid_obj,himage); 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Blister_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Blister_GUI_OutputFcn(hObject, eventdata, handles) 
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

% Update the status messages
set(handles.text9,'string','Status:  Taking a snapshot...');

% Send a manual trigger to the camera
trigger(handles.vid_obj);

% Get data from the buffer and display
imdata = getdata(handles.vid_obj);
axes(handles.axes1);
imshow(imdata);
axes(handles.axes1);
set(handles.text9,'string','Status:  Searching for broken pills...');
drawnow

% Call our code in Blister Read
[numPills, numBroken] = BlisterRead(imdata);

% Display information regarding broken and full pills
set(handles.text7,'string',num2str(numPills));
set(handles.text8,'string',num2str(numBroken));
set(handles.text9,'string','Status:  Estimated broken pills.');
hold off;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.vid_obj);
% Hint: delete(hObject) closes the figure
delete(hObject);
