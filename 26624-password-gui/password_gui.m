function varargout = password_gui(varargin)
% PASSWORD_GUI M-file for password_gui.fig
%      PASSWORD_GUI, by itself, creates a new PASSWORD_GUI or raises the existing
%      singleton*.
%
%      H = PASSWORD_GUI returns the handle to a new PASSWORD_GUI or the handle to
%      the existing singleton*.
%
%      PASSWORD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PASSWORD_GUI.M with the given input arguments.
%
%      PASSWORD_GUI('Property','Value',...) creates a new PASSWORD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before password_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to password_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help password_gui

% Last Modified by GUIDE v2.5 08-Feb-2010 17:59:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @password_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @password_gui_OutputFcn, ...
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


% --- Executes just before password_gui is made visible.
function password_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to password_gui (see VARARGIN)

% Choose default command line output for password_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(gcf, 'visible','off')

% question for password
%c = cell(1)
password='alhambra';
prompt = {'Enter password'};
dlg_title = 'Password';
num_lines = 1;
def = {'????','hsv'};
answer_x = inputdlg(prompt,dlg_title,num_lines,def);
answer_xx=cell2struct(answer_x, 'word',1);
answer=answer_xx.word;

if answer==password
    set(gcf, 'visible','on')
else
    close all
end

% UIWAIT makes password_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = password_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
