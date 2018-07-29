function varargout = dynamicplot(varargin)
% DYNAMICPLOT M-file for dynamicplot.fig
%      DYNAMICPLOT, by itself, creates a new DYNAMICPLOT or raises the existing
%      singleton*.
%
%      H = DYNAMICPLOT returns the handle to a new DYNAMICPLOT or the handle to
%      the existing singleton*.
%
%      DYNAMICPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNAMICPLOT.M with the given input arguments.
%
%      DYNAMICPLOT('Property','Value',...) creates a new DYNAMICPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dynamicplot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dynamicplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help dynamicplot

% Last Modified by GUIDE v2.5 23-Feb-2008 22:44:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dynamicplot_OpeningFcn, ...
                   'gui_OutputFcn',  @dynamicplot_OutputFcn, ...
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


% --- Executes just before dynamicplot is made visible.
function dynamicplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dynamicplot (see VARARGIN)

% Choose default command line output for dynamicplot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dynamicplot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dynamicplot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ..........the following code edited by user

axes(handles.axes1);
sx=0;sy=0;
rx=0.25;ry=0.25;
l=linspace(0,2*pi);
xv=rx*cos(l)'+sx;yv=ry*sin(l)'+sy;
ox=[xv;xv(1)];oy=[yv;yv(1)];
plot(ox,oy)
axis([-1 1 -1 1])
axis square

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% ..........the following code edited by user
r=get(hObject,'Value');
axes(handles.axes1);
sx=0;sy=0;
rx=r;ry=r;
l=linspace(0,2*pi);
xv=rx*cos(l)'+sx;yv=ry*sin(l)'+sy;
ox=[xv;xv(1)];oy=[yv;yv(1)];
plot(ox,oy)
axis([-1 1 -1 1])
axis square
set(handles.edit1,'string',r)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% ..........the following code edited by user
set(hObject,'value',0.25);
set(hObject,'max',1);
set(hObject,'min',0);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% ..........the following code edited by user
n=str2double(get(hObject,'String'));
set(handles.slider1,'value',n)
% set(handles.slider1,'enable','on')

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% ..............the following code edited by user
set(hObject,'string',0.25);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
sx=0;sy=0;
rx=0.25;ry=0.25;
l=linspace(0,2*pi);
xv=rx*cos(l)'+sx;yv=ry*sin(l)'+sy;
ox=[xv;xv(1)];oy=[yv;yv(1)];
plot(ox,oy)
axis([-1 1 -1 1])
set(handles.slider1,'value',.25)
set(handles.edit1,'string',0.25)
axis square
