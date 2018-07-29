function varargout = Sig_Project_Disc(varargin)
% SIG_PROJECT_DISC M-file for Sig_Project_Disc.fig
%      SIG_PROJECT_DISC, by itself, creates a new SIG_PROJECT_DISC or raises the existing
%      singleton*.
%
%      H = SIG_PROJECT_DISC returns the handle to a new SIG_PROJECT_DISC or the handle to
%      the existing singleton*.
%
%      SIG_PROJECT_DISC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIG_PROJECT_DISC.M with the given input arguments.
%
%      SIG_PROJECT_DISC('Property','Value',...) creates a new SIG_PROJECT_DISC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sig_Project_Disc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sig_Project_Disc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE'ol Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sig_Project_Disc

% Last Modified by GUIDE v2.5 10-May-2012 02:13:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sig_Project_Disc_OpeningFcn, ...
                   'gui_OutputFcn',  @Sig_Project_Disc_OutputFcn, ...
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


% --- Executes just before Sig_Project_Disc is made visible.
function Sig_Project_Disc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sig_Project_Disc (see VARARGIN)

% Choose default command line output for Sig_Project_Disc
X=imread('iiui.jpg');
imshow(X,'parent',handles.iiui)
OL_Callback(hObject, eventdata, handles)
con_Callback(hObject, eventdata, handles)
set(handles.date,'String',date)
% [x f]=wavread('background.wav');
% soundsc(x,f)


handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sig_Project_Disc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sig_Project_Disc_OutputFcn(hObject, eventdata, handles) 
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
%        str2double(get(hObject,'String')) returns contents of txmin as a
%        double
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
colordef black
axis(handles.xx);
global ax bx ah bh yx yh yy m
ax=fix(eval(get(handles.txmin,'String')));
bx=fix(eval(get(handles.txmax,'String')));
n=ax:bx;
n1=n;
yx=eval(get(handles.xt,'String'));
stem(handles.xx,n,yx)
grid(handles.xx,'on')

%axes(handles.hh)
ah=fix(eval(get(handles.thmin,'String')));
bh=fix(eval(get(handles.thmax,'String')));
n=ah:bh;
n2=n;
yh=eval(get(handles.ht,'String'));
stem(handles.hh,n,yh)
grid(handles.hh,'on')

%axes(handles.yy1)
%a=ax+ah;
%b=bx+bh;
%n=a:b;
[yy m]=convolution_(yx,n1,yh,n2);
stem(handles.yy1,m,yy)
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
set(handles.SV,'String',fix(V))
th_1=th_+V;
stem(handles.yy2,tx_,x_)
hold on
stem(handles.yy2,th_1,h_+1,'r')
hold off
grid(handles.yy2,'on')


% --- Executes during object creation, after setting all properties.
function SLDR_CreateFcn(hObject, eventdata, handles)
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
colordef black
axis(handles.yy2);
cla(handles.yy2,'reset');
axis off
global ax bx ah bh
ax_=num2str(ax);
bx_=num2str(bx);
ah_=num2str(ah);
bh_=num2str(bh);
INT1=strcat('y[n] =\Sigma_{',ax_,'}^{','n- ',ah_,'}x[k]h[n-k]   ');
if bx-ax <= bh-ah
  INT2=strcat('y[n] =\Sigma_{',ax_,'}^{',bx_,'}x[k]h[n-k]    ');
else
  INT2=strcat('y[n] =\Sigma_{',ah_,'}^{',bh_,'}x[k]h[n-k]   ');
end
 INT3=strcat('y[n] =\Sigma_{','n- ',bh_,'}^{',bx_,'}x[k]h[n-k]   ');
A=strcat(' n <',num2str(ax+ah));
%text(0.2,0.8,'\fontsize{16}y[n]=x[n]*h[n]=\Sigma_{k=-\infty}^{k=+\infty}x(k)h(n-k)')
text(0.2,0.9,['\fontsize{14}y[n]=0               ' A])
B=num2str(ax+bh);
C=num2str(bx+ah);
D=strcat(' n >',num2str(bx+bh));

if ax+bh<ah+bx % B<C
text(0.2,0.7,['\fontsize{14}' INT1 '   ' num2str(ax+ah) '\leqn<' B])
text(0.2,0.5,['\fontsize{14}' INT2 '   ' B '\leqn\leq ' C])
text(0.2,0.3,['\fontsize{14}'  INT3 '    '  C '< n\leq ' num2str(bx+bh)])
end
if ax+bh>ah+bx % B>C
text(0.2,0.7,['\fontsize{14}' INT1 '   '  num2str(ax+ah) '\leqn<' C])
text(0.2,0.5,['\fontsize{14}' INT2 '   ' C '\leqn\leq' B])
text(0.2,0.3,['\fontsize{14}'  INT3 '    '  B '< n\leq ' num2str(bx+bh)])
end
if (ax+bh)==(ah+bx)% B=C
text(0.2,0.7,['\fontsize{14}' INT1 '   '  num2str(ax+ah) '\leqn<  ' C])
text(0.2,0.5,['\fontsize{14}'  INT2 '     n=' C])
text(0.2,0.3,['\fontsize{14}' INT3 '    ' B '< n\leq ' num2str(bx+bh)])    
end
 text(0.2,0.1,['\fontsize{14}y[n]=0                   ' D])

% --- Executes on button press in FL.
function FL_Callback(hObject, eventdata, handles)
% hObject    handle to FL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colordef black
con_Callback(hObject, eventdata, handles)
global ax bx ah bh 
n=ax:bx;
global tx_ x_ th_ h_
tx_=n;
x_=eval(get(handles.xt,'String'));
n=ah:bh;
h_=eval(get(handles.ht,'String'));
n=-fliplr(n);
th_=n;
h_=fliplr(h_);
stem(handles.yy2,tx_,x_)
hold on
stem(handles.yy2,th_,h_-1,'rx')
hold off
grid(handles.yy2,'on')


% --- Executes on button press in Animate.
function Animate_Callback(hObject, eventdata, handles)
% hObject    handle to Animate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

con_Callback(hObject, eventdata, handles)
global ax ah bx bh yy m
a=ax+ah;
b=bx+bh;
k=0;
for i=a:b
%axes(handles.yy1)
k=k+1;
set(handles.SLDR,'Value',i);
stem(handles.yy1,i,yy(k),'fill'),hold(handles.yy1,'on')
stem(handles.yy1,m,yy),hold(handles.yy1,'off')
grid(handles.yy1,'on')
pause(0.25)
SLDR_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Help:','COVOLVE: For convolution results','OL: For Overlapping Regions',' FL: For Flip Version of signal', 'Animate:For Animating convolution overlapping'})
pause(1)
winopen('PROJECT REPORT_.docx')
function SV_Callback(hObject, eventdata, handles)
% hObject    handle to SV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SV as text
%        str2double(get(hObject,'String')) returns contents of SV as a double
S_V=fix(eval(get(handles.SV,'String')));
set(handles.SV,'String',S_V)
con_Callback(hObject, eventdata, handles) 
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


% --- Executes on button press in continuous.
function continuous_Callback(hObject, eventdata, handles)
% hObject    handle to continuous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh 
Sig_Project

% --- Executes on button press in mfile.
function mfile_Callback(hObject, eventdata, handles)
% hObject    handle to mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit Sig_Project_Disc
