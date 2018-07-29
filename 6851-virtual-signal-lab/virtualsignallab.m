function varargout = virtualsignallab(varargin)
global choice
% VIRTUALSIGNALLAB M-file for virtualsignallab.fig
%      VIRTUALSIGNALLAB, by itself, creates a new VIRTUALSIGNALLAB or raises the existing
%      singleton*.
%
%      H = VIRTUALSIGNALLAB returns the handle to a new VIRTUALSIGNALLAB or the handle to
%      the existing singleton*.
%
%      VIRTUALSIGNALLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIRTUALSIGNALLAB.M with the given input arguments.
%
%      VIRTUALSIGNALLAB('Property','Value',...) creates a new VIRTUALSIGNALLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before virtualsignallab_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to virtualsignallab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help virtualsignallab
% Last Modified by GUIDE v2.5 02-Feb-2005 16:15:56
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @virtualsignallab_OpeningFcn, ...
                   'gui_OutputFcn',  @virtualsignallab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
% --- Executes just before virtualsignallab is made visible.
function virtualsignallab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to virtualsignallab (see VARARGIN)
% Choose default command line output for virtualsignallab
load train;
tr=y;
handles.tr=tr;
load handel;
ha=y;
handles.ha=ha;
load laughter;
la=y;
handles.la=la;
load chirp;
ch=y;
handles.ch=ch;
d=size(handles.tr,1);
h_f=findobj(0,'tag','Fs');
m=get(h_f,'string');
n=str2num(m);
handles.n=n;
handles.x=0;
handles.y=0;
handles.current_data=0;
handles.col='  blanc   ';
handles.dia=' no domain ';
handles.string=' no ';
choice=[1 1 1]
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes virtualsignallab wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = virtualsignallab_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes during object creation, after setting all properties.
function soundmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soundmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on selection change in soundmenu.
function soundmenu_Callback(hObject, eventdata, handles)
val=get(hObject,'value');
str=get(hObject,'string');
switch str{val}   
    case 'please select'
        errordlg('you must select a field entery','bad input','modal');
    case 'train'
        handles.current_data=handles.tr;
        handles.string='train';
    case 'handel'
        handles.current_data=handles.ha;
        handles.string='handel';
    case 'laughter'
         handles.current_data=handles.la;
         handles.string='laughter';
    case 'chirp'
        handles.current_data=handles.ch;
        handles.string='chirp';
    otherwise   
    handles.current_data=0;
end
    guidata(hObject,handles);
% hObject    handle to soundmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns soundmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        soundmenu
% --- Executes during object creation, after setting all properties.
function diagrammenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diagrammenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on selection change in diagrammenu.
function diagrammenu_Callback(hObject, eventdata, handles)
% hObject    handle to diagrammenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns diagrammenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        diagrammenu
n=handles.n;
val=get(hObject,'value');
str=get(hObject,'string');
switch str{val}   
    case 'please select' 
        y=handles.current_data;
        x=0;
        errordlg('you must select a field entery','bad input','modal');  
    case 'time domain'
      y=handles.current_data; 
      d=size(y,1);
      T=d/n;
      x=linspace(0,T,d);
      handles.dia='time domain';
    case 'spectrum'
      y=handles.current_data;
      d=size(y,1);
      q=1/d*fft(y);
      real=abs(q);
      y=fftshift(real);
      x=linspace(-n/2,n/2,d);
       handles.dia='frequency domain';
    case 'periodogram'
      y=handles.current_data;
      d=size(y,1);
      q=1/d*fft(y);
      real=abs(q);
      y=fftshift(real.^2);
      x=linspace(-n/2,n/2,d);
       handles.dia='frequency domain';
  otherwise
      y=handles.current_data;
      x=0;
end
      handles.y=y;
      handles.x=x;
     guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function colormenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on selection change in colormenu.
function colormenu_Callback(hObject, eventdata, handles)
global choice;
h_c=findobj(0,'tag','colormenu');
val=get(h_c,'value');
str=get(h_c,'string');
switch str{val}   
    case 'please select'
        errordlg('you must select a field entery','bad input','modal');
    case 'blue'
        choice=[0 0 1];
        handles.col='blue';
    case 'red'
        choice=[1 0 0];
        handles.col='red';
    case 'green'
        choice=[0 1 0];
        handles.col='green';
    otherwise
        choice=[1 1 1];
end
guidata(hObject,handles);
% hObject    handle to colormenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns colormenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        colormenu
% --- Executes on button press in mute.
function mute_Callback(hObject, eventdata, handles)
% hObject    handle to mute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mute
% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of play
% --- Executes during object creation, after setting all properties.
sound(handles.current_data,handles.n);
guidata(hObject,handles);
function Fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function Fs_Callback(hObject, eventdata, handles)
h_f=findobj(0,'tag','Fs');
m=get(h_f,'string');
n=str2num(m);
handles.n=n;
guidata(hObject,handles);
% hObject    handle to Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Fs as text
%        str2double(get(hObject,'String')) returns contents of Fs as a
%        double
% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
global choice
x=handles.x;
y=handles.y;
h_p=plot(x,y);
title([' A plot of the  ',handles.string,' signal with the  ',handles.dia,' in ',handles.col ,'color']); 
set(h_p,'color',choice);
sro=findobj(0,'tag','soundmenu');
set(sro,'value',1);
sra=findobj(0,'tag','diagrammenu');
set(sra,'value',1);
srb=findobj(0,'tag','colormenu');
set(srb,'value',1);
guidata(hObject,handles);
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in PLAY.