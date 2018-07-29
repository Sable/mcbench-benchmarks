function varargout = houghGUI(varargin)
% HOUGHGUI M-file for houghGUI.fig
%      HOUGHGUI, by itself, creates a new HOUGHGUI or raises the existing
%      singleton*.
%
%      H = HOUGHGUI returns the handle to a new HOUGHGUI or the handle to
%      the existing singleton*.
%
%      HOUGHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOUGHGUI.M with the given input arguments.
%
%      HOUGHGUI('Property','Value',...) creates a new HOUGHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before houghGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to houghGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help houghGUI

% Last Modified by GUIDE v2.5 06-Feb-2006 21:15:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @houghGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @houghGUI_OutputFcn, ...
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


% --- Executes just before houghGUI is made visible.
function houghGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to houghGUI (see VARARGIN)

% Choose default command line output for houghGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes houghGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = houghGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbLoad.
function pbLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.tif'});
S = imread([pathname filename]);
handles.S = S;
axes(handles.axes1);
imshow(S);
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pbDetect.
function pbDetect_Callback(hObject, eventdata, handles)
% hObject    handle to pbDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Reading image 
I = handles.S;
I =im2bw(I);
[y,x]=find(I);
[sy,sx]=size(I);

% 2. Find all the require information for the transformatin. the 'totalpix'
% is the numbers of '1' in the image, while the 'maxrho' is used to find
% the size of the Hough Matrix
totalpix = length(x);

% 3. Preallocate memory for the Hough Matrix. Try to play around with the
% R, or the radius to see the different results.
HM = zeros(sy*sx,1);
R = get(handles.sldR,'value');
R2 = R^2;

% 4. Performing Hough Transform. Notice that no "for-loop" in this portion
% of code.

%%
% a. Preparing all the matrices for the computation without "for-loop"
b = 1:sy;
a = zeros(sy,totalpix);

y = repmat(y',[sy,1]);
x = repmat(x',[sy,1]);

b1 = repmat(b',[1,totalpix]);
b2 = b1;
%%
% b. The equation for the circle
a1 = (round(x - sqrt(R2 - (y - b1).^2)));
a2 = (round(x + sqrt(R2 - (y - b2).^2)));

%%
% c. Removing all the invalid value in matrices a and b
b1 = b1(imag(a1)==0 & a1>0 & a1<sx);
a1 = a1(imag(a1)==0 & a1>0 & a1<sx);
b2 = b2(imag(a2)==0 & a2>0 & a2<sx);
a2 = a2(imag(a2)==0 & a2>0 & a2<sx);

ind1 = sub2ind([sy,sx],b1,a1);
ind2 = sub2ind([sy,sx],b2,a2);

ind = [ind1; ind2];

%%
% d. Reconstruct the Hough Matrix
val = ones(length(ind),1);
data=accumarray(ind,val);
HM(1:length(data)) = data;
HM2 = reshape(HM,[sy,sx]);

% 5. Showing the Hough Matrix
axes(handles.axes2);
imshow(HM2,[]);

%%
% 6. Finding the location of the circle with radius of R
[maxval, maxind] = max(max(HM2));
[B,A] = find(HM2==maxval);
axes(handles.axes3);
imshow(I); hold on;
plot(mean(A),mean(B),'xr')

t = 0:pi/20:2*pi;
xdata = (mean(A)+get(handles.sldR,'value').*cos(t))';
ydata = (mean(B)+get(handles.sldR,'value').*sin(t))';
plot(xdata,ydata);


set(handles.txtX,'string',mean(A));
set(handles.txtY,'string',mean(B));
set(handles.txtVal,'string',maxval);

% --- Executes on slider movement.
function sldR_Callback(hObject, eventdata, handles)
% hObject    handle to sldR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.txtR,'string',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function sldR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function txtX_Callback(hObject, eventdata, handles)
% hObject    handle to txtX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtX as text
%        str2double(get(hObject,'String')) returns contents of txtX as a double


% --- Executes during object creation, after setting all properties.
function txtX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtY_Callback(hObject, eventdata, handles)
% hObject    handle to txtY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtY as text
%        str2double(get(hObject,'String')) returns contents of txtY as a double


% --- Executes during object creation, after setting all properties.
function txtY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtVal_Callback(hObject, eventdata, handles)
% hObject    handle to txtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVal as text
%        str2double(get(hObject,'String')) returns contents of txtVal as a double


% --- Executes during object creation, after setting all properties.
function txtVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on button press in pbInfo.
function pbInfo_Callback(hObject, eventdata, handles)
% hObject    handle to pbInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('http://basic-eng.blogspot.com/','-browser');
