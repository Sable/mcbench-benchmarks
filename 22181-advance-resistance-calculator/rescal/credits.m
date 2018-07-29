function varargout = credits(varargin)
% CREDITS M-file for credits.fig
%      CREDITS, by itself, creates a new CREDITS or raises the existing
%      singleton*.
%
%      H = CREDITS returns the handle to a new CREDITS or the handle to
%      the existing singleton*.
%
%      CREDITS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREDITS.M with the given input arguments.
%
%      CREDITS('Property','Value',...) creates a new CREDITS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before credits_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to credits_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help credits

% Last Modified by GUIDE v2.5 12-Nov-2008 20:42:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @credits_OpeningFcn, ...
                   'gui_OutputFcn',  @credits_OutputFcn, ...
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


% --- Executes just before credits is made visible.
function credits_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to credits (see VARARGIN)

% Choose default command line output for credits
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes credits wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = credits_OutputFcn(hObject, eventdata, handles) 
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

close('credits')
