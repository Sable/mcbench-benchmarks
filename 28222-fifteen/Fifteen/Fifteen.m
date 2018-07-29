% Fifteen Game for MATLAB
% (c) 2010 Mihir Shah




function varargout = Fifteen(varargin)
% FIFTEEN M-file for Fifteen.fig
%      FIFTEEN, by itself, creates a new FIFTEEN or raises the existing
%      singleton*.
%
%      H = FIFTEEN returns the handle to a new FIFTEEN or the handle to
%      the existing singleton*.
%
%      FIFTEEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIFTEEN.M with the given input arguments.
%
%      FIFTEEN('Property','Value',...) creates a new FIFTEEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fifteen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fifteen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fifteen

% Last Modified by GUIDE v2.5 06-Jul-2010 16:20:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fifteen_OpeningFcn, ...
                   'gui_OutputFcn',  @Fifteen_OutputFcn, ...
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


% --- Executes just before Fifteen is made visible.
function Fifteen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fifteen (see VARARGIN)

% Choose default command line output for Fifteen
handles.output = hObject;
guidata(hObject, handles);
clc;
clear all;
global x;
x = zeros(4);
i=1;
while i<16 && i>0
    m = randi([1,4]);
    n = randi([1,4]);
    if x(m,n) == 0
        x(m,n) = i;
        i = i + 1;
    end
end
display(x);
global counter;
counter = 0;
tic
% Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = Fifteen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(handles.p_counter,'String','0');
set(handles.p_clock,'String','0');
varargout{1} = handles.output;

function a = access()
global x;
a = x;

% --- Executes on button press in p11.
function p11_Callback(hObject, eventdata, handles)
% hObject    handle to p11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global p;
p = 1;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
% if ~bcolor(1,2)
%     stra = get(handles.p11,'String');
%     strb = get(handles.p12,'String');
%     temp = stra;
%     stra = strb;
%     strb = temp;
%     set(handles.p11,'String',stra);
%     set(handles.p12,'String',strb);
%     set(handles.p11,'BackgroundColor','black');
%     bcolor(1,1) = 0;
%     bcolor(1,2) = 1;
%     set(handles.p12,'BackgroundColor','white');
% end
guidata(hObject, handles);


% --- Executes on button press in p12.
function p12_Callback(hObject, eventdata, handles)
global p;
p = 2;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p13.
function p13_Callback(hObject, eventdata, handles)
global p;
p = 3;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p14.
function p14_Callback(hObject, eventdata, handles)
global p;
p = 4;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p21.
function p21_Callback(hObject, eventdata, handles)
global p;
p = 5;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p22.
function p22_Callback(hObject, eventdata, handles)
global p;
p = 6;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p23.
function p23_Callback(hObject, eventdata, handles)
global p;
p = 7;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p24.
function p24_Callback(hObject, eventdata, handles)
global p;
p = 8;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p31.
function p31_Callback(hObject, eventdata, handles)
global p;
p = 9;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p32.
function p32_Callback(hObject, eventdata, handles)
global p;
p = 10;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p33.
function p33_Callback(hObject, eventdata, handles)
global p;
p = 11;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p34.
function p34_Callback(hObject, eventdata, handles)
global p;
p = 12;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p41.
function p41_Callback(hObject, eventdata, handles)
global p;
p = 13;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p42.
function p42_Callback(hObject, eventdata, handles)
global p;
p = 14;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p43.
function p43_Callback(hObject, eventdata, handles)
global p;
p = 15;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p44.
function p44_Callback(hObject, eventdata, handles)
global p;
p = 16;
p_setter_Callback(hObject, eventdata, handles)
p_slide_Callback(hObject, eventdata, handles)
p_win_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in p_new.
function p_new_Callback(hObject, eventdata, handles)

Fifteen;
x = access();
global bcolor;
bcolor = zeros(4);
p_initial_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

% --- Executes on button press in p_initial.
function p_initial_Callback(hObject, eventdata, handles)

