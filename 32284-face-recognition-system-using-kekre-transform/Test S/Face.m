function varargout = Face(varargin)
% FACE M-file for Face.fig
%      FACE, by itself, creates a new FACE or raises the existing
%      singleton*.
%
%      H = FACE returns the handle to a new FACE or the handle to
%      the existing singleton*.
%
%      FACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACE.M with the given input arguments.
%
%      FACE('Property','Value',...) creates a new FACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Face_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Face_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Face

% Last Modified by GUIDE v2.5 23-Apr-2011 23:15:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Face_OpeningFcn, ...
                   'gui_OutputFcn',  @Face_OutputFcn, ...
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


% --- Executes just before Face is made visible.
function Face_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Face (see VARARGIN)

% Choose default command line output for Face
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Face wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Face_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inf.
function inf_Callback(~, ~, ~)
% hObject    handle to inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter the name of the image to be selected :'};
dlg_title = 'Image Name';
num_lines= 1;
def = {''};
H=inputdlg(prompt,dlg_title,num_lines,def);
setappdata(0,'H_pass',H);

% --- Executes on button press in dsf.
function dsf_Callback(~, ~, ~)
% hObject    handle to dsf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
olc1();

% --- Executes on button press in vtb.
function vtb_Callback(~, ~, ~)
% hObject    handle to vtb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Click on the folder saved by the name Test S');
pause(2);
TP1 = uigetdir('C:', 'View Testbase');
winopen(TP1);
% --- Executes on button press in pro.
function pro_Callback(~, ~, ~)
% hObject    handle to pro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hm=getappdata(0,'H_pass');
k0=char(hm);
msgbox('Click on the folder saved by the name Profile');
pause(2);
TP3 = uigetdir('C:', 'View Profile');
ven2=TP3;
ven=strcat(ven2,'\',k0,'.doc');
winopen(ven)


% --- Executes on button press in vdb.
function vdb_Callback(~, ~, ~)
% hObject    handle to vdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Click on the folder saved by the name S');
pause(2);
TP2 = uigetdir('C:', 'View Database');
winopen(TP2);

% --- Executes on button press in help.
function help_Callback(~, ~, ~)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Click on the folder Test S');
pause(2);
TP4 = uigetdir('C:', 'View Help');
pdv=strcat(TP4,'\HELP.txt');
winopen(pdv);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dsf.
