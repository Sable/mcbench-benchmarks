function varargout = facegui(varargin)
% FACEGUI M-file for facegui.fig
%      FACEGUI, by itself, creates a new FACEGUI or raises the existing
%      singleton*.
%
%      H = FACEGUI returns the handle to a new FACEGUI or the handle to
%      the existing singleton*.
%
%      FACEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEGUI.M with the given input arguments.
%
%      FACEGUI('Property','Value',...) creates a new FACEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before facegui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to facegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help facegui

% Last Modified by GUIDE v2.5 15-Feb-2010 13:06:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @facegui_OpeningFcn, ...
                   'gui_OutputFcn',  @facegui_OutputFcn, ...
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


% --- Executes just before facegui is made visible.
function facegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facegui (see VARARGIN)
set(handles.figure1,'Color',[.753 .753 .753])
% Choose default command line output for facegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes facegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = facegui_OutputFcn(hObject, eventdata, handles) 
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
% Test face detection code
closepreview

% delete(INSTRFIND)
%addpath 'F:\pjts\FaceDetection\Matlab Code\bin'
vid=videoinput('winvideo');
preview(vid)
% s=serial('com1');d
% fopen(s)

while 1
    snap=getsnapshot(vid);
    Img = double (rgb2gray(snap));
    Face = FaceDetect('haarcascade_frontalface_alt2.xml',Img);
    if Face==-1
        %         snap(:)=255;
%         axes(handles.axes1);
%         imshow (snap);
        pause(0.005)

        continue
    end

    Rectangle = [Face(1) Face(2); Face(1)+Face(3) Face(2); Face(1)+Face(3) Face(2)+Face(4); Face(1)  Face(2)+Face(4); Face(1) Face(2)];
%          Rectangle  %calculate the threshold and provide a min and max value... for the user..


    %     if (Rectangle(2)-Rectangle(1))>=50 & (Rectangle(8)-Rectangle(7))<=200
   axes(handles.axes1);
   
  imshow (snap);
%     disp('face')
%     pause(.5)
%     truesize;
    hold on;
    plot (Rectangle(:,1), Rectangle(:,2), 'g');
   
    hold off;

    pause(0.005)
  
end
% fclose(s)
delete(vid)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global vid
% closepreview

% delete(INSTRFIND)
%addpath 'F:\pjts\FaceDetection\Matlab Code\bin'
vid=videoinput('winvideo');
preview(vid)
% s=serial('com1');d
% fopen(s)
i1=-1;
j1=-1;
while 1
    snap=getsnapshot(vid);
    Img = double (rgb2gray(snap));
    Face = FaceDetect('haarcascade_frontalface_alt2.xml',Img);
    if Face==-1
        %         snap(:)=255;
         
%         imshow (snap);
        pause(0.005)

        continue
    end

    Rectangle = [Face(1) Face(2); Face(1)+Face(3) Face(2); Face(1)+Face(3) Face(2)+Face(4); Face(1)  Face(2)+Face(4); Face(1) Face(2)];
%          Rectangle  %calculate the threshold and provide a min and max value... for the user..


    %     if (Rectangle(2)-Rectangle(1))>=50 & (Rectangle(8)-Rectangle(7))<=200
 
%     disp('face')
%     pause(.5)
%     truesize;
    i=((Rectangle(6)+Rectangle(8))./2);
    j=((Rectangle(1)+Rectangle(2))./2);
    i1=round(i);
    j1=round(j);
    
      axes(handles.axes1);
   
  imshow (snap);
    hold on;
    plot(i1,j1,'r+:');
    hold off;

    set(handles.cm,'string',j1);
     set(handles.ro,'string',i1);
    pause(0.005)
  
end
% fclose(s)
delete(vid)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
closepreview

delete(vid);


function cm_Callback(hObject, eventdata, handles)
% hObject    handle to cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cm as text
%        str2double(get(hObject,'String')) returns contents of cm as a double


% --- Executes during object creation, after setting all properties.
function cm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ro_Callback(hObject, eventdata, handles)
% hObject    handle to ro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ro as text
%        str2double(get(hObject,'String')) returns contents of ro as a double


% --- Executes during object creation, after setting all properties.
function ro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closepreview
delete(facegui);




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


