function varargout = HoughObject(varargin)
% HOUGHOBJECT M-file for HoughObject.fig
%      HOUGHOBJECT, by itself, creates a new HOUGHOBJECT or raises the existing
%      singleton*.
%
%      H = HOUGHOBJECT returns the handle to a new HOUGHOBJECT or the handle to
%      the existing singleton*.
%
%      HOUGHOBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOUGHOBJECT.M with the given input arguments.
%
%      HOUGHOBJECT('Property','Value',...) creates a new HOUGHOBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HoughObject_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HoughObject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HoughObject

% Last Modified by GUIDE v2.5 07-Dec-2005 20:15:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HoughObject_OpeningFcn, ...
                   'gui_OutputFcn',  @HoughObject_OutputFcn, ...
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


% --- Executes just before HoughObject is made visible.
function HoughObject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HoughObject (see VARARGIN)

% Choose default command line output for HoughObject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HoughObject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HoughObject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbGenerate.
function pbGenerate_Callback(hObject, eventdata, handles)
% hObject    handle to pbGenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load ObjectTemplate
S1 = zeros(180,180);
Str = {'Sq','Sc','St'};

a = 1; b = 3;
x = round(a + (b-a) * rand(1));
S2 = eval(Str{x});

a = 1; b = 90;
x = round(a + (b-a) * rand(1));
S3 = imrotate(S2,x);

S = S1;
sz = size(S3);

a = 1; b = min(sz);
x = round(a + (b-a) * rand(1));


S(x:sz(1)+x-1,x:sz(2)+x-1)=S3;
S = im2bw(S);
axes(handles.axes1);

imshow(S);
title('Original Image');
handles.S = S;
guidata(hObject, handles);


% --- Executes on button press in pnHough.
function pnHough_Callback(hObject, eventdata, handles)
% hObject    handle to pnHough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.S;
[H, theta,rho]=hough(S);
axes(handles.axes2);
imshow(H,[],'xdata',theta,'ydata',rho);
xlabel('\theta'),ylabel('\rho')
axis on, axis normal;
title('Hough Matrix');

clear data;
for cnt = 1:max(max(H))
    data(cnt) = sum(sum(H == cnt));
end
axes(handles.axes3);
%data(data==0)=NaN;
plot(data,'--x');
xlabel('Hough Matrix Intensity'),ylabel('Counts')
handles.data = data;
guidata(hObject, handles);

% --- Executes on button press in pbDetect.
function pbDetect_Callback(hObject, eventdata, handles)
% hObject    handle to pbDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
[maxval,maxind] = max(data);
medval = median(data);

[p]=polyfit(1:maxind-5,data(1:maxind-5),2);

if maxval<3*medval
    set(handles.txtResult,'string','Triangle');
elseif  p(3)>100
    set(handles.txtResult,'string','Square');
else
    set(handles.txtResult,'string','Round'); 
end








% --- Executes on button press in pbInfo.
function pbInfo_Callback(hObject, eventdata, handles)
% hObject    handle to pbInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://basic-eng.blogspot.com', '-browser');

