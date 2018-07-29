function varargout = FUN_PLOTTER(varargin)
% FUN_PLOTTER MATLAB code for FUN_PLOTTER.fig
%      FUN_PLOTTER, by itself, creates a new FUN_PLOTTER or raises the existing
%      singleton*.
%
%      H = FUN_PLOTTER returns the handle to a new FUN_PLOTTER or the handle to
%      the existing singleton*.
%
%      FUN_PLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUN_PLOTTER.M with the given input arguments.
%
%      FUN_PLOTTER('Property','Value',...) creates a new FUN_PLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FUN_PLOTTER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FUN_PLOTTER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FUN_PLOTTER

% Last Modified by GUIDE v2.5 13-Feb-2013 04:22:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FUN_PLOTTER_OpeningFcn, ...
                   'gui_OutputFcn',  @FUN_PLOTTER_OutputFcn, ...
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


% --- Executes just before FUN_PLOTTER is made visible.
function FUN_PLOTTER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FUN_PLOTTER (see VARARGIN)

% Choose default command line output for FUN_PLOTTER
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FUN_PLOTTER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FUN_PLOTTER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
warning off
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'sin(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,sind(thta),'linewidth',3)
    set(handles.text1,'string','SINE PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'cos(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,cosd(thta),'linewidth',3)
    set(handles.text1,'string','COSINE PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'tan(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,tand(thta),'linewidth',3)
    set(handles.text1,'string','TANGENT PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'cot(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,cotd(thta),'linewidth',3)
    set(handles.text1,'string','COTANGENT PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'sec(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,secd(thta),'linewidth',3)
    set(handles.text1,'string','SECANT PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'csc(x)';
v = get(handles.checkbox2,'value');
if v == 1
    thta = 0:3*360;
    axes(handles.axes1)
    plot(thta,cscd(thta),'linewidth',3)
    set(handles.text1,'string','COSECANT PLOT FROM 0 TO 6*PI')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z x
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'log(t)';
v = get(handles.checkbox2,'value');
if v == 1
    x = 0:0.25:10;
    axes(handles.axes1)
    plot(x,log(x),'linewidth',3)
    set(handles.text1,'string','LOGRITHMIC PLOT FROM 0 TO 10')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z x
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
z = 'exp(t)';
v = get(handles.checkbox2,'value');
if v == 1
    x = 0:0.25:10;
    axes(handles.axes1)
    plot(x,exp(x),'linewidth',3)
    set(handles.text1,'string','EXPONENTIAL PLOT FROM 0 TO 10')
    grid on
else
    msgbox('PLZ SET RANGE...TRY AGAIN','WARNING','warn','modal')
    set(handles.text1,'string','')
    cla(handles.axes1)
    reset(handles.axes1)
    set(handles.axes1,'box','on')
    set(handles.axes1,'xtick',[])
    set(handles.axes1,'ytick',[])
    return
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
set(handles.checkbox3,'value',0)
set(handles.edit1,'enable','inactive')
set(handles.edit2,'enable','inactive')
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
set(handles.checkbox2,'value',0)
set(handles.edit1,'enable','on')
set(handles.edit2,'enable','on')

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z p1
v = get(handles.checkbox2,'value');
if v == 1
    msgbox('CAN NOT WORK ON DEFAULT RANGE','WARNING','warn','modal')
    return
end
v1 = get(handles.checkbox3,'value');
if v1 == 0
    msgbox('FIRST SET RANGE','WARNING','warn','modal')
    return
end
a = str2double(get(handles.edit1,'string'));
b = str2double(get(handles.edit2,'string'));
if a > b
    msgbox('MIN IS GR8ER THAN MAX','WARNING','warn','modal')
    set(handles.edit1,'string','')
    set(handles.edit2,'string','')
    return
end
fx2 = get(handles.edit3,'string');
z = fx2;
if isempty(fx2) || isempty(a) || isempty(b)
    msgbox('EITHER MAX OR MIN OR FUNCTION FIELD IS EMPTY OR INVALID','WARNING...','modal')
    set(handles.edit1,'string','')
    set(handles.edit2,'string','')
    set(handles.edit3,'string','')
    return
end
fx3 = inline(fx2);
p1 = a:0.25:b;
p2 = p1;
for l = 1:length(p2)
    mag(l) = fx3(p2(l));
end
axes(handles.axes1)
plot(p2,mag,'linewidth',3)
grid on
set(handles.text1,'string',strcat('PLOT OF ',fx2,' FROM RANGE ',num2str(a),' TO ',num2str(b)))

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta x p1
d = z;
k = z;
switch k
    case 'sin(x)'
        fx = sym(k);
        n = str2double(inputdlg('INPUT ORDER OF DIFFRENTIATION','DY/DX'));
        if isnan(n)
            return
        end
        fx1 = diff(fx,n);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('sin\theta','d(sin\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF SIN(X) AND SIN(X)')
    case 'cos(x)'
        fx = sym(k);
        n = str2double(inputdlg('INPUT ORDER OF DIFFRENTIATION','DY/DX'));
        if isnan(n)
            return
        end
        fx1 = diff(fx,n);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('cos\theta','d(cos\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF COS(X) AND COS(X)')
    case 'tan(x)'
        fx = sym(k);
        fx1 = diff(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('tan\theta','d(tan\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF TAN(X) AND TAN(X)')
    case 'cot(x)'
        fx = sym(k);
        fx1 = diff(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('cot\theta','d(cot\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF COT(X) AND COT(X)')
    case 'sec(x)'
        fx = sym(k);
        fx1 = diff(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('sec\theta','d(sec\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF SEC(X) AND SEC(X)')
    case 'csc(x)'
        fx = sym(k);
        fx1 = diff(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'r','linewidth',3)
        grid on
        %legend('csc\theta','d(csc\theta)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF CSC(X) AND CSC(X)')
    case 'log(t)'
        fx = sym(k);
        fx1 = diff(fx);
        r = x;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'r','linewidth',3)
        grid on
        %legend('log(x)','d(log(x))/dx')
        set(handles.text1,'string','DIFFRENTIATION OF LOG(X) AND LOG(X)')
    case 'exp(t)'
        fx = sym(k);
        fx1 = diff(fx);
        r = x;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'r','linewidth',1.5)
        grid on
        %legend('e^x','d(e^x)/dx')
        set(handles.text1,'string','DIFFRENTIATION OF EXP(X) AND EXP(X)')
    case d
        fx = sym(k);
        fx1 = diff(fx);
        r = p1;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'r','linewidth',1.8)
        grid on
        %legend(d,strcat('d(',d,')/dx'))
        set(handles.text1,'string',strcat('DIFFRENTIATION OF ',d,' AND ',d))
end
        
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z thta x p1
d = z;
k = z;
switch k
    case 'sin(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('sin\theta','d(sin\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF SIN(X) AND SIN(X)')
    case 'cos(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('cos\theta','d(cos\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF COS(X) AND COS(X)')
    case 'tan(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('tan\theta','d(tan\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF TAN(X) AND TAN(X)')
    case 'cot(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('cot\theta','d(cot\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF COT(X) AND COT(X)')
    case 'sec(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('sec\theta','d(sec\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF SEC(X) AND SEC(X)')
    case 'csc(x)'
        fx = sym(k);
        fx1 = int(fx);
        for l = 1:length(thta)
            mag(l) = subs(fx1,deg2rad(thta(l)));
        end
        axes(handles.axes1)
        hold on
        plot(thta,mag,'g','linewidth',3)
        grid on
        %legend('csc\theta','d(csc\theta)/dx')
        set(handles.text1,'string','INTEGRATION OF CSC(X) AND CSC(X)')
    case 'log(t)'
        fx = sym(k);
        fx1 = int(fx);
        r = x;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'g','linewidth',3)
        grid on
        %legend('log(x)','d(log(x))/dx')
        set(handles.text1,'string','INTEGRATION OF LOG(X) AND LOG(X)')
    case 'exp(t)'
        fx = sym(k);
        fx1 = int(fx);
        r = x;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'g','linewidth',1.5)
        grid on
        %legend('e^x','d(e^x)/dx')
        set(handles.text1,'string','INTEGRATION OF EXP(X) AND EXP(X)')
        
     case d
        fx = sym(k);
        fx1 = int(fx);
        r = p1;
        for l = 1:length(r)
            mag(l) = subs(fx1,r(l));
        end
        axes(handles.axes1)
        hold on
        plot(r,mag,'g','linewidth',2.3)
        grid on
        %legend(d,strcat('d(',d,')/dx'))
        set(handles.text1,'string',strcat('INTEGRATION OF ',d,' AND ',d))
end


% --------------------------------------------------------------------
function CL_EAR_Callback(hObject, eventdata, handles)
% hObject    handle to CL_EAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])
set(handles.edit1,'string','')
set(handles.edit2,'string','')
set(handles.edit3,'string','')
set(handles.checkbox2,'value',0)
set(handles.checkbox3,'value',0)

% --------------------------------------------------------------------
function EXI_T_Callback(hObject, eventdata, handles)
% hObject    handle to EXI_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --------------------------------------------------------------------
function CLEAR_AXES_Callback(hObject, eventdata, handles)
% hObject    handle to CLEAR_AXES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1)
reset(handles.axes1)
set(handles.axes1,'box','on')
set(handles.axes1,'xtick',[])
set(handles.axes1,'ytick',[])