function varargout = MATHCAD(varargin)
% MATHCAD M-file for MATHCAD.fig
%      MATHCAD, by itself, creates a new MATHCAD or raises the existing
%      singleton*.
%
%      H = MATHCAD returns the handle to a new MATHCAD or the handle to
%      the existing singleton*.
%
%      MATHCAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATHCAD.M with the given input arguments.
%
%      MATHCAD('Property','Value',...) creates a new MATHCAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MATHCAD_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MATHCAD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help MATHCAD

% Last Modified by GUIDE v2.5 28-Jan-2008 23:46:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MATHCAD_OpeningFcn, ...
                   'gui_OutputFcn',  @MATHCAD_OutputFcn, ...
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


% --- Executes just before MATHCAD is made visible.
function MATHCAD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MATHCAD (see VARARGIN)

% Choose default command line output for MATHCAD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MATHCAD wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear
clc
axis([0 10 0 10])
set(gca,'color','k')
set(gcf,'color','k')
box off
% for i=1:5;
%
%     if i==1
%         [x(i),y(i)]=ginput(1);
%     else
%
%         [x(i),y(i)]=ginput(1);
%         plot(x(1:i),y(1:i),'w')
%         axis([0 10 0 10])
%
%         set(gca,'color','k')
%         set(gcf,'color','k')
%         hold on
%         pause(0.25)
%     end
% end

% --- Outputs from this function are returned to the command line.
function varargout = MATHCAD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in li.
function li_Callback(hObject, eventdata, handles)
% hObject    handle to li (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
set(handles.dia2,'string','>>')
set(handles.dia1,'string','>> Enter The First Point ...')
[a1,b1]=ginput(1);
pause(0.25)
set(handles.dia1,'string','>> Enter The Second Point ...')
[a2,b2]=ginput(1);
line([a1,a2],[b1,b2],'color','w')
set(gca,'color','k')
set(gcf,'color','k')
set(handles.dia1,'string','>> LINE ...')
set(handles.dia2,'string','>> DONE ...')

% --- Executes on button press in rec.
function rec_Callback(hObject, eventdata, handles)
% hObject    handle to rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.dia1,'string','>>')
set(handles.dia1,'string','>> Select The First Corner ...')
hold on
[a1,b1]=ginput(1);
plot(a1,b1,'w')
set(handles.dia1,'string','>> Select The Second Corner ...')
pause(0.25)
[a2,b2]=ginput(1);
plot(a2,b2,'w')
line([a1 a2],[b1 b1],'color','w')
hold on
line([a1 a2],[b2 b2],'color','w')
hold on
line([a1 a1],[b1 b2],'color','w')
hold on
line([a2 a2],[b1 b2],'color','w')
hold off
set(handles.dia1,'string','>> RECTANGULAR')
set(handles.dia2,'string','>> DONE........')

% --- Executes on button press in cir.
function cir_Callback(hObject, eventdata, handles)
% hObject    handle to cir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
set(handles.dia2,'string','>>')
set(handles.dia1,'string','>> Select The Center Of The Circle ...')
[a1,b1]=ginput(1);
set(handles.dia1,'string','>> Select Point On The Circle ...')
[a2,b2]=ginput(1);
a=a2-a1;
b=b2-b1;
theta=0:360;
r=sqrt((a^2)+(b^2));
x=a1+(r.*cosd(theta));
y=b1+(r.*sind(theta));

plot(x,y,'w',a1,b1,'w+')
set(gca,'color','k')
set(gcf,'color','k')
set(handles.dia1,'string','>> CIRCLE ...')
set(handles.dia2,'string','>> DONE ...')
hold off

% --- Executes on button press in arc.
function arc_Callback(hObject, eventdata, handles)
% hObject    handle to arc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.dia2,'string','>>')
set(handles.dia1,'string','>> Select The First Point ...')
hold on
[a1,b1]=ginput(1);
set(handles.dia1,'string','>> Select The Second Point ...')
pause(0.25)
[a2,b2]=ginput(1);
set(handles.dia1,'string','>> Select The Third Point Between The Two Previous  ...')
pause(0.25)
[a3,b3]=ginput(1);
a=[a1 a3 a2];
b=[b1 b3 b2];
plot(a1,b1,'w',a2,b2,'w',a3,b3,'w')
set(gca,'color','k')
set(gcf,'color','k')
p=polyfit(a,b,2);
y=linspace(min(a),max(a),50);
y1=polyval(p,y);
hold on
plot(y,y1,'w')
set(gca,'color','k')
set(gcf,'color','k')
set(handles.dia1,'string','>> ARC ...')
set(handles.dia2,'string','>> DONE ... ')

% --- Executes on button press in spline.
function spline_Callback(hObject, eventdata, handles)
% hObject    handle to spline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
set(handles.dia2,'string','>>')
set(handles.dia1,'string','>> Enter The Degree Of The Spline...')
set(handles.dia2,'string','The Degree Between [ 1 , 7 ] Is >>')
pause(5)

