function varargout = main(varargin)
% MAIN M-file for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 19-Oct-2005 23:51:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);
f = uimenu(hObject,'Label','Option');
h = uimenu(hObject,'Label','Help');
uimenu(f,'Label','Font','callback',@font_callback);
uimenu(h,'Label','Help','callback','web help.htm -browser');

    a_q = findall(0,'tag','axes_Q');
    a_t = findall(0,'tag','axes_T');
    axes(a_t);
    ylt = ylabel('Temperature');
    xlt = xlabel('Time');
    axes(a_q);
    ylq = ylabel('Heat');
    xlq = xlabel('Time');
    global ylt xlt ylq xlq
    
set(hObject,'CloseRequestFcn',@closefunc)
radio_butt_handle = findall(0,'tag','single_butt');
set(radio_butt_handle,'value',1)
axes_handle_2 = findall(0,'tag','axes7');
set(axes_handle_2,'vis','off');
axes_handle_3 = findall(0,'tag','axes8');
set(axes_handle_3,'vis','off');
axes_handle_1 = findall(0,'tag','axes_image_1');
set(axes_handle_1,'vis','on');
global V11 W1  Stop_time1 V1 d1 Cp1 Tr1 C_type V21;
    V11='40';
    W1='30000';
    Stop_time1='20';
    V21='40';
    Cp1='4200';
    d1='1000';
    Tr1='50';
    
    aimage = findall(0,'tag','axes_image_1');
    set(aimage,'DataAspectRatio',[1 1 1],'vis','off')
    axes(aimage)
    for i=0:.1:.4
        k=1-2*i;
        h_rec(10*i+1)=rectangle('pos',[i i  k k],'Curvature',[1,1]);
    end
    C_type = 1;
% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in property.
function property_Callback(hObject, eventdata, handles)
% hObject    handle to property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V11 W1  Stop_time1 V1 d1 Cp1 Tr1 V21
global V1 W  Stop_time V2 d Cp Tr
hbutt = findall(0,'tag','single_butt');
if get(hbutt,'val')
    hp = inputdlg({'Flow rate(kg/hr)' 'Volume(m^3)' 'heat capacity' 'density' 'set point' 'Stop time(hr)' },...
        ' ',1,{W1 V11 Cp1 d1 Tr1 Stop_time1});
    if  length(hp) == 0
        hp(1) = {W1};
        hp(2) = {V1};
        hp(3) = {Cp1};
        hp(4) = {d1};
        hp(5) = {Tr1};
        hp(6) = {Stop_time1};
    else
        hp = str2double(hp);
        W=hp(1);
        V1=hp(2);
        Cp=hp(3);
        d=hp(4);
        Tr=hp(5);
        Stop_time=hp(6);
    end
    Tc = d*V1/W;
%     if Tc < 10
%         Tc=num2str(Tc);
%         msg = 'Tc = ';
%         msg = [ msg Tc '(s)'];
%         W = W/3600;
%         b = questdlg({msg,' progrom convert flow rate to Kg/hr','pleas set the time'},'recommendation','ok','ok');
%         if strcmp(b,'ok')  
%             Stop_time = str2double(inputdlg({'Stop time(hr)' },...
%             ' ',1,{Stop_time1}));
%         end
%     end
    W1=num2str(W);
    V11=num2str(V1);
    Cp1=num2str(Cp);
    d1=num2str(d);
    Tr1=num2str(Tr);
    Stop_time1=num2str(Stop_time);
    
else

   hp = inputdlg({'Flow rate(kg/hr)' 'Volume 1(m^3)'  'volume 2(m^3)' 'heat capacity' 'density' 'set point' 'Stop time(h)' },...
        ' ',1,{W1 V11 V21 Cp1 d1 Tr1  Stop_time1});
    if length(hp) == 0
        hp(1) = {W1};
        hp(2) = {V11};
        hp(3) = {V21};
        hp(4) = {Cp1};
        hp(6) = {Tr1};
        hp(7) = {Stop_time1};
        hp(5) = {d1};
    else
        hp=str2double(hp);
        W=hp(1);
        V1=hp(2);
        V2=hp(3);
        Cp=hp(4);
        d=hp(5);
        Tr=hp(6);
        Stop_time=hp(7);
    end
