function varargout = welcome(varargin)
clc;

disp('                     HELLO ;)');
disp('                     @)=--   ')
% WELCOME M-file for welcome.fig
%      WELCOME, by itself, creates a new WELCOME or raises the existing
%      singleton*.
%
%      H = WELCOME returns the handle to a new WELCOME or the handle to
%      the existing singleton*.
%
%      WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WELCOME.M with the given input arguments.
%
%      WELCOME('Property','Value',...) creates a new WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before welcome_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to welcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help welcome

% Last Modified by GUIDE v2.5 23-Jan-2008 08:50:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @welcome_OpeningFcn, ...
                   'gui_OutputFcn',  @welcome_OutputFcn, ...
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


% --- Executes just before welcome is made visible.
function welcome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to welcome (see VARARGIN)

% Choose default command line output for welcome
handles.output = hObject;


% printing the top text
t=clock;
if t(4)>1 && t(4)<=12
    temp = 1;
elseif t(4)>12 && t(4)<=15
    temp = 2;
else
    temp = 3;
end
switch temp
    case 1   
     
        set(handles.text1,'string','GOOD MORNING. WELCOME TO THE WORLD OF MATLAB ');
        backgroundImage = importdata('good_morning.jpg');
        %select the axes
        axes(handles.axes1);
        %place image onto the axes
        image(backgroundImage);
        %remove the axis tick marks
        axis off
  
        
    case 2
        set(handles.text1,'string','GOOD AFTERNOON. WELCOME TO THE WORLD OF MATLAB ');
        backgroundImage = importdata('good_afternoon.jpg');
        %select the axes
        axes(handles.axes1);
        %place image onto the axes
        image(backgroundImage);
        %remove the axis tick marks
        axis off 
        
    case 3        
       set(handles.text1,'string','GOOD EVENING. WELCOME TO THE WORLD OF MATLAB ');
       backgroundImage = importdata('good_evening.jpg');
        %select the axes
        axes(handles.axes1);
        %place image onto the axes
        image(backgroundImage);
        %remove the axis tick marks
        axis off  
end
   
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes welcome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = welcome_OutputFcn(hObject, eventdata, handles) 
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
close all;
disp('<a href="matlab:clc">Have a nice Day :)</a>');
     
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simulink
new_system('New','Model');
open_system('New');
close all;

