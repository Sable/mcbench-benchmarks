function varargout = ge_html(varargin)
% GE_HTML M-file for ge_html.fig
%      GE_HTML, by itself, creates a new GE_HTML or raises the existing
%      singleton*.
%
%      H = GE_HTML returns the handle to a new GE_HTML or the handle to
%      the existing singleton*.
%
%      GE_HTML('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GE_HTML.M with the given input arguments.
%
%      GE_HTML('Property','Value',...) creates a new GE_HTML or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ge_html_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ge_html_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ge_html

% Last Modified by GUIDE v2.5 03-Aug-2011 16:39:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ge_html_OpeningFcn, ...
                   'gui_OutputFcn',  @ge_html_OutputFcn, ...
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


% --- Executes just before ge_html is made visible.
function ge_html_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ge_html (see VARARGIN)

% Open ActiveX-Control from Microsoft-Internet-Explorer
handles.ie = actxcontrol('Shell.Explorer.2',[2 2 996 700 ]);

% Choose default command line output for ge_html
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ge_html wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ge_html_OutputFcn(hObject, eventdata, handles) 
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

% Navigate to the html;
% Navigate(handles.ie,'C:\Users\sk\Documents\MATLAB\ge_ma.html'); 

% locate to the ge_ma.html
[FileName,PathName,FilterIndex] = uigetfile('*.html','open GE-html ') ;
if isequal(FileName,0)
   disp('User selected Cancel')
else
   Navigate(handles.ie,[PathName, FileName]);
end;

% Wait for initialising
pause(4);   % if pause is too short so that Matlab produce error, take a little more time

% Get the Document
handles.myDoc = handles.ie.Document;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show/ hide borders
handles.myDoc.parentWindow.execScript('toggleBorders()', 'Jscript');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myDoc.parentWindow.execScript('toggleRotation()', 'Jscript');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myDoc.parentWindow.execScript('toggleNav()', 'Jscript');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myDoc.parentWindow.execScript('toggleRoads()', 'Jscript');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myDoc.parentWindow.execScript('showBuildings()', 'Jscript');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myDoc.parentWindow.execScript('hideBuildings()', 'Jscript');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

searchStr = get(handles.edit1,'String');
handles.myDoc.parentWindow.execScript(['findmyaddress(''',searchStr ,''')' ], 'Jscript');
