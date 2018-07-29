function varargout = myloadnii3(varargin)
% MYLOADNII3 MATLAB code for myloadnii3.fig
%      MYLOADNII3, by itself, creates a new MYLOADNII3 or raises the existing
%      singleton*.
%
%      H = MYLOADNII3 returns the handle to a new MYLOADNII3 or the handle to
%      the existing singleton*.
%
%      MYLOADNII3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYLOADNII3.M with the given input arguments.
%
%      MYLOADNII3('Property','Value',...) creates a new MYLOADNII3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myloadnii3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myloadnii3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myloadnii3

% Last Modified by GUIDE v2.5 07-Apr-2012 12:55:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myloadnii3_OpeningFcn, ...
                   'gui_OutputFcn',  @myloadnii3_OutputFcn, ...
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


% --- Executes just before myloadnii3 is made visible.
function myloadnii3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myloadnii3 (see VARARGIN)

% Choose default command line output for myloadnii3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myloadnii3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myloadnii3_OutputFcn(hObject, eventdata, handles) 
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
global gg gc;

h=guidata(gcbo);
% set(h.message_text,'String','');  % Clear Messages
gg=gg+2;
h.image_filename=1;
h.image_pathname=1;
[filename, pathname] = uigetfile({'*.nii'},'Pick a file'); % Load Image file and path names
    if filename~=0
        gg=1;
        h.gg=1;
        h.image_filename=filename;  % Image file name
        h.image_pathname=pathname;  % Image path name
%         set(h.Showaxes,'visible','off');
        axes(h.axes1);
%         set(h.figure1_title,'Visible','on');
%         image_1=imread([pathname filename]); % Load Image
        image_1=load_untouch_nii([pathname filename]); % Load Image
%         image_1=load_nii([pathname filename]); % Load Image
        imshow(image_1.img(:,:,10),[]);                     % Show Loaded Image
        h.image_1=image_1;
        guidata(gcbo,h);
    end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=guidata(gcbo);
image_1 = h.image_1;
slice_no = str2num(get(h.edit1,'String'))+1;
set(h.edit1,'String',num2str(slice_no));
        axes(h.axes1);
%         set(h.figure1_title,'Visible','on');
%         image_1=imread([pathname filename]); % Load Image
        imshow(image_1.img(:,:,slice_no),[]);                     % Show Loaded Image
        h.image_1=image_1;
        guidata(gcbo,h);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=guidata(gcbo);
image_1 = h.image_1;
slice_no = str2num(get(h.edit1,'String'));
slice_no = slice_no - 1 ;
set(h.edit1,'String',num2str(slice_no));
        axes(h.axes1);
%         set(h.figure1_title,'Visible','on');
%         image_1=imread([pathname filename]); % Load Image
        imshow(image_1.img(:,:,slice_no),[]);                     % Show Loaded Image
        h.image_1=image_1;
        guidata(gcbo,h);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=guidata(gcbo);
image_1 = h.image_1;
slice_no = str2num(get(h.edit1,'String'));
% slices = h.slices;
figure,imshow(image_1.img(:,:,slice_no),[])


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=guidata(gcbo);
image_1 = h.image_1;
% image_2 = image_1.img;
for i = 1:size(image_1.img,3)
    image_1.img(:,:,i) = imrotate(image_1.img(:,:,i),90);
end
    h.image_1.img = image_1.img;
        axes(h.axes1);
%         set(h.figure1_title,'Visible','on');
%         image_1=imread([pathname filename]); % Load Image
slice_no = str2num(get(h.edit1,'String'));
        imshow(image_1.img(:,:,slice_no),[]);                     % Show Loaded Image
        h.image_1=image_1;
        guidata(gcbo,h);
