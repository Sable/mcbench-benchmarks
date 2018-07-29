function varargout = sure2(varargin)
% SURE2 M-file for sure2.fig
%      SURE2, by itself, creates a new SURE2 or raises the existing
%      singleton*.
%
%      H = SURE2 returns the handle to a new SURE2 or the handle to
%      the existing singleton*.
%
%      SURE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURE2.M with the given input arguments.
%
%      SURE2('Property','Value',...) creates a new SURE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sure2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sure2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sure2

% Last Modified by GUIDE v2.5 21-Jan-2008 02:39:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sure2_OpeningFcn, ...
                   'gui_OutputFcn',  @sure2_OutputFcn, ...
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


% --- Executes just before sure2 is made visible.
function sure2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sure2 (see VARARGIN)

% Choose default command line output for sure2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sure2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sure2_OutputFcn(hObject, eventdata, handles) 
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

close('VScope');
%close('VAudio')
close('sure2');
%close('VAudio');
close('sure');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close('sure2');


