% Simple Google Map Loader in MATLAB.
% Programming By: Alireza Fasih
% Email: ar_fasih@yahoo.com
% Key:
% Please, go to below link and then set your IP address in format of 
% (http://xxx.xxx.xxx.xxx) for getting a KEY!
% http://code.google.com/apis/maps/signup.html

function varargout = GoogleMap(varargin)
% GOOGLEMAP M-file for GoogleMap.fig
%      GOOGLEMAP, by itself, creates a new GOOGLEMAP or raises the existing
%      singleton*.
%
%      H = GOOGLEMAP returns the handle to a new GOOGLEMAP or the handle to
%      the existing singleton*.
%
%      GOOGLEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOOGLEMAP.M with the given input arguments.
%
%      GOOGLEMAP('Property','Value',...) creates a new GOOGLEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GoogleMap_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GoogleMap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GoogleMap

% Last Modified by GUIDE v2.5 16-Mar-2008 23:00:23

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;



gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GoogleMap_OpeningFcn, ...
                   'gui_OutputFcn',  @GoogleMap_OutputFcn, ...
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


% --- Executes just before GoogleMap is made visible.
function GoogleMap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GoogleMap (see VARARGIN)

% Choose default command line output for GoogleMap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GoogleMap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GoogleMap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_up.
function btn_up_Callback(hObject, eventdata, handles)
% hObject    handle to btn_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis(handles.axes1);
key=get(handles.edit1,'String');



cx=str2num(get(handles.edit_x,'String'));
cy=str2num(get(handles.edit_y,'String'));
cx=cx+0.1;
set(handles.edit_x,'String',cx);

zoom=int2str(get(handles.slider2,'Value'));

show_map(num2str(cx),num2str(cy),zoom,key);

%address=strcat('http://maps.google.com/staticmap?center=',cx,...
%                                                      ',',cy,...
%                                               '&zoom=',zoom,...
%                                   '&size=512x512&key=',key);
%[I map]=imread(address,'gif');
%RGB=ind2rgb(I,map);
%imshow(RGB);




function show_map(x,y,zoom,key)

address=strcat('http://maps.google.com/staticmap?center=',x,...
                                                      ',',y,...
                                               '&zoom=',zoom,...
                                   '&size=512x512&key=',key);
[I map]=imread(address,'gif');
RGB=ind2rgb(I,map);
imshow(RGB);




% --- Executes on button press in btn_left.
function btn_left_Callback(hObject, eventdata, handles)
% hObject    handle to btn_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis(handles.axes1);
key=get(handles.edit1,'String');



cx=str2num(get(handles.edit_x,'String'));
cy=str2num(get(handles.edit_y,'String'));
cy=cy-0.1;
set(handles.edit_y,'String',cy);

zoom=int2str(get(handles.slider2,'Value'));

show_map(num2str(cx),num2str(cy),zoom,key);





% --- Executes on button press in btn_right.
function btn_right_Callback(hObject, eventdata, handles)
% hObject    handle to btn_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis(handles.axes1);
key=get(handles.edit1,'String');



cx=str2num(get(handles.edit_x,'String'));
cy=str2num(get(handles.edit_y,'String'));
cy=cy+0.1;
set(handles.edit_y,'String',cy);

zoom=int2str(get(handles.slider2,'Value'));

show_map(num2str(cx),num2str(cy),zoom,key);




% --- Executes on button press in btn_down.
function btn_down_Callback(hObject, eventdata, handles)
% hObject    handle to btn_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axis(handles.axes1);
key=get(handles.edit1,'String');



cx=str2num(get(handles.edit_x,'String'));
cy=str2num(get(handles.edit_y,'String'));
cx=cx-0.1;
set(handles.edit_x,'String',cx);

zoom=int2str(get(handles.slider2,'Value'));

show_map(num2str(cx),num2str(cy),zoom,key);




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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axis(handles.axes1);
key=get(handles.edit1,'String');

cx=str2num(get(handles.edit_x,'String'));
cy=str2num(get(handles.edit_y,'String'));

zoom=int2str(get(handles.slider2,'Value'));

show_map(num2str(cx),num2str(cy),zoom,key);






% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y as text
%        str2double(get(hObject,'String')) returns contents of edit_y as a double


% --- Executes during object creation, after setting all properties.
function edit_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in btn_init.
function btn_init_Callback(hObject, eventdata, handles)
% hObject    handle to btn_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

