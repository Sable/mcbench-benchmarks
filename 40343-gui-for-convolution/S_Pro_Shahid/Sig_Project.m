function varargout = Sig_Project(varargin)
% SIG_PROJECT M-file for Sig_Project.fig
%      SIG_PROJECT, by itself, creates a new SIG_PROJECT or raises the existing
%      singleton*.
%
%      H = SIG_PROJECT returns the handle to a new SIG_PROJECT or the handle to
%      the existing singleton*.
%
%      SIG_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIG_PROJECT.M with the given input arguments.
%
%      SIG_PROJECT('Property','Value',...) creates a new SIG_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sig_Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sig_Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE'ol Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sig_Project

% Last Modified by GUIDE v2.5 10-May-2012 02:10:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sig_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Sig_Project_OutputFcn, ...
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


% --- Executes just before Sig_Project is made visible.
function Sig_Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sig_Project (see VARARGIN)

% Choose default command line output for Sig_Project
handles.output = hObject;

X=imread('iiui.jpg');
imshow(X,'parent',handles.iiui)
OL_Callback(hObject, eventdata, handles)
con_Callback(hObject, eventdata, handles)
set(handles.date,'String',date)
%[x f]=wavread('background.wav');
%soundsc(x,f)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sig_Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sig_Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;



function xt_Callback(hObject, eventdata, handles)
% hObject    handle to xt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xt as text
%        str2double(get(hObject,'String')) returns contents of xt as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function xt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ht_Callback(hObject, eventdata, handles)
% hObject    handle to ht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ht as text
%        str2double(get(hObject,'String')) returns contents of ht as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ht_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txmin_Callback(hObject, eventdata, handles)
% hObject    handle to txmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txmin as text
%        str2double(get(hObject,'String')) returns contents of txmin as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function txmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txmax_Callback(hObject, eventdata, handles)
% hObject    handle to txmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txmax as text
%        str2double(get(hObject,'String')) returns contents of txmax as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function txmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thmin_Callback(hObject, eventdata, handles)
% hObject    handle to thmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thmin as text
%        str2double(get(hObject,'String')) returns contents of thmin as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function thmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thmax_Callback(hObject, eventdata, handles)
% hObject    handle to thmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thmax as text
%        str2double(get(hObject,'String')) returns contents of thmax as a double
con_Callback(hObject, eventdata, handles)
OL_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function thmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in con.
function con_Callback(hObject, eventdata, handles)
% hObject    handle to con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inc 
colordef black
axis(handles.xx);
inc=0.100;
global ax bx ah bh yx yh yy m
ax=eval(get(handles.txmin,'String'));
bx=eval(get(handles.txmax,'String'));
t=ax:inc:bx;
t1=t;
yx=eval(get(handles.xt,'String'));
plot(handles.xx,t,yx)
grid(handles.xx,'on')

%axis(handles.hh)
ah=eval(get(handles.thmin,'String'));
bh=eval(get(handles.thmax,'String'));
t=ah:inc:bh;
t2=t;
yh=eval(get(handles.ht,'String'));
plot(handles.hh,t,yh)
grid(handles.hh,'on')

%axis(handles.yy1)
%a=ax+ah;
%b=bx+bh;
%m=a:inc:b;
%yy=conv(yx,yh);
[yy m]=convolution_c(yx,t1,yh,t2,inc);
%length(m)
%length(yy)
plot(handles.yy1,m,yy)
grid(handles.yy1,'on')

% --- Executes on slider movement.
function SLDR_Callback(hObject, eventdata, handles)
% hObject    handle to SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
FL_Callback(hObject, eventdata, handles)
global tx_ x_ th_ h_ ax bx ah bh
set(handles.SI,'String',num2str(ax+ah))
set(handles.SM,'String',num2str(bx+bh))
set(handles.SLDR,'Min' ,ax+ah,'Max',bx+bh)
V=get(handles.SLDR,'Value');
set(handles.SV,'String',V)
th_1=th_+V;
X=plotyy(handles.yy2,tx_,x_,th_1,h_);
axis(X(1),[ax-bh+ah bx+bh-ah min(x_)-0.1 max(x_)+0.1]);
axis(X(2),[ax-bh+ah bx+bh-ah min(h_)-0.1 max(h_)+0.1]);
grid(handles.yy2,'on')


% --- Executes during object creation, after setting all properties.
function SLDR_CreateFcn(hObject, ~, ~)
% hObject    handle to SLDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in OL.
function OL_Callback(hObject, eventdata, handles)
% hObject    handle to OL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
con_Callback(hObject, eventdata, handles)
global ax bx ah bh
colordef black
axis(handles.yy2);
cla(handles.yy2,'reset');
axis off
ax_=get(handles.txmin,'String');
bx_=get(handles.txmax,'String');
ah_=get(handles.thmin,'String');
bh_=get(handles.thmax,'String');
INT1=strcat('y(t) =\int_{',ax_,'}^{','t- ',ah_,'}x(\tau)h(t-\tau)d\tau    ');
if bx-ax <= bh-ah
  INT2=strcat('y(t) =\int_{',ax_,'}^{',bx_,'}x(\tau)h(t-\tau)d\tau         ');
