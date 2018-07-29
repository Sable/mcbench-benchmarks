function varargout = Prepa8(varargin)
% PREPA8 M-file for Prepa8.fig
%      PREPA8, by itself, creates a new PREPA8 or raises the existing
%      singleton*.
%
%      H = PREPA8 returns the handle to a new PREPA8 or the handle to
%      the existing singleton*.
%
%      PREPA8('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPA8.M with the given input arguments.
%
%      PREPA8('Property','Value',...) creates a new PREPA8 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Prepa8_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Prepa8_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Prepa8

% Last Modified by GUIDE v2.5 17-May-2008 16:15:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prepa8_OpeningFcn, ...
                   'gui_OutputFcn',  @Prepa8_OutputFcn, ...
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


% --- Executes just before Prepa8 is made visible.
function Prepa8_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Prepa8 (see VARARGIN)
movegui(hObject,'center');
% Choose default command line output for Prepa8
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Prepa8 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.axes1)
background = imread('blutengelcoverfq1.jpg');
axis off;
imshow(background);

text(70,80,'  ELECTRONICA Y TELECOMUNICACIONES','Fontname','Arial Black','Fontsize',14,'Fontangle','Normal', ...
'Fontweight','Bold','color','RED');

text(70,150,'LABORATORIO DE COMUNICACION DIGITAL','Fontname','Arial Black','Fontsize',14,'Fontangle','Normal', ...
'Fontweight','Bold','color','BLUE');



text(70,650,'              CODIGO DE LINEA 4B/5B','Fontname','Arial Black','Fontsize',14,'Fontangle','Normal', ...
'Fontweight','Bold','color','BLUE');


scrsz = get(0, 'ScreenSize');
pos_act=get(gcf,'Position');
xr=scrsz(3) - pos_act(3);
xp=round(xr/2);
yr=scrsz(4) - pos_act(4);
yp=round(yr/2);
set(gcf,'Position',[xp-515 yp-370 pos_act(3) pos_act(4)]);

% --- Outputs from this function are returned to the command line.
function varargout = Prepa8_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in salir1.
function salir1_Callback(hObject, eventdata, handles)
% hObject    handle to salir1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ans=questdlg('¿Desea salir del programa?','SALIR','Si','No','No');
if strcmp(ans,'No')
    return;
end
clear,clc,close all

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Prepa8,'Visible','off')
set(Prepa81,'Visible','on')


