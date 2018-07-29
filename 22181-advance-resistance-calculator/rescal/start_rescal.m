function varargout = start_rescal(varargin)
% START_RESCAL M-file for start_rescal.fig
%      START_RESCAL, by itself, creates a new START_RESCAL or raises the existing
%      singleton*.
%
%      H = START_RESCAL returns the handle to a new START_RESCAL or the handle to
%      the existing singleton*.
%
%      START_RESCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in START_RESCAL.M with the given input arguments.
%
%      START_RESCAL('Property','Value',...) creates a new START_RESCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before start_rescal_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to start_rescal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help start_rescal

% Last Modified by GUIDE v2.5 12-Nov-2008 20:06:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_rescal_OpeningFcn, ...
                   'gui_OutputFcn',  @start_rescal_OutputFcn, ...
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


% --- Executes just before start_rescal is made visible.
function start_rescal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to start_rescal (see VARARGIN)

% Choose default command line output for start_rescal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes start_rescal wait for user response (see UIRESUME)
% uiwait(handles.figure1);

im=imread('res2.jpg');
axis(handles.axes1);
imshow(im);
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = start_rescal_OutputFcn(hObject, eventdata, handles) 
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

select_rescal
close('start_rescal')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('start_rescal')