x = access();
% set(handles.p_counter,'String','0');
for m=1:1:4
    for n=1:1:4
        s = ['set(handles.p' int2str(m) int2str(n) ',''BackgroundColor'',''white'')'];
        eval(s);
        if x(m,n) ~= 0
            s = ['set(handles.p' int2str(m) int2str(n) ',''String'',x(' int2str(m) ',' int2str(n) '))'];
            eval(s);
        else
            s = ['set(handles.p' int2str(m) int2str(n) ',''String'',x(' int2str(m) ',' int2str(n) '))'];
            eval(s);
            s = ['set(handles.p' int2str(m) int2str(n) ',''BackgroundColor'',''black'')'];
            eval(s);
        end
    end
end
guidata(hObject,handles);


% --- Executes on button press in p_slide.
function p_slide_Callback(hObject, eventdata, handles)
global bcolor;
global row;
global col;
global row_p;
global col_p;
global counter;
for m=1:1:4
    for n=1:1:4
        s = ['get(handles.p' int2str(m) int2str(n) ',''BackgroundColor'');'];
        z = eval(s);
        bcolor(m,n) = z(1);
        if bcolor(m,n) == 0
            row = m;
            col = n;
        end
    end
end
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if limit(row_p,col_p-1) && ~bcolor(row_p,col_p-1)
%     stra = get(handles.p11,'String');
    s1 = ['get(handles.p' int2str(row_p) int2str(col_p) ',''String'');'];
    stra = eval(s1);
%     strb = get(handles.p12,'String');
    s2 = ['get(handles.p' int2str(row_p) int2str(col_p-1) ',''String'');'];
    strb = eval(s2);
    temp = stra;
    stra = strb;
    strb = temp;
%     set(handles.p11,'String',stra);
    s3 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''String'',' stra ');'];
    eval(s3);
%     set(handles.p12,'String',strb);
    s4 = ['set(handles.p' int2str(row_p) int2str(col_p-1) ',''String'',' strb ');'];
    eval(s4);
%     bcolor(1,1) = 0;
%     bcolor(1,2) = 1;
    bcolor(row_p,col_p) = 0;
    bcolor(row_p,col_p-1) = 1;
%    set(handles.p11,'BackgroundColor','black');
    s5 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''BackgroundColor'',''black'');'];
    eval(s5);
%     set(handles.p12,'BackgroundColor','white');
    s6 = ['set(handles.p' int2str(row_p) int2str(col_p-1) ',''BackgroundColor'',''white'')'];
    eval(s6);
    counter = counter + 1;
    set(handles.p_counter,'String',counter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if limit(row_p,col_p+1) && ~bcolor(row_p,col_p+1)
    s1 = ['get(handles.p' int2str(row_p) int2str(col_p) ',''String'');'];
    stra = eval(s1);
    s2 = ['get(handles.p' int2str(row_p) int2str(col_p+1) ',''String'');'];
    strb = eval(s2);
    temp = stra;
    stra = strb;
    strb = temp;
    s3 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''String'',' stra ');'];
    eval(s3);
    s4 = ['set(handles.p' int2str(row_p) int2str(col_p+1) ',''String'',' strb ');'];
    eval(s4);
    bcolor(row_p,col_p) = 0;
    bcolor(row_p,col_p+1) = 1;
    s5 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''BackgroundColor'',''black'');'];
    eval(s5);
    s6 = ['set(handles.p' int2str(row_p) int2str(col_p+1) ',''BackgroundColor'',''white'')'];
    eval(s6);
    counter = counter + 1;
    set(handles.p_counter,'String',counter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if limit(row_p-1,col_p) && ~bcolor(row_p-1,col_p)
    s1 = ['get(handles.p' int2str(row_p) int2str(col_p) ',''String'');'];
    stra = eval(s1);
    s2 = ['get(handles.p' int2str(row_p-1) int2str(col_p) ',''String'');'];
    strb = eval(s2);
    temp = stra;
    stra = strb;
    strb = temp;
    s3 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''String'',' stra ');'];
    eval(s3);
    s4 = ['set(handles.p' int2str(row_p-1) int2str(col_p) ',''String'',' strb ');'];
    eval(s4);
    bcolor(row_p,col_p) = 0;
    bcolor(row_p-1,col_p) = 1;
    s5 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''BackgroundColor'',''black'');'];
    eval(s5);
    s6 = ['set(handles.p' int2str(row_p-1) int2str(col_p) ',''BackgroundColor'',''white'')'];
    eval(s6);
    counter = counter + 1;
    set(handles.p_counter,'String',counter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if limit(row_p+1,col_p) && ~bcolor(row_p+1,col_p)
    s1 = ['get(handles.p' int2str(row_p) int2str(col_p) ',''String'');'];
    stra = eval(s1);
    s2 = ['get(handles.p' int2str(row_p+1) int2str(col_p) ',''String'');'];
    strb = eval(s2);
    temp = stra;
    stra = strb;
    strb = temp;
    s3 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''String'',' stra ');'];
    eval(s3);
    s4 = ['set(handles.p' int2str(row_p+1) int2str(col_p) ',''String'',' strb ');'];
    eval(s4);
    bcolor(row_p,col_p) = 0;
    bcolor(row_p+1,col_p) = 1;
    s5 = ['set(handles.p' int2str(row_p) int2str(col_p) ',''BackgroundColor'',''black'');'];
    eval(s5);
    s6 = ['set(handles.p' int2str(row_p+1) int2str(col_p) ',''BackgroundColor'',''white'')'];
    eval(s6);
    counter = counter + 1;
    set(handles.p_counter,'String',counter);
