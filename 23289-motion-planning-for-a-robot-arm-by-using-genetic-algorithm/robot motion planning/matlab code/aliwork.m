function varargout = aliwork(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aliwork_OpeningFcn, ...
                   'gui_OutputFcn',  @aliwork_OutputFcn, ...
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


% --- Executes just before aliwork is made visible.
function aliwork_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for aliwork
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aliwork wait for user response (see UIRESUME)
% uiwait(handles.figure1);
if strcmp(get(hObject,'Visible'),'off')
    axes(handles.axes1);
    cla
    set(handles.pushbutton8, 'Visible', 'on');
    set(handles.pushbutton9, 'Visible', 'on');
    set(handles.pushbutton10, 'Visible', 'off');
    set(handles.pushbutton11, 'Visible', 'off');
    set(handles.pushbutton3, 'Visible', 'off');
    set(handles.pushbutton1, 'Visible', 'off');
    set(handles.pushbutton4, 'Visible', 'off');
    set(handles.pushbutton5, 'Visible', 'off');
    set(handles.phi, 'Visible', 'off');
    set(handles.obx, 'Visible', 'off');
    set(handles.oby, 'Visible', 'off');
    set(handles.text3, 'Visible', 'off');
    set(handles.text6, 'Visible', 'off');
    set(handles.text7, 'Visible', 'off');
    set(handles.uipanel3, 'Visible', 'off');
    
end
% --- Outputs from this function are returned to the command line.
function varargout = aliwork_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x1_Callback(hObject, eventdata, handles)
x1 = str2double(get(hObject, 'String'));
if isnan(x1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.x1 = x1;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y1_Callback(hObject, eventdata, handles)

y1 = str2double(get(hObject, 'String'));
if isnan(y1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.y1 = y1;
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
function y1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phi_Callback(hObject, eventdata, handles)
phi = str2double(get(hObject, 'String'));
if isnan(phi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.phi = phi*pi/180;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phi_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x2_Callback(hObject, eventdata, handles)
x2 = str2double(get(hObject, 'String'));
if isnan(x2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.x2 = x2;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y2_Callback(hObject, eventdata, handles)
y2 = str2double(get(hObject, 'String'));
if isnan(y2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.y2 = y2;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obx_Callback(hObject, eventdata, handles)
obx = str2mat(get(hObject, 'String'));
if isnan(obx)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.obx = obx;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obx_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function oby_Callback(hObject, eventdata, handles)
oby = str2mat(get(hObject, 'String'));
if isnan(oby)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.metricdata.oby = oby;
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function oby_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)

%preview plot______ 3LINK with obstacles

axes(handles.axes1);
cla;
axis([-2.7 2.7 -2.7 2.7])
x1=handles.metricdata.x1;
y1=handles.metricdata.y1;
phi=handles.metricdata.phi;
x2=handles.metricdata.x2;
y2=handles.metricdata.y2;
if sqrt(x2^2+y2^2) > 2.5
    warndlg('non valid final conditions..... change the final conditions','!! error !!')
    clear
    return
end
obx=eval(handles.metricdata.obx);
oby=eval(handles.metricdata.oby);
if length(obx)~=length(oby) | any(sqrt(obx.^2+oby.^2) > 2.7)
    warndlg('non valid oblacles conditions..... change the obstacles conditions','!! error !!')
    clear
    return
end
[k,a]=invkini(x1,y1,phi);
if k > 1 | sqrt(x1^2+y1^2) > 2.5
    warndlg('non valid initial conditions..... change the initial conditions','!! error !!')
    clear
    return
end
a=a';
[xt,yt]=angls2links(a);
rx=.35;ry=.35;shx=obx;shy=oby;
n=length(shx);
l=linspace(0,2*pi,30);
m=length(l);
xv=repmat(rx*cos(l)',1,n)+repmat(shx,m,1);
yv=repmat(ry*sin(l)',1,n)+repmat(shy,m,1);
xv=[xv;xv(1,:)];
yv=[yv;yv(1,:)];
c1=xv+i*yv;
plot(c1,'r')
hold on
plot(xt,yt)
plot(x2,y2,'r+')
shx=0;shy=0;
rx=2.5;ry=2.5;
l=linspace(0,2*pi);
xv=rx*cos(l)'+shx;yv=ry*sin(l)'+shy;
ox2=[xv;xv(1)];oy2=[yv;yv(1)];
plot(ox2,oy2,'m:')
axis([-2.7 2.7 -2.7 2.7])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton2_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

t=get(hObject, 'Value');
switch t
    case 1  %2 links free
        axes(handles.axes1);
        cla
        set(handles.pushbutton8, 'Visible', 'on');
        set(handles.pushbutton9, 'Visible', 'on');
        set(handles.pushbutton10, 'Visible', 'off');
        set(handles.pushbutton11, 'Visible', 'off');
        set(handles.pushbutton3, 'Visible', 'off');
        set(handles.pushbutton1, 'Visible', 'off');
        set(handles.pushbutton4, 'Visible', 'off');
        set(handles.pushbutton5, 'Visible', 'off');
        set(handles.phi, 'Visible', 'off');
        set(handles.obx, 'Visible', 'off');
        set(handles.oby, 'Visible', 'off');
        set(handles.text3, 'Visible', 'off');
        set(handles.text6, 'Visible', 'off');
        set(handles.text7, 'Visible', 'off');
        set(handles.uipanel3, 'Visible', 'off');
        
        
    case 2  % 2links with obstacle
        axes(handles.axes1);
        cla
        set(handles.pushbutton10, 'Visible', 'on');
        set(handles.pushbutton11, 'Visible', 'on');
        set(handles.pushbutton8, 'Visible', 'off');
        set(handles.pushbutton9, 'Visible', 'off');
        set(handles.pushbutton3, 'Visible', 'off');
        set(handles.pushbutton1, 'Visible', 'off');
        set(handles.pushbutton4, 'Visible', 'off');
        set(handles.pushbutton5, 'Visible', 'off');
        set(handles.phi, 'Visible', 'off');
        set(handles.obx, 'Visible', 'on');
        set(handles.oby, 'Visible', 'on');
        set(handles.text3, 'Visible', 'off');
        set(handles.text6, 'Visible', 'on');
        set(handles.text7, 'Visible', 'on');
        set(handles.uipanel3, 'Visible', 'on');
        
        
        
    case 3  %3links free obstacles
        axes(handles.axes1);
        cla
        set(handles.pushbutton3, 'Visible', 'off');
        set(handles.pushbutton1, 'Visible', 'off');
        set(handles.pushbutton4, 'Visible', 'on');
        set(handles.pushbutton5, 'Visible', 'on');
        set(handles.pushbutton8, 'Visible', 'off');
        set(handles.pushbutton9, 'Visible', 'off');
        set(handles.pushbutton10, 'Visible', 'off');
        set(handles.pushbutton11, 'Visible', 'off');
        set(handles.phi, 'Visible', 'on');
        set(handles.obx, 'Visible', 'off');
        set(handles.oby, 'Visible', 'off');
        set(handles.text3, 'Visible', 'on');
        set(handles.text6, 'Visible', 'off');
        set(handles.text7, 'Visible', 'off');
        set(handles.uipanel3, 'Visible', 'off');
    case 4   %3links with obstacle 
        axes(handles.axes1);
        cla
        set(handles.pushbutton3, 'Visible', 'on');
        set(handles.pushbutton1, 'Visible', 'on');
        set(handles.pushbutton4, 'Visible', 'off');
        set(handles.pushbutton5, 'Visible', 'off');
        set(handles.pushbutton8, 'Visible', 'off');
        set(handles.pushbutton9, 'Visible', 'off');
        set(handles.pushbutton10, 'Visible', 'off');
        set(handles.pushbutton11, 'Visible', 'off');
        set(handles.phi, 'Visible', 'on');
        set(handles.obx, 'Visible', 'on');
        set(handles.oby, 'Visible', 'on');
        set(handles.text3, 'Visible', 'on');
        set(handles.text6, 'Visible', 'on');
        set(handles.text7, 'Visible', 'on');
        set(handles.uipanel3, 'Visible', 'on');
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject, 'String', {'2links free','2links with obstacle','3links free','3links with obstacles'})

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

%preview plot _________ 3links free 

axes(handles.axes1);
cla;
axis([-2.7 2.7 -2.7 2.7])
x1=handles.metricdata.x1;
y1=handles.metricdata.y1;
phi=handles.metricdata.phi;
x2=handles.metricdata.x2;
y2=handles.metricdata.y2;
[k,a]=invkini(x1,y1,phi);
if k > 1
    warndlg('non valid initial conditions..... change the initial conditions','!! eror !!')
    clear
    return
end
if sqrt(x2^2+y2^2) > 2.5
    warndlg('non valid final conditions..... change the final conditions','!! error !!')
    clear
    return
end
a=a';
[xt,yt]=angls2links(a);
hold on
plot(xt,yt)
plot(x2,y2,'r+')
shx=0;shy=0;
rx=2.5;ry=2.5;
l=linspace(0,2*pi);
xv=rx*cos(l)'+shx;yv=ry*sin(l)'+shy;
ox2=[xv;xv(1)];oy2=[yv;yv(1)];
plot(ox2,oy2,'m:')
axis([-2.7 2.7 -2.7 2.7])



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
grid 

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)

% previw plot _________ 2links free

axes(handles.axes1);
cla;
axis([-2.7 2.7 -2.7 2.7])
x1=handles.metricdata.x1;
y1=handles.metricdata.y1;
x2=handles.metricdata.x2;
y2=handles.metricdata.y2;
if sqrt(x1^2+y1^2) > 2
    warndlg('non valid initial conditions..... change the initial conditions','!! error !!')
    clear
    return
end
if sqrt(x2^2+y2^2) > 2
    warndlg('non valid final conditions..... change the final conditions','!! error !!')
    clear
    return
end
a1=invkin(x1,y1);
a2=invkin(x2,y2);
[xt1,yt1]=angls2links2(a1');
[xt2,yt2]=angls2links2(a2');
plot(xt1,yt1,xt2,yt2),hold on

shx=0;shy=0;
rx=2;ry=2;
l=linspace(0,2*pi);
xv=rx*cos(l)'+shx;yv=ry*sin(l)'+shy;
ox2=[xv;xv(1)];oy2=[yv;yv(1)];
plot(ox2,oy2,'m:')
axis([-2.7 2.7 -2.7 2.7])

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)

% previw plot _________ 2links obstacle

axes(handles.axes1);
cla;
axis([-2.7 2.7 -2.7 2.7])
x1=handles.metricdata.x1;
y1=handles.metricdata.y1;
x2=handles.metricdata.x2;
y2=handles.metricdata.y2;
if sqrt(x1^2+y1^2) > 2
    warndlg('non valid initial conditions..... change the initial conditions','!! error !!')
    clear
    return
end
if sqrt(x2^2+y2^2) > 2
    warndlg('non valid final conditions..... change the final conditions','!! error !!')
    clear
    return
end
obx=eval(handles.metricdata.obx);
oby=eval(handles.metricdata.oby);
if length(obx)~=1|length(oby)~=1
    warndlg('invalid obstacle input data','!! error !!')
    clear
    return
end
if sqrt(obx^2+oby^2) > 2.5
    warndlg('The obstacle is out of rigion','!! error !!')
    clear
    return
end
a1=invkin(x1,y1);
a2=invkin(x2,y2);
[xt1,yt1]=angls2links2(a1');
[xt2,yt2]=angls2links2(a2');
shx=obx;shy=oby;
rx=.35;ry=0.35;
l=linspace(0,2*pi,20);
xv=rx*cos(l)'+shx;yv=ry*sin(l)'+shy;
ox2=[xv;xv(1)];oy2=[yv;yv(1)];
c1=ox2+i*oy2;
plot(c1,'r')
hold on
plot(xt1,yt1,xt2,yt2)
shx=0;shy=0;
rx=2;ry=2;
l=linspace(0,2*pi);
xv=rx*cos(l)'+shx;yv=ry*sin(l)'+shy;
ox2=[xv;xv(1)];oy2=[yv;yv(1)];
plot(ox2,oy2,'m:')
axis([-2.7 2.7 -2.7 2.7])