else
  INT2=strcat('y(t) =\int_{',ah_,'}^{',bh_,'}x(\tau)h(t-\tau)d\tau         ');
end
 INT3=strcat('y(t) =\int_{','t- ',bh_,'}^{',bx_,'}x(\tau)h(t-\tau)d\tau      ');
    A=strcat(' t <',num2str(ax+ah));
%text(0.2,0.8,...
%'\fontsize{16}y(t)=x(t)*h(t)=\int_{-\infty}^{+\infty}x(\tau)h(t-\tau)d\tau ')
text(0.2,0.9,['\fontsize{14}y(t)=0                   ' A])
B=num2str(ax+bh);
C=num2str(bx+ah);
D=strcat(' t >',num2str(bx+bh));
if ax+bh<ah+bx % B<C
text(0.2,0.7,...
['\fontsize{14}' INT1 '   ' num2str(ax+ah) '\leqt<' B])
text(0.2,0.5,...
['\fontsize{14}' INT2 '   ' B '\leqt\leq ' C])
text(0.2,0.3,...
['\fontsize{14}' INT3 '   ' C '< t\leq ' num2str(bx+bh)])
end
if ax+bh>ah+bx % B>C
text(0.2,0.7,...
['\fontsize{14}' INT1 '   '   num2str(ax+ah) '\leqt<' C])
text(0.2,0.5,...
['\fontsize{14}' INT2 '   '  C '\leqt\leq' B])
text(0.2,0.3,...
['\fontsize{14}' INT3 '   '  B '< t\leq ' num2str(bx+bh)])
end
if (ax+bh)==(ah+bx)% B=C
text(0.2,0.7,...
['\fontsize{14}' INT1 '   '  num2str(ax+ah) '\leqt<  ' C])
text(0.2,0.5,...
['\fontsize{14}'  INT2  '      t=' C])
text(0.2,0.3,...
['\fontsize{14}' INT3 '   '  B '< t\leq ' num2str(bx+bh)])    
end
 text(0.2,0.1,['\fontsize{14}y(t)=0                  ' D])

% --- Executes on button press in FL.
function FL_Callback(hObject, eventdata, handles)
% hObject    handle to FL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colordef black
con_Callback(hObject, eventdata, handles)
global ax bx ah bh inc 
t=ax:inc:bx;
global tx_ x_ th_ h_
tx_=t;
x_=eval(get(handles.xt,'String'));
t=ah:inc:bh;
h_=eval(get(handles.ht,'String'));
t=-fliplr(t);
th_=t;
h_=fliplr(h_);
plotyy(handles.yy2,tx_,x_,th_,h_)
grid(handles.yy2,'on')
%set(handles.yy2,'Xlim',[ax bx+bh])
%set(handles.yy2,'Xlim',[2*(ax+ah) 2*(bx+bh)])

% --- Executes on button press in Animate.
function Animate_Callback(hObject, eventdata, handles)
% hObject    handle to Animate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

con_Callback(hObject, eventdata, handles)
global ax ah bx bh inc yy m
a=ax+ah;
b=bx+bh;
k=0;
%pause on
for i=a:inc:b
%axes(handles.yy1)
k=k+1;
plot(handles.yy1,m,yy,i,yy(k),'d')
grid(handles.yy1,'on')
set(handles.SLDR,'Value',i);
pause(0.1)
SLDR_Callback(hObject, eventdata, handles)
end
%pause off

% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Help:','COVOLVE: For convolution results',...
         'OL: For Overlapping Regions',' FL: For Flip Version of signal',...
         'Animate:For Animating convolution overlapping'},'GUI HELP')
pause(1)
winopen('PROJECT REPORT_.docx')

function SV_Callback(hObject, eventdata, handles)
% hObject    handle to SV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SV as text
%        str2double(get(hObject,'String')) returns contents of SV as a double
con_Callback(hObject, eventdata, handles)
S_V=eval(get(handles.SV,'String')); 
global ax bx ah bh
S=strcat('Min:  ',num2str(ax+ah),'  Max:  ',num2str(bx+bh));
if ax+ah>S_V ||bx+bh<S_V
errordlg({'Please Set The Value of Slider Within limits.',S},'Slider Value Error')
return
end
set(handles.SLDR,'Value' ,eval(get(handles.SV,'String')))
SLDR_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function SV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in discrete.
function discrete_Callback(hObject, eventdata, handles)
% hObject    handle to discrete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh 
Sig_Project_Disc


% --- Executes on button press in mfile.
function mfile_Callback(~, ~, ~)
% hObject    handle to mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit Sig_Project