%     Tc = d*V1/W;
%     if Tc > 1000
%         Tc=num2str(Tc);
%         msg = 'Tc = ';
%         msg = [ msg Tc '(s)'];
%         W = W/3600;
%         b = questdlg({msg,'progrom convert flow rate to Kg/hr','pleas set the time'},'recommendation','ok','ok');
%         if strcmp(b,'ok')  
%             Stop_time = str2double(inputdlg({'Stop time(hr)' },...
%             ' ',1,{Stop_time1}));
%         end
%     end

    W1=num2str(W);
    V11=num2str(V1);
    Cp1=num2str(Cp);
    d1=num2str(d);
    Tr1=num2str(Tr);
    Stop_time1=num2str(Stop_time);
    V21=num2str(V2);
end

% --- Executes on button press in controller.
function controller_Callback(hObject, eventdata, handles)
% hObject    handle to controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pid
% --- Executes on button press in signal.
function signal_Callback(hObject, eventdata, handles)
% hObject    handle to signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

signal
% --- Executes on button press in type.
function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

type
% --- Executes on button press in pair_butt.
function pair_butt_Callback(hObject, eventdata, handles)
% hObject    handle to pair_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pair_butt
global C_type
hbar = findall(0,'tag','hbar');
if ishandle(hbar)
    delete(hbar)
end
radio_butt_handle = findall(0,'tag','single_butt');
set(radio_butt_handle,'value',0)
axes_handle_1 = findall(0,'tag','axes_image_1');
child_image = allchild(axes_handle_1);
set(child_image,'vis','off')
set(axes_handle_1,'vis','off');
axes_handle_2 = findall(0,'tag','axes7');
set(axes_handle_2,'vis','on');
axes_handle_3 = findall(0,'tag','axes8');
set(axes_handle_3,'vis','on');

 set(axes_handle_2,'DataAspectRatio',[1 1 1],'vis','off')
    axes(axes_handle_2)
    for i=0:.1:.4
        k=1-2*i;
        h_rec1(10*i+1)=rectangle('pos',[i i  k k],'Curvature',[1,1]);
    end
    set(axes_handle_3,'DataAspectRatio',[1 1 1],'vis','off')
    axes(axes_handle_3)
    for i=.0:.1:.4
        k=1-2*i;
        h_rec2(10*i+1)=rectangle('pos',[i i  k k],'Curvature',[1,1]);
    end
clear radio_butt_handle axes_handle_2 child2 axes_handle_3 axes_handle_1
clear child3 child1
pack
C_type = 2;
% --- Executes on button press in single_butt.
function single_butt_Callback(hObject, eventdata, handles)
% hObject    handle to single_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of single_butt
hbar = findall(0,'tag','hbar');
if ishandle(hbar)
    delete(hbar)
end
global C_type
radio_butt_handle = findall(0,'tag','pair_butt');
set(radio_butt_handle,'value',0)
axes_handle_2 = findall(0,'tag','axes7');
child2 = allchild(axes_handle_2);
set(child2,'vis','off');
set(axes_handle_2,'vis','off');
axes_handle_3 = findall(0,'tag','axes8');
child3 = allchild(axes_handle_3);
set(child3,'vis','off');
set(axes_handle_3,'vis','off');
axes_handle_1 = findall(0,'tag','axes_image_1');
child1 = allchild(axes_handle_1);
set(child1,'vis','on');
clear radio_butt_handle axes_handle_2 child2 axes_handle_3 axes_handle_1
clear child3 child1
pack
C_type = 1;
% --------------------------------------------------------------------
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grid
% --------------------------------------------------------------------
function cmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%---------------------------------------------------------------------
function closefunc(hObject, eventdata, handles)
   h = findall(0,'type','figure');
   set(h,'closereq','closereq')
   close all
   
%---------------------------------------------------------------------  
function font_callback(hObject, eventdata, handles)
   global ylt xlt ylq xlq
   r = uisetfont(ylt,'Update Font');
   a_q = findall(0,'tag','axes_Q');
   a_t = findall(0,'tag','axes_T');
   fh = [xlt; ylq ;xlq];
   set(fh,r);
   set(a_q,r);
   set(a_t,r);