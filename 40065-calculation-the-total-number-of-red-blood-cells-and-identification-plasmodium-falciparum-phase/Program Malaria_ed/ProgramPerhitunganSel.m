function varargout = ProgramPerhitunganSel(varargin)
% PROGRAMPERHITUNGANSEL M-file for ProgramPerhitunganSel.fig
%      PROGRAMPERHITUNGANSEL, by itself, creates a new PROGRAMPERHITUNGANSEL or raises the existing
%      singleton*.
%
%      H = PROGRAMPERHITUNGANSEL returns the handle to a new PROGRAMPERHITUNGANSEL or the handle to
%      the existing singleton*.
%
%      PROGRAMPERHITUNGANSEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRAMPERHITUNGANSEL.M with the given input arguments.
%
%      PROGRAMPERHITUNGANSEL('Property','Value',...) creates a new PROGRAMPERHITUNGANSEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProgramPerhitunganSel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProgramPerhitunganSel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProgramPerhitunganSel

% Last Modified by GUIDE v2.5 06-Jul-2012 06:01:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ProgramPerhitunganSel_OpeningFcn, ...
    'gui_OutputFcn',  @ProgramPerhitunganSel_OutputFcn, ...
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


% --- Executes just before ProgramPerhitunganSel is made visible.
function ProgramPerhitunganSel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProgramPerhitunganSel (see VARARGIN)

% Choose default command line output for ProgramPerhitunganSel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProgramPerhitunganSel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProgramPerhitunganSel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Program_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Program_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Info_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Info_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Program_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Program_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(infogram);

% --------------------------------------------------------------------
function Perancang_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Perancang_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(Biodata);

% --------------------------------------------------------------------
function Automatic_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Automatic_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(Otomatis);
close(ProgramPerhitunganSel);

% --------------------------------------------------------------------
function Step_by_step_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Step_by_step_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(HitungSeltotal);
close(ProgramPerhitunganSel);

% --------------------------------------------------------------------
function Exit_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --------------------------------------------------------------------
function Parasit_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Parasit_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(Parasit);

% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
axes(hObject);
imshow('halutama.jpg');

% --------------------------------------------------------------------
function Malaria_Menu_Item_Callback(hObject, eventdata, handles)
% hObject    handle to Malaria_Menu_Item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(Malaria);