a=get(handles.dia2,'string');
l=length(a);
if l==34
    set(handles.dia1,'string','')
    set(handles.dia2,'string','')
elseif l==35
    b='The Degree Between [ 1 , 7 ] Is >>0';
    s=a-b;
    s=sum(s);
    for i=1:(s+1)
        [m(i),n(i)]=ginput(1);
        pause(0.25)
        plot(m(i),n(i),'w')
        set(gca,'color','k')
        set(gcf,'color','k')

    end
    % plot(m,n,'w')
    set(gca,'color','k')
    set(gcf,'color','k')
    p=polyfit(m,n,s);
    xx=linspace(min(m),max(m),50);
    y=polyval(p,xx);
    hold on
    plot(xx,y,'w')
    set(gca,'color','k')
    set(gcf,'color','k')
    set(handles.dia1,'string',' THE SPLINE...')
    set(handles.dia2,'string',' DONE...')
else
    set(handles.dia1,'string','....WARNING....','foregroundcolor','r')
    set(handles.dia2,'string','error occure try again','foregroundcolor','r')
    pause(1)
     set(handles.dia1,'string','....WARNING....','foregroundcolor','k')
    set(handles.dia2,'string','error occure try again','foregroundcolor','k')
end

% --- Executes on button press in earse.
function earse_Callback(hObject, eventdata, handles)
% hObject    handle to earse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
set(handles.dia2,'string','>>')
set(handles.dia1,'string','>> Enter The First Corner ...')
[a1,b1]=ginput(1);
pause(0.25)
set(handles.dia1,'string','>> Enter The Second Corner ...')
[a2,b2]=ginput(1);
hori1x=[a1 a2];
hori1y=[b1,b1];
hori2x=[a1 a2];
hori2y=[b2,b2];
ver1x=[a1,a1];
ver1y=[b1,b2];
ver2x=[a2,a2];
ver2y=[b1,b2];
x=[hori1x,ver2x,ver1x,hori2x];
y=[hori1y,ver2y,ver1y,hori2y];
patch(x,y,'k')
set(gca,'color','k')
set(gcf,'color','k')
set(handles.dia1,'string','>> ERASE ...')
set(handles.dia2,'string','>> DONE ...')
hold off





function dia2_Callback(hObject, eventdata, handles)
% hObject    handle to dia2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dia2 as text
%        str2double(get(hObject,'String')) returns contents of dia2 as a double


% --- Executes during object creation, after setting all properties.
function dia2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dia2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dia1_Callback(hObject, eventdata, handles)
% hObject    handle to dia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dia1 as text
%        str2double(get(hObject,'String')) returns contents of dia1 as a double


% --- Executes during object creation, after setting all properties.
function dia1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in nett.
function nett_Callback(hObject, eventdata, handles)
% hObject    handle to nett (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web(['http://www.esnips.com/web/matlabusers'], '-browser');



% --------------------------------------------------------------------
function Nem_Callback(hObject, eventdata, handles)
% hObject    handle to Nem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pho_Callback(hObject, eventdata, handles)
% hObject    handle to pho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web(['http://www.esnips.com/doc/4f4afbfc-4a27-46c8-b431-11ec11c91ee8/MATHCAD-photo'], '-browser');
% --------------------------------------------------------------------
function cli_Callback(hObject, eventdata, handles)
% hObject    handle to cli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web(['http://www.esnips.com/doc/5154461b-b165-41d0-8ec9-a4c35c5dbcf5/MATHCAD-tutorial_1'], '-browser');

% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function me_Callback(hObject, eventdata, handles)
% hObject    handle to me (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web(['http://www.esnips.com/user/ABDEL-RAHMAN'], '-browser');

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in re.
function re_Callback(hObject, eventdata, handles)
% hObject    handle to re (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on

a1=0;,b1=0;

a2=10;,b2=10;
hori1x=[a1 a2];
hori1y=[b1,b1];
hori2x=[a1 a2];
hori2y=[b2,b2];
ver1x=[a1,a1];
ver1y=[b1,b2];
ver2x=[a2,a2];
ver2y=[b1,b2];
x=[hori1x,ver2x,ver1x,hori2x];
y=[hori1y,ver2y,ver1y,hori2y];
patch(x,y,'k')
set(gca,'color','k')
set(gcf,'color','k')
set(handles.dia1,'string','>> RESET ...')
set(handles.dia2,'string','>> DONE ...')
hold off


% --------------------------------------------------------------------
function Key1_Callback(hObject, eventdata, handles)
% hObject    handle to Key1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web(['http://www.esnips.com/doc/f254ba06-361e-4593-bbb5-291d45e16828/MATHCAD-operation-of-keys'], '-browser');

