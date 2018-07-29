function varargout = Imagesegmentation(varargin)
%% Written by ABIOYE SAMSON D.
% Email Address: samsung4christ@yahoo.com
% Phone No: +2348068724645
%%
% IMAGESEGMENTATION M-file for Imagesegmentation.fig
%      IMAGESEGMENTATION, by itself, creates a new IMAGESEGMENTATION or raises the existing
%      singleton*.
%
%      H = IMAGESEGMENTATION returns the handle to a new IMAGESEGMENTATION or the handle to
%      the existing singleton*.
%
%      IMAGESEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGESEGMENTATION.M with the given input arguments.
%
%      IMAGESEGMENTATION('Property','Value',...) creates a new IMAGESEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Imagesegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Imagesegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Imagesegmentation

% Last Modified by GUIDE v2.5 27-Sep-2010 21:29:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Imagesegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @Imagesegmentation_OutputFcn, ...
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


% --- Executes just before Imagesegmentation is made visible.
function Imagesegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Imagesegmentation (see VARARGIN)

% Choose default command line output for Imagesegmentation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Imagesegmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Imagesegmentation_OutputFcn(hObject, eventdata, handles) 
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
[filename path] = uigetfile('*.bmp;*.jpg;*.tif;','Open input image');
if filename~=0 
    file = [path filename];
    orignalimg = imread(file);
    axes(handles.axes1);
    imshow(real(orignalimg));
else
    warndlg('Input image must be selected.','Warning');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
j=getImage(handles.axes1);
jr=imresize(j,[512 512]);
jg=rgb2gray(jr);
h=histeq(jg);
b=qtdecomp(h,.1);
s=full(b);
blocks=repmat(double(0),size(s));
for dim=[512 256 128 64 32 16 8 4 2 1];
numblocks=length(find(s==dim));
if (numblocks > 0)
values = repmat(double(1),[dim dim numblocks]);
values(2:dim,2:dim,:)=0;
blocks=qtsetblk(blocks,s,dim,values);
end
end
blocks(end,1:end)=1;
blocks(1:end,end)=1;
f=(blocks());
axes(handles.axes2);
imshow(f)




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uisave()


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit = questdlg('Are you sure you want to Exit now','Exit','Yes','No','');
switch exit
    case 'Yes'
        delete(gcf)
    case 'No'
        return
end


% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
