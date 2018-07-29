function varargout = VScope_start(varargin)
% VSCOPE_START M-file for VScope_start.fig
%      VSCOPE_START, by itself, creates a new VSCOPE_START or raises the existing
%      singleton*.
%
%      H = VSCOPE_START returns the handle to a new VSCOPE_START or the handle to
%      the existing singleton*.
%
%      VSCOPE_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VSCOPE_START.M with the given input arguments.
%
%      VSCOPE_START('Property','Value',...) creates a new VSCOPE_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VScope_start_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VScope_start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VScope_start

% Last Modified by GUIDE v2.5 19-Jan-2008 23:51:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VScope_start_OpeningFcn, ...
                   'gui_OutputFcn',  @VScope_start_OutputFcn, ...
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


% --- Executes just before VScope_start is made visible.
function VScope_start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VScope_start (see VARARGIN)

% Choose default command line output for VScope_start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VScope_start wait for user response (see UIRESUME)
% uiwait(handles.figure1);

im=imread('osc.jpg');
axis(handles.axes1);
imshow(im);
axis off;


% --- Outputs from this function are returned to the command line.
function varargout = VScope_start_OutputFcn(hObject, eventdata, handles) 
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

set(handles.text3,'string','Initializing.....Please Wait');
pause(2)
set(handles.text3,'string',' ');
query
close('VScope_start');




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('VScope_start');


