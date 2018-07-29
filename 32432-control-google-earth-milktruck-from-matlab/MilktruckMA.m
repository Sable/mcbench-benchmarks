function varargout = MilktruckMA(varargin)
% MILKTRUCKMA M-file for MilktruckMA.fig
%      MILKTRUCKMA, by itself, creates a new MILKTRUCKMA or raises the existing
%      singleton*.
%
%      H = MILKTRUCKMA returns the handle to a new MILKTRUCKMA or the handle to
%      the existing singleton*.
%
%      MILKTRUCKMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MILKTRUCKMA.M with the given input arguments.
%
%      MILKTRUCKMA('Property','Value',...) creates a new MILKTRUCKMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MilktruckMA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MilktruckMA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MilktruckMA

% Last Modified by GUIDE v2.5 04-Aug-2011 10:22:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MilktruckMA_OpeningFcn, ...
                   'gui_OutputFcn',  @MilktruckMA_OutputFcn, ...
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


% --- Executes just before MilktruckMA is made visible.
function MilktruckMA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MilktruckMA (see VARARGIN)


% Open ActiveX-Control from Microsoft-Internet-Explorer
handles.ie = actxcontrol('Shell.Explorer.2',[2 2 1196 670 ]);
% Navigate to Milktruck
Navigate(handles.ie,'http://earth-api-samples.googlecode.com/svn/trunk/demos/milktruck/index.html'); 
% Wait for initialising
pause(4);   % if pause is too short so that Matlab produce error, take a little more time
% Get the Document
handles.myDoc = handles.ie.Document;

%Define jbuttons for gas, left, right and reverse,
handles.jb_p2 = uicomponent('style','JButton', 'position', [850,790,60,20], 'Text', 'gas',      'MousePressedCallback',{@mouse_pressed, handles}, 'MouseReleasedCallback',{@mouse_released, handles} );
handles.jb_p3 = uicomponent('style','JButton', 'position', [800,755,60,20], 'Text', 'left',     'MousePressedCallback',{@mouse_pressed, handles}, 'MouseReleasedCallback',{@mouse_released, handles});
handles.jb_p4 = uicomponent('style','JButton', 'position', [900,755,60,20], 'Text', 'right',    'MousePressedCallback',{@mouse_pressed, handles}, 'MouseReleasedCallback',{@mouse_released, handles});
handles.jb_p5 = uicomponent('style','JButton', 'position', [850,720,65,20], 'Text', 'reverse',  'MousePressedCallback',{@mouse_pressed, handles}, 'MouseReleasedCallback',{@mouse_released, handles});

% Choose default command line output for MilktruckMA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MilktruckMA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MilktruckMA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Th'Plex
handles.myDoc.parentWindow.execScript('truck.teleportTo(37.423501,-122.086744,90)', 'Jscript');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% San Franciso
handles.myDoc.parentWindow.execScript('doGeocode(''San Francisco'')', 'Jscript');

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Whistler
handles.myDoc.parentWindow.execScript('truck.teleportTo(50.085734,-122.855824,220)', 'Jscript');


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Pismo
handles.myDoc.parentWindow.execScript('truck.teleportTo(35.040675,-120.629513,170)', 'Jscript');


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Tokyo:
handles.myDoc.parentWindow.execScript('truck.teleportTo(35.668607,139.822026,180)', 'Jscript');

 


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Everest
handles.myDoc.parentWindow.execScript('truck.teleportTo(27.991283,86.924340,70)', 'Jscript');



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
location = get(handles.edit2,'String');
handles.myDoc.parentWindow.execScript(['doGeocode(''', location, ''')'],'Jscript');




function mouse_pressed(hObject, eventdata, handles)
% Callback for MousePressed on Button
switch hObject.Text
    case 'gas'
        handles.myDoc.parentWindow.execScript('gasButtonDown=true', 'Jscript');
    case 'left'
        handles.myDoc.parentWindow.execScript('leftButtonDown=true', 'Jscript');    
    case 'right'
        handles.myDoc.parentWindow.execScript('rightButtonDown=true', 'Jscript');     
    case 'reverse'
        handles.myDoc.parentWindow.execScript('reverseButtonDown=true', 'Jscript');         
        
end;



function mouse_released(hObject, eventdata, handles)
% Callback for MouseReleased on Button
switch hObject.Text
    case 'gas'
        handles.myDoc.parentWindow.execScript('gasButtonDown=false', 'Jscript');
    case 'left'
        handles.myDoc.parentWindow.execScript('leftButtonDown=false', 'Jscript');    
    case 'right'
        handles.myDoc.parentWindow.execScript('rightButtonDown=false', 'Jscript');     
    case 'reverse'
        handles.myDoc.parentWindow.execScript('reverseButtonDown=false', 'Jscript');         
        
end;