end
guidata(hObject,handles);

function z = limit(row,col)

z1 = 0;
z2 = 0;
if row>0
    if row<5
        z1 = 1;
    end
end
if col>0
    if col<5
        z2 = 1;
    end
end
z = z1 && z2;


% --- Executes on button press in p_setter.
function p_setter_Callback(hObject, eventdata, handles)
global row_p;
global col_p;
global p;
switch p
    case 1  
            row_p = 1;
            col_p = 1;
    case 2 
            row_p = 1;
            col_p = 2;
    case 3 
            row_p = 1;
            col_p = 3;
    case 4 
            row_p = 1;
            col_p = 4;
    case 5  
            row_p = 2;
            col_p = 1;
    case 6 
            row_p = 2;
            col_p = 2;
    case 7 
            row_p = 2;
            col_p = 3;
    case 8 
            row_p = 2;
            col_p = 4;
    case 9  
            row_p = 3;
            col_p = 1;
    case 10 
            row_p = 3;
            col_p = 2;
    case 11 
            row_p = 3;
            col_p = 3;
    case 12 
            row_p = 3;
            col_p = 4;
    case 13  
            row_p = 4;
            col_p = 1;
    case 14 
            row_p = 4;
            col_p = 2;
    case 15 
            row_p = 4;
            col_p = 3;
    case 16 
            row_p = 4;
            col_p = 4;
end
guidata(hObject,handles);


% --- Executes on button press in p_win.
function p_win_Callback(hObject, eventdata, handles)
p = zeros(4);
for m=1:1:4
    for n=1:1:4
        s = ['get(handles.p' int2str(m) int2str(n) ',''String'');'];
        p(m,n) = str2double(eval(s));
    end
end
count = 0;
if p(1,1) == 1
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(1,2) == 2
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(1,3) == 3
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(1,4) == 4
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(2,1) == 5
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(2,2) == 6
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(2,3) == 7
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(2,4) == 8
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(3,1) == 9
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(3,2) == 10
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(3,3) == 11
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(3,4) == 12
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(4,1) == 13
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(4,2) == 14
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(4,3) == 15
    flag = 1;
    count = count + 1;
else flag = 0;
end

if p(4,4) == 0
    flag = 1;
    count = count + 1;
else flag = 0;
end

time = int2str(round(toc));
set(handles.p_clock,'String',time);
if flag == 1 && count == 16
    msgbox('Congratulations you have won !!!','Fifteen','help');
end
guidata(hObject,handles);